import 'dart:async';

import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/behavior/domain/repository/behavior_event_repository.dart';
import 'package:dynamic_app/shared/behavior/domain/repository/behavior_event_uploader.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// خلاصه یک چرخه sync؛ lifecycle یا ابزارهای عیب‌یابی از تعداد انتخاب و تأیید استفاده می‌کنند.
class BehaviorSyncResult {
  const BehaviorSyncResult({required this.selectedCount, required this.acknowledgedCount, this.skippedReason});

  final int selectedCount;
  final int acknowledgedCount;
  final String? skippedReason;

  bool get wasSkipped => skippedReason != null;
}

/// زمان‌بندی و هماهنگی sync؛ pendingها را batch می‌کند و فقط IDهای تأییدشده را synced می‌زند.
@lazySingleton
class BehaviorSyncCoordinator {
  BehaviorSyncCoordinator(this._repository, this._uploader, this._logger, this._userManager);

  static const defaultInterval = Duration(seconds: 20);
  static const defaultMaxRows = 100;
  static const defaultMaxBytes = 256 * 1024;

  final BehaviorEventRepository _repository;
  final BehaviorEventUploader _uploader;
  final BehaviorLogger _logger;
  final UserManager _userManager;

  Timer? _timer;
  bool _isSyncing = false;

  bool get isRunning => _timer?.isActive ?? false;

  /// در مرحله اتصال lifecycle اجرا می‌شود و sync دوره‌ای 20 ثانیه‌ای را آغاز می‌کند.
  void start({Duration interval = defaultInterval}) {
    if (isRunning) return;
    _debugLog('SyncCoordinator started; interval= ${interval.inSeconds}s');
    unawaited(syncNow());
    _timer = Timer.periodic(interval, (Timer timer) => unawaited(syncNow()));
  }

  void stop() {
    _debugLog('SyncCoordinator: sync_stopped');

    _timer?.cancel();
    _timer = null;
  }

  /// یک batch محدود را فوراً ارسال می‌کند؛ خطاها را ثبت و eventها را pending نگه می‌دارد.
  Future<BehaviorSyncResult> syncNow({int maxRows = defaultMaxRows, int maxBytes = defaultMaxBytes}) async {
    if (_isSyncing) {
      _debugLog('skipped: sync_already_running');
      return const BehaviorSyncResult(selectedCount: 0, acknowledgedCount: 0, skippedReason: 'sync_already_running');
    }
    final String? userId = _userManager.currentUserId;
    if (userId == null) {
      _debugLog('skipped: no_authenticated_user');
      return const BehaviorSyncResult(selectedCount: 0, acknowledgedCount: 0, skippedReason: 'no_authenticated_user');
    }

    _isSyncing = true;
    try {
      await _logger.attributeAnonymousHistoryToCurrentUser();
      final List<BehaviorEvent> batch = await _repository.getPendingBatch(
        userId: userId,
        maxRows: maxRows,
        maxBytes: maxBytes,
      );
      if (batch.isEmpty) {
        _debugLog('completed: no pending events for the authenticated user');
        return const BehaviorSyncResult(selectedCount: 0, acknowledgedCount: 0);
      }

      final Set<String> batchEventIds = batch.map((BehaviorEvent event) => event.eventId).toSet();
      _debugLog('uploading ${batchEventIds.length} pending event(s)');
      final DateTime attemptedAt = DateTime.now().toUtc();
      try {
        final Set<String> serverConfirmedEventIds = await _uploader.upload(batch);
        final Set<String> confirmedBatchEventIds = serverConfirmedEventIds.intersection(batchEventIds);
        await _repository.markSynced(confirmedBatchEventIds, DateTime.now().toUtc());
        final Set<String> unconfirmedBatchEventIds = batchEventIds.difference(confirmedBatchEventIds);
        if (unconfirmedBatchEventIds.isNotEmpty) {
          await _repository.markSyncFailed(
            unconfirmedBatchEventIds,
            'Server did not acknowledge these event IDs',
            attemptedAt,
          );
        }
        _debugLog('completed: selected=${batchEventIds.length}, acknowledged=${confirmedBatchEventIds.length}');
        return BehaviorSyncResult(
          selectedCount: batchEventIds.length,
          acknowledgedCount: confirmedBatchEventIds.length,
        );
      } catch (error) {
        _debugLog('failed: $error');
        await _repository.markSyncFailed(batchEventIds, error.toString(), attemptedAt);
        return BehaviorSyncResult(selectedCount: batchEventIds.length, acknowledgedCount: 0);
      }
    } finally {
      _isSyncing = false;
    }
  }

  @disposeMethod
  void dispose() => stop();

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[BehaviorSync] $message');
    }
  }
}
