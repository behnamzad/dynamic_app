import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/feature/login/data/datasource/login_data_source.dart';
import 'package:dynamic_app/feature/login/domain/repository/login_repo.dart';

@Injectable(as: LoginRepo)
class LoginRepoImpl implements LoginRepo {
  final LoginDataSource _dataSource;

  LoginRepoImpl({
    required LoginDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<ApiResponse> login(String username, String password) async {
    try {
      return _dataSource.login(username, password);
    } catch (e) {
      rethrow;
    }
  }
}
