import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';

/// قرارداد ارسال شبکه‌ای؛ sync coordinator به آن وابسته است و از Supabase مستقیم خبر ندارد.
abstract interface class BehaviorEventUploader {
  /// بسته را می‌فرستد و پس از موفقیت درخواست، شناسه‌های همان بسته را برمی‌گرداند.
  Future<Set<String>> upload(List<BehaviorEvent> events);
}

