import 'dart:async';

import 'package:dynamic_app/core/config/configs.dart';
import 'package:dynamic_app/core/util/app_device_info_util.dart';
import 'package:dynamic_app/core/util/common_bloc_imports.dart';

@LazySingleton(dispose: disposeNetworkUtils)
class NetworkUtils {
  final AppDeviceInfoUtil appDeviceInfoUtil;
  final SettingsManager settingsManager;
  bool isEncryptionEnabled = true;

  NetworkUtils(this.appDeviceInfoUtil, this.settingsManager);

  void dispose() {
    // logic to dispose instance
  }

  Map<String, dynamic> getDefaultHeaders({bool addTestData = false, bool isAddOneApiTokenToHeaders = false}) {
    Map<String, dynamic> headers = {
      // 'app_name': appDeviceInfoUtil.packageName,
      // 'device_id': appDeviceInfoUtil.deviceId,

      /// If the version is less than 8, the exchange(user/security) service gives an error
      'app_version': appDeviceInfoUtil.appVersion,
      'device_model': appDeviceInfoUtil.deviceModel,
      'device_brand': appDeviceInfoUtil.deviceBrand,
      'net_type': 'WIFI',
      'os_version': appDeviceInfoUtil.osVersion,
      'os_name': appDeviceInfoUtil.osName,
      'deviceId': appDeviceInfoUtil.deviceId,
      'device-Id': appDeviceInfoUtil.deviceId,
      'is_device_rooted': 'false',
      'ip_address': '192.168.1.6',
      'platform': 'net',
    };

    if (isAddOneApiTokenToHeaders) {
      var token = inject<Configs>().oneApiToken;
      headers.putIfAbsent('one-api-token', () => token);
    }

    if (addTestData) {
      headers.putIfAbsent('addTestData', () => addTestData);
    }

    return headers;
  }

  bool isEnableEncryption() {
    bool isEnableEncryption = true;
    return isEnableEncryption;
  }
}

FutureOr disposeNetworkUtils(NetworkUtils instance) {
  instance.dispose();
}
