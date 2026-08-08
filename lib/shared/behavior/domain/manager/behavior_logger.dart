import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/shared/behavior/domain/catalog/behavior_event_catalog.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_context.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_session_manager.dart';
import 'package:dynamic_app/shared/behavior/domain/repository/behavior_event_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

/// ورودی مرکزی ثبت رفتار؛ producerها draft می‌دهند و logger آن را فقط در دیتابیس محلی ذخیره می‌کند.
@lazySingleton
class BehaviorLogger {
  BehaviorLogger(
    this._repository,
    this._sessionManager,
    this._userManager,
    this._packageInfo,
  );

  static const currentSchemaVersion = 2;

  final BehaviorEventRepository _repository;
  final BehaviorSessionManager _sessionManager;
  final UserManager _userManager;
  final PackageInfo _packageInfo;
  final Uuid _uuid = const Uuid();

  /// پیش‌نویس را اعتبارسنجی و با هویت، نشست و زمینه کامل می‌کند، سپس شناسه ذخیره‌شده را برمی‌گرداند.
  /// todo : if [validateDraft] throw ArgumentError => handle to save errors in another file to handle in future
  Future<String> record(BehaviorEventDraft draft) async {
    BehaviorEventCatalog.validateDraft(draft);
    final DateTime now = DateTime.now().toUtc();
    final DateTime occurredAt = (draft.occurredAt ?? now).toUtc();
    final String sessionId = await _sessionManager.ensureActiveSession(
      now: occurredAt,
    );
    final String? authenticatedUserId = _userManager.currentUserId;
    final BehaviorEvent event = BehaviorEvent(
      eventId: _uuid.v4(),
      userId: authenticatedUserId ?? _sessionManager.anonymousId,
      anonymousId: _sessionManager.anonymousId,
      sessionId: sessionId,
      type: draft.type,
      eventTimestamp: occurredAt,
      clientGeneratedAt: now,
      appVersion: '${_packageInfo.version}+${_packageInfo.buildNumber}',
      schemaVersion: currentSchemaVersion,
      isAuthenticated: authenticatedUserId != null,
      subject: draft.product,
      payload: draft.payload,
      context: BehaviorEventContext(
        platform: _platformName,
        locale: draft.locale,
        isOnline: draft.isOnline,
        timeZoneOffsetMinutes: DateTime.now().timeZoneOffset.inMinutes,
        experimentId: draft.experimentId,
        cohortId: draft.cohortId,
      ),
      sourceScreen: draft.sourceScreen,
      destinationScreen: draft.destinationScreen,
      referrerScreen: draft.referrerScreen,
      durationMs: draft.durationMs,
      position: draft.position,
      status: draft.status,
    );
    await _repository.record(event);
    return event.eventId;
  }

  /// UI producers use this entry point so telemetry never delays or breaks the
  /// interaction that produced it. Validation/storage failures remain visible
  /// in debug builds while the application flow continues normally.
  void recordNonBlocking(BehaviorEventDraft draft) {
    _recordIgnoringFailure(draft);
  }

  Future<void> _recordIgnoringFailure(BehaviorEventDraft draft) async {
    try {
      await record(draft);
    } catch (error, stackTrace) {
      debugPrint(
        'Behavior event ${draft.type.wireName} was not recorded: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  /// پس از login، eventهای ناشناس و هنوز pending همین نصب را به کاربر فعلی منتسب می‌کند.
  Future<void> attributeAnonymousHistoryToCurrentUser() async {
    final String? userId = _userManager.currentUserId;
    if (userId == null) {
      return;
    }
    await _sessionManager.ensureActiveSession();
    await _repository.attributePendingAnonymousEvents(
      anonymousId: _sessionManager.anonymousId,
      userId: userId,
    );
  }

  String get _platformName => kIsWeb ? 'web' : defaultTargetPlatform.name;
}
