import 'package:dynamic_app/infrastructure/network/model/api_response.dart';

abstract class LoginRepo {
  Future<ApiResponse> login(String username, String password);
}
