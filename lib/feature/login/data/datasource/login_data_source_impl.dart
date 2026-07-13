import 'package:dynamic_app/di/di_const.dart';
import 'package:dynamic_app/infrastructure/network/dio_caller.dart';
import 'package:dynamic_app/infrastructure/network/model/api_error.dart';
import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:dynamic_app/infrastructure/supabase/supabase_config.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_data_source.dart';

@Injectable(as: LoginDataSource)
class LoginDataSourceImpl implements LoginDataSource {
  final SupabaseClient _client;
  final DioCaller _dioCaller;
  final Logger _logger;

  LoginDataSourceImpl(this._client, @Named(DiConst.dioSupabaseRest) this._dioCaller, this._logger);

  @override
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    try {
      // شروع عملیات لاگین از LoginPage -> LoginBloc -> LoginRepo -> این dataSource انجام می‌شود.
      _logger.d('Supabase Auth login started for email: $email');
      final response = await _client.auth.signInWithPassword(
        email: SupabaseConfig.normalizeEmail(email),
        password: password,
      );
      _logger.d('Supabase Auth login finished. userId: ${response.user}');

      return ApiResponse.completed(data: response);
    } on AuthException catch (e) {
      _logger.e('Supabase Auth login failed: ${e.message}');
      return ApiResponse.error(apiError: InvalidPasswordOrUsername(e.message, e.statusCode));
    } catch (e) {
      _logger.e('Supabase Auth login failed: $e');
      return ApiResponse.error(apiError: UncaughtError(e.toString()));
    }
  }

  @override
  Future<ApiResponse<AuthResponse>> register(
    String email,
    String username,
    String password,
    String gender,
    int age,
  ) async {
    try {
      // شروع عملیات ثبت‌نام از دکمه ثبت‌نام LoginPage است و اینجا به Supabase Auth ارسال می‌شود.
      _logger.d('Supabase Auth register started for email: $email username: $username');
      final response = await _client.auth.signUp(
        email: SupabaseConfig.normalizeEmail(email),
        password: password,
        data: {
          // ایمیل را Supabase Auth خودش در user.email نگه می‌دارد؛ metadata فقط دیتای تکمیلی اپ است.
          'username': username.trim(),
          'gender': gender,
          'age': age,
        },
      );
      _logger.d('Supabase Auth register finished. userId: ${response.user?.id}');

      return ApiResponse.completed(data: response);
    } on AuthException catch (e) {
      _logger.e('Supabase Auth register failed: ${e.message}');
      return ApiResponse.error(apiError: BadRequest(e.message, e.statusCode));
    } catch (e) {
      _logger.e('Supabase Auth register failed: $e');
      return ApiResponse.error(apiError: UncaughtError(e.toString()));
    }
  }

  @override
  Future<ApiResponse<bool>> isUsernameAvailable(String username) {
    // RPC نام کاربری نیز از DioCaller می‌گذرد تا همه خطاها به ApiResponse تبدیل شوند.
    return _dioCaller.post<bool>(
      'rpc/is_username_available',
      data: {'input_username': username.trim()},
      fromJson: (json) => json == true,
    );
  }
}
