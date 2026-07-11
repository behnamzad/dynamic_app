class SupabaseConfig {
  const SupabaseConfig._();

  // تنظیمات اصلی پروژه Supabase؛ شروع اتصال در main.dart با همین مقادیر انجام می‌شود.
  static const url = 'https://llqiiczktwalbvzxlkqr.supabase.co';
  static const publishableKey = 'sb_publishable_4LNjkfDEzS1RPKJ7ABQ47w_uY0qHLva';
  static String normalizeEmail(String email) {
    // Supabase Auth برای ورود با رمز، ایمیل واقعی کاربر را نیاز دارد.
    return email.trim().toLowerCase();
  }
}
