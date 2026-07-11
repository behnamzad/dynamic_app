import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LoginDataSource {
  Future<ApiResponse<AuthResponse>> login(String email, String password);

  Future<ApiResponse<AuthResponse>> register(
    String email,
    String username,
    String password,
    String gender,
    int age,
  );

  Future<ApiResponse<bool>> isUsernameAvailable(String username);
}
