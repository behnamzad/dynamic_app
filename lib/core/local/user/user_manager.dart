import 'package:dynamic_app/core/local/setting_manager.dart';
import 'package:dynamic_app/core/local/user/enum/user_register_status.dart';
import 'package:dynamic_app/core/local/user/enum/user_status.dart';
import 'package:dynamic_app/core/local/user/user.dart';
import 'package:dynamic_app/core/util/extension/string_ext.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserManager {
  User? _currentUser;

  User? get currentUser => _currentUser;
  SettingsManager settingsManager;

  UserManager(this.settingsManager);

  bool isUserRegistered() {
    if (_currentUser != null && _currentUser?.userStatus == UserStatus.registered) {
      return true;
    }
    return _tryLogin();
  }

  bool isUserActivated() {
    if (_currentUser != null) {
      return true;
    }
    return _tryActivate();
  }

  notifyOpenDeposit(User currentUser) {
    notifyOnChangePassword(currentUser);
  }

  bool _tryActivate({User? grUser}) {
    if (true) {
      User user = grUser ?? User()
        ..nationalCode = settingsManager.getNationalCode()
        ..phoneNumber = settingsManager.getMobileNumber()
        ..openDepositStatus = 1 // settingsManager.getOpenDepositStatus()//todo
        ..userNickname = settingsManager.getUserNickname()
        ..userGender = settingsManager.getUserGender()
        ..userRegisterStatus = settingsManager.getUserRegisterStatus()
        ..userStatus = settingsManager.getUserStatus()
        ..username = settingsManager.getUserName()
        ..password = settingsManager.getPassword();
      activateUser(user);
      return true;
    }
    return false;
  }

  bool _tryLogin() {
    if (_currentUser?.userStatus == UserStatus.registered) {
      User user = User();
      user.username = settingsManager.getUserName();
      user.password = settingsManager.getPassword();
      return _tryActivate(grUser: user);
    }
    return false;
  }


  login(User user) {
    settingsManager.setUserName(user.username ?? '');
    settingsManager.setPassword(user.password ?? '');
    _currentUser = user;
  }

  notifyOnChangePassword(User user) {
    if (user.password.isNotNullOrBlank) {
      settingsManager.setPassword(user.password ?? '');
      _currentUser = user;
    }
  }


  notifyOnChangeUsername(User user) {
    settingsManager.setUserName(user.username ?? '');
    _currentUser = user;
  }

  activateUser(User user, {bool? needToLogin, bool? needToOpenDeposit}) {
    try {
      settingsManager.setMobileNumber(user.phoneNumber);
      settingsManager.setNationalCode(user.nationalCode);
      settingsManager.setUserRegisterStatus(user.userRegisterStatus);
      settingsManager.setUserStatus(user.userStatus);
      settingsManager.setUserNickname(user.userNickname);
      settingsManager.setUserGender(user.userGender);
    } catch (e) {}
    if (user.username != null) settingsManager.setUserName(user.username!);


    try {

    } catch (e) {}
    _currentUser = user;
  }

  notifyUserStatus(User user) {
    settingsManager.setUserStatus(user.userStatus);
    _currentUser = user;
  }

  notifyUsernameCif(String username, String cif) {
    User user = _currentUser!;
    user.username = username;
    user.cif = cif;
    settingsManager.setUserName(username);
    activateUser(user);
  }

  notifyUser(User user) {
    settingsManager.setMobileNumber(user.phoneNumber);
    // settingsManager.setNationalCode(user.nationalCode);
    // settingsManager.setOpenDepositToken(user.openDepositToken);
    // settingsManager.setOpenDepositStatus(user.openDepositStatus);
    // settingsManager.setUserRegisterStatus(user.userRegisterStatus);
    // settingsManager.setUserStatus(user.userStatus);
    settingsManager.setUserNickname(user.userNickname);
    // settingsManager.setUserGender(user.userGender);


    _currentUser = user;
  }

  logoutUser() {
    _currentUser = null;
  }

  bool isRegisterDone() {
    bool isRegisterDone = false;
    if (_currentUser != null) {
      isRegisterDone = (_currentUser!.userRegisterStatus == UserRegisterStatus.verified ||
          _currentUser!.userRegisterStatus == UserRegisterStatus.waitForUsername ||
          _currentUser!.userRegisterStatus == UserRegisterStatus.complete);
    }
    return isRegisterDone;
  }

  String getPublicKey() {
    if (_currentUser != null) {
      return _currentUser!.publicKey;
    } else {
      return '';
    }
  }


  bool isAcceptedAgreement() {
    bool isAcceptedAgreement = settingsManager.isAcceptedAgreement();
    return isAcceptedAgreement;
  }


}
