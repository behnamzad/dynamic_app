import 'package:dynamic_app/infrastructure/network/model/api_response.dart';

abstract class LoginDataSource {
  Future<ApiResponse> login(String username, String password);
}
