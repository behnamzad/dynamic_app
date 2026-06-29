import 'dart:convert';


import 'package:dynamic_app/core/local/user/enum/gender.dart';
import 'package:dynamic_app/core/local/user/enum/user_register_status.dart';
import 'package:dynamic_app/core/local/user/enum/user_status.dart';
import 'package:dynamic_app/core/util/app_logger.dart';
import 'package:dynamic_app/core/util/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsManager {
  final SharedPreferencesHelper prefs;

  SettingsManager(this.prefs);


  final String _userNicknameKey = 'user_N_N_K';
  final String _userNameKey = 'user_N_K';
  final String _passwordKey = 'p_w_K';

  final String _userStatusKey = 'user_S_K';
  final String _userGenderKey = 'user_g_K';
  final String _userRegisterStatusKey = 'user_R_S_K';
  final String _deviceIdKey = 'device_I_K';
  final String _nationalCodeKey = 'national_C_K';
  final String _mobileNumberKey = 'mobile_N_K';
  final String _agreementIsAcceptedKey = 'agreement_i_a_K';
  final String _themeKeyValue = 'theme_key_value';

  Future<bool> setTheme(ThemeMode themMode) async {
    return prefs.setString(_themeKeyValue, themMode.name);
  }

  String getTheme() {
    return prefs.getString(_themeKeyValue, defaultValue: ThemeMode.system.name);
  }

  setDeviceId(String deviceId) {
    prefs.setStringAndEncrypt(_deviceIdKey, deviceId);
  }

  getDeviceId() {
    return prefs.getEncryptedString(_deviceIdKey, defaultValue: '');
  }

  setUserName(String userName) {
    prefs.setStringAndEncrypt(_userNameKey, userName);
  }

  String getUserName() {
    return prefs.getEncryptedString(_userNameKey);
  }


  setPassword(String pass) {
    prefs.setStringAndEncrypt(_passwordKey, pass);
  }

  String getPassword() {
    return prefs.getEncryptedString(_passwordKey);
  }

  setMobileNumber(String mobile) {
    prefs.setStringAndEncrypt(_mobileNumberKey, mobile);
  }

  getMobileNumber() {
    return prefs.getEncryptedString(_mobileNumberKey);
  }

  setNationalCode(String nationalCode) {
    prefs.setStringAndEncrypt(_nationalCodeKey, nationalCode);
  }

  getNationalCode() {
    return prefs.getEncryptedString(_nationalCodeKey);
  }
  setUserRegisterStatus(UserRegisterStatus userRegisterStatus) {
    prefs.setString(_userRegisterStatusKey, userRegisterStatus.name);
  }

  getUserRegisterStatus() {
    return UserRegisterStatus.values.byName(prefs.getString(_userRegisterStatusKey));
  }
  setUserStatus(UserStatus userStatus,{String? callFrom}) {
    try {
      if(callFrom!=null) {
        AppLogger.debugLog('callFrom : $callFrom and new userStatus is:${userStatus.name}');
      }
    }catch(_){}

    prefs.setString(_userStatusKey, userStatus.name);

    try {
      AppLogger.debugLog('getUserStatus : ${(prefs.getString(_userStatusKey))}');
    }catch(_){}
  }

  getUserStatus() {
    return UserStatus.values.byName(prefs.getString(_userStatusKey));
  }

  setUserGender(Gender userGender) {
    prefs.setString(_userGenderKey, userGender.name);
  }

  getUserGender() {
    return Gender.values.byName(prefs.getString(_userGenderKey));
  }

  String getUserNickname() {
    return prefs.getEncryptedString(_userNicknameKey);
  }

  setUserNickname(String userNickname) {
    prefs.setStringAndEncrypt(_userNicknameKey, userNickname);
  }

  setAcceptedAgreement(bool isSent) {
    prefs.setBool(_agreementIsAcceptedKey, isSent);
  }

  bool isAcceptedAgreement() {
    return prefs.getBool(_agreementIsAcceptedKey);
  }
}
