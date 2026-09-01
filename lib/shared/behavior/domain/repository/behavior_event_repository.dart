import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';

/// قرارداد صف محلی برای دامنه؛ logger و sync coordinator مصرف‌کننده‌های اصلی آن هستند.
abstract interface class BehaviorEventRepository {
  /// ثبت‌کننده رفتار از این متد برای ذخیره پایدار و صرفاً محلی استفاده می‌کند.
  Future<void> record(BehaviorEvent event);

  /// فیچر prediction سابقه همان کاربر را برای ساخت ورودی مدل می‌خواند.
  Future<List<BehaviorEvent>> getUserHistory(String userId);

  /// هماهنگ‌کننده همگام‌سازی با این متد بسته‌ای محدود به تعداد و حجم می‌سازد.
  Future<List<BehaviorEvent>> getPendingBatch({
    required String userId,
    required int maxRows,
    required int maxBytes,
  });

  Future<void> markSynced(Set<String> acknowledgedEventIds, DateTime syncedAt);

  Future<void> markSyncFailed(
    Set<String> eventIds,
    String error,
    DateTime attemptedAt,
  );

  Future<int> pendingCount();

  Future<void> attributePendingAnonymousEvents({
    required String anonymousId,
    required String userId,
  });
}
