import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/feature/login/data/datasource/login_data_source.dart';
import 'package:dynamic_app/feature/login/domain/repository/login_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


@Injectable(as: LoginRepo)
class LoginRepoImpl implements LoginRepo {
  final LoginDataSource _dataSource;

  LoginRepoImpl({required LoginDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    try {
      return _dataSource.login(email, password);
    } catch (e) {
      rethrow;
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
      return _dataSource.register(email, username, password, gender, age);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> isUsernameAvailable(String username) async {
    try {
      return _dataSource.isUsernameAvailable(username);
    } catch (e) {
      rethrow;
    }
  }
}
