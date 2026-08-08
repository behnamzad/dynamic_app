import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_context.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';

/// درخواست خام ثبت event؛ featureهای UI در مرحله instrumentation این مدل را به BehaviorLogger می‌دهند.
class BehaviorEventDraft {
  const BehaviorEventDraft({
    required this.type,
    this.product = const BehaviorProductSnapshot(),
    this.payload = const EmptyBehaviorPayload(),
    this.sourceScreen,
    this.destinationScreen,
    this.referrerScreen,
    this.durationMs,
    this.position,
    this.status,
    this.occurredAt,
    this.locale,
    this.isOnline,
    this.experimentId,
    this.cohortId,
  });

  final BehaviorEventType type;
  final BehaviorProductSnapshot product;
  final BehaviorEventPayload payload;
  final String? sourceScreen;
  final String? destinationScreen;
  final String? referrerScreen;
  final int? durationMs;
  final int? position;
  final String? status;
  final DateTime? occurredAt;
  final String? locale;
  final bool? isOnline;
  final String? experimentId;
  final String? cohortId;
}

/// رویداد کامل و قابل ذخیره؛ ثبت‌کننده هویت، نشست، زمان، نسخه و زمینه را به پیش‌نویس اضافه می‌کند.
class BehaviorEvent {
  const BehaviorEvent({
    required this.eventId,
    required this.userId,
    required this.anonymousId,
    required this.sessionId,
    required this.type,
    required this.eventTimestamp,
    required this.clientGeneratedAt,
    required this.appVersion,
    required this.schemaVersion,
    required this.isAuthenticated,
    required this.subject,
    required this.payload,
    required this.context,
    this.sourceScreen,
    this.destinationScreen,
    this.referrerScreen,
    this.durationMs,
    this.position,
    this.status,
  });

  final String eventId;
  final String userId;
  final String anonymousId;
  final String sessionId;
  final BehaviorEventType type;
  final DateTime eventTimestamp;
  final DateTime clientGeneratedAt;
  final String appVersion;
  final int schemaVersion;
  final bool isAuthenticated;
  final BehaviorProductSnapshot subject;
  final BehaviorEventPayload payload;
  final BehaviorEventContext context;
  final String? sourceScreen;
  final String? destinationScreen;
  final String? referrerScreen;
  final int? durationMs;
  final int? position;
  final String? status;
}
