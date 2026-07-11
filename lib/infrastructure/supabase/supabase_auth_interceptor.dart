import 'package:dio/dio.dart';
import 'package:dynamic_app/infrastructure/supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthInterceptor extends Interceptor {
  final SupabaseClient _client;

  SupabaseAuthInterceptor(this._client);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // این interceptor از NetworkModule شروع می‌شود و همه درخواست‌های REST Supabase را احراز هویت می‌کند.
    final accessToken = _client.auth.currentSession?.accessToken;

    options.headers['apikey'] = SupabaseConfig.publishableKey;
    options.headers['Authorization'] = 'Bearer ${accessToken ?? SupabaseConfig.publishableKey}';
    options.headers['Content-Type'] = 'application/json';

    handler.next(options);
  }
}
