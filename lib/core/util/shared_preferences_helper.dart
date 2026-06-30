import 'dart:async';
import 'dart:convert';

import 'package:dynamic_app/core/util/crypto/keystore_gcm_crypto_helper.dart';
import 'package:dynamic_app/core/util/extension/string_ext.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crypto/encrypt_helper.dart';

@injectable
class SharedPreferencesHelper {
  SharedPreferences sharePrefs;
  final EncryptHelper encryptHelper;

  final String keyGcm = '_gcm'; // warning don't rename this '_gcm'

  SharedPreferencesHelper({required this.encryptHelper, required this.sharePrefs});

  bool getBool(String key, {bool? defaultValue}) {
    return sharePrefs.getBool(key) ?? defaultValue ?? false;
  }

  Future<bool> setBool(String key, bool value) async {
    return sharePrefs.setBool(key, value);
  }

  int getInt(String key, {int? defaultValue}) {
    return sharePrefs.getInt(key) ?? defaultValue ?? 0;
  }

  Future<bool> setInt(String key, int value) async {
    return sharePrefs.setInt(key, value);
  }

  List<String> getStringList(String key, {List<String>? defaultValue}) {
    return sharePrefs.getStringList(key) ?? defaultValue ?? [];
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return sharePrefs.setStringList(key, value);
  }

  String getString(String key, {String? defaultValue}) {
    return sharePrefs.getString(key) ?? defaultValue ?? '';
  }

  getJsonObject(String key, {String? defaultValue}) {
    var strObj = sharePrefs.getString(key) ?? defaultValue ?? '{}';
    return json.decode(strObj);
  }

  Future<bool> setJsonObject(String key, Object object) async {
    return setString(key, json.encode(object));
  }

  Future<bool> setString(String key, String value) async {
    return sharePrefs.setString(key, value);
  }

  Future<bool> setStringAndEncrypt(String key, String value) async {
    var isMigrateDone = migrateDataFromCbcToGcm(key);
    if (isMigrateDone) {
      return true;
    } else {
      return _setStringByGcm(value, key);
    }
  }

  String getEncryptedString(String key, {String? defaultValue}) {
    migrateDataFromCbcToGcm(key);
    String clearValue = decryptByGcm(key);
    return clearValue.isNotNullOrBlank ? clearValue : defaultValue ?? '';
  }

  Future<double> getDouble(String key, {double? defaultValue}) async {
    return sharePrefs.getDouble(key) ?? defaultValue ?? 0;
  }

  Future<bool> setDouble(String key, double value) async {
    return sharePrefs.setDouble(key, value);
  }

  Future<bool> remove(String key) async {
    return sharePrefs.remove(key);
  }

  dynamic getEncryptedJsonObject(String key, {String? defaultValue}) {
    var strObj = getEncryptedString(key);
    strObj = strObj;
    return strObj.isNotEmpty ? json.decode(strObj) : '{}';
  }

  Future<bool> setJsonObjectAndEncrypt(String key, Object object) async {
    return setStringAndEncrypt(key, json.encode(object));
  }

  bool migrateDataFromCbcToGcm(String key) {
    final isContainsOldCbcKey = sharePrefs.containsKey(key);
    if (!isContainsOldCbcKey) return false;

    final encryptedValueCbc = sharePrefs.getString(key);
    if (encryptedValueCbc == null) {
      if (kDebugMode) {
        print('No data found to migrate for key: $key');
      }
      return false;
    }

    final aesCbcDecryptedData = decryptOldCbc(encryptedValueCbc);
    if (aesCbcDecryptedData == null) {
      if (kDebugMode) {
        print('Failed to decrypt the data with the old CBC method.');
      }
      return false;
    }

    //for save in gcm mode this key convert to ['$key$keyGcm'] in _setStringByGcm
    _setStringByGcm(aesCbcDecryptedData, key);

    //finally remove OldCbcKey for prevent to migrate again
    // check by sharePrefs.containsKey(key) in top of migrateDataFromCbcToGcm
    sharePrefs.remove(key);
    if (kDebugMode) {
      print('key: $key Data migrated successfully.');
    }
    return true;
  }

  _setStringByGcm(String data, String key) {
    final encryptedValueGcm = _encryptByGcm(data);
    return sharePrefs.setString('$key$keyGcm', encryptedValueGcm);
  }

  String _encryptByGcm(String data) {
    KeystoreGcmCryptoHelper aesHandler = inject();
    final encryptedValueGcm = aesHandler.encrypt(data);
    return encryptedValueGcm;
  }

  String decryptByGcm(String key) {
    KeystoreGcmCryptoHelper aesHandler = inject();
    var base64EncryptedData = sharePrefs.getString('$key$keyGcm');
    return aesHandler.decrypt(base64EncryptedData);
  }

  decryptOldCbc(String encryptedData) {
    try {
      return encryptHelper.decryptCbcByPasswordKey(encryptedData);
    } catch (e) {
      return null;
    }
  }
}
