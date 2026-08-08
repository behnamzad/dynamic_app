import 'package:dynamic_app/shared/behavior/data/models/behavior_event_dto.dart';

/// قرارداد دسترسی به صف محلی؛ repository برای درج، خواندن pendingها و ثبت نتیجه sync از آن استفاده می‌کند.
abstract interface class BehaviorLocalDataSource {
  /// رویداد تازه را با وضعیت درانتظار داخل SQLite درج می‌کند.
  Future<void> insert(BehaviorEventDto event);

  /// قدیمی‌ترین رویدادهای درانتظار کاربر را برای ساخت بسته می‌خواند.
  Future<List<BehaviorEventDto>> getPending({
    required String userId,
    required int limit,
  });

  /// فقط IDهایی را که سرور تأیید کرده synced می‌کند.
  Future<void> markSynced(Set<String> eventIds, DateTime syncedAt);

  /// شکست ارسال را ثبت می‌کند ولی وضعیت event را pending نگه می‌دارد.
  Future<void> markSyncFailed(
    Set<String> eventIds,
    String error,
    DateTime attemptedAt,
  );

  /// تعداد eventهای ارسال‌نشده را برای وضعیت صف برمی‌گرداند.
  Future<int> pendingCount();

  /// رویدادهای ناشناس پیش از ورود را به حسابی که بعداً وارد شده منتسب می‌کند.
  Future<void> attributePendingAnonymousEvents({
    required String anonymousId,
    required String userId,
  });

  /// تمام eventهای محلی، شامل pending و synced، را حذف می‌کند و تعداد ردیف‌های حذف‌شده را برمی‌گرداند.
  Future<int> deleteAllEvents();
}
