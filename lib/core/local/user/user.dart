import 'package:dynamic_app/core/local/user/enum/gender.dart';
import 'package:dynamic_app/core/local/user/enum/user_register_status.dart';
import 'package:dynamic_app/core/local/user/enum/user_status.dart';

class User {
  late String phoneNumber;
  late String nationalCode;
  String? username;
  String? password; //todo encrypt later
  late String userNickname;
  late String accessToken;
  late String publicKey;
  String? cif;
  late Gender userGender;

  late String openDepositToken;
  late String bearerToken;
  late String refreshToken;
  late String cookie;
  late String adaToken;
  late int openDepositStatus;
  String? accountRecoveryToken;

  UserRegisterStatus userRegisterStatus = UserRegisterStatus.waitForVerify;
  UserStatus userStatus = UserStatus.unknown;
  String? fcmToken;
}
