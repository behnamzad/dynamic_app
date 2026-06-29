import 'package:dynamic_app/di/di_const.dart';
import 'package:dynamic_app/infrastructure/network/dio_caller.dart';
import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:injectable/injectable.dart';

import 'login_data_source.dart';

@Injectable(as: LoginDataSource)
class LoginDateSourceImpl implements LoginDataSource {
  final DioCaller dioCaller;

  LoginDateSourceImpl({@Named(DiConst.dioNamedLogin) required this.dioCaller});

  @override
  Future<ApiResponse> login(String username, String password) {
    return dioCaller.post('login',
        data: {
          'username': 'username',
          'password': 'password',
        },
        fromJson: () {});
  }
}
