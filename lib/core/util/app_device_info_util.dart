import 'dart:io';


import 'package:device_info_plus/device_info_plus.dart';
import 'package:dynamic_app/core/local/setting_manager.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart' as invisible_auth;
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

@injectable
class AppDeviceInfoUtil {
  final BaseDeviceInfo baseDeviceInfo;
  final PackageInfo packageInfo;
  final SettingsManager settingManager;

  AppDeviceInfoUtil(this.baseDeviceInfo, this.packageInfo, this.settingManager);

  AndroidDeviceInfo get _androidInfo => baseDeviceInfo as AndroidDeviceInfo;

  IosDeviceInfo get _iosDeviceInfo => baseDeviceInfo as IosDeviceInfo;

  bool get signChecker {
    String signHashCode = packageInfo.buildSignature;
    List<String> validSignList = ['181BC4E999A27CD88B269AE3B1C6E2CF5EF2D792'];
    bool isFoundValidSign = false;
    for (var element in validSignList) {
      if (element == signHashCode) isFoundValidSign = true;
    }
    return isFoundValidSign;
  }



  get packageName {
    var packageName = packageInfo.packageName.replaceAll('.f', '');
    var packageNameArray = packageName.split('.');
    var finalPackageNameArray =
        '${packageNameArray[0]}.${packageNameArray[1]}.${packageNameArray[2]}.${packageNameArray[3]}';

   /* if (packageNameArray.length == 5) {
      finalPackageNameArray =
          '${packageNameArray[0]}.${packageNameArray[1]}.${packageNameArray[2]}.${packageNameArray[3]}.${packageNameArray[4]}';
    }*/
    return finalPackageNameArray;
  }

  get appVersion {
    return packageInfo.version;
  }

  get versionCode {
    return packageInfo.buildNumber;
  }

  get deviceModel {
    String appVersion = '';
    if (kIsWeb) {
      appVersion = 'web';
    } else {
      if (Platform.isAndroid) {
        appVersion = _androidInfo.model.toString();
      } else if (Platform.isIOS) {
        appVersion = _iosDeviceInfo.model.toString();
      } else if (Platform.isLinux) {
        appVersion = 'isLinux';
      } else if (Platform.isMacOS) {
        appVersion = 'isMacOS';
      } else if (Platform.isWindows) {
        appVersion = 'isWindows';
      }
    }
    return appVersion;
  }

  get deviceBrand {
    String appVersion = '';
    if (kIsWeb) {
      appVersion = 'web';
    } else {
      if (Platform.isAndroid) {
        appVersion = _androidInfo.brand.toString();
      } else if (Platform.isIOS) {
        appVersion = _iosDeviceInfo.model.toString();
      } else if (Platform.isLinux) {
        appVersion = 'isLinux';
      } else if (Platform.isMacOS) {
        appVersion = 'isMacOS';
      } else if (Platform.isWindows) {
        appVersion = 'isWindows';
      }
    }
    return appVersion;
  }

  get osName {
    String osName = '';
    if (kIsWeb) {
      osName = 'WEB';
    } else {
      if (Platform.isAndroid) {
        osName = 'ANDROID';
      } else if (Platform.isIOS) {
        osName = 'IOS';
      } else if (Platform.isLinux) {
        osName = 'LINUX';
      } else if (Platform.isMacOS) {
        osName = 'MACOS';
      } else if (Platform.isWindows) {
        osName = 'WINDOWS';
      }
    }
    return osName;
  }

  get osVersion {
    String osVersion = '';
    if (kIsWeb) {
      osVersion = 'WEB';
    } else {
      if (Platform.isAndroid) {
        osVersion = _androidInfo.version.release;
      } else if (Platform.isIOS) {
        osVersion = _iosDeviceInfo.systemVersion;
      } else if (Platform.isLinux) {
        osVersion = 'LINUX';
      } else if (Platform.isMacOS) {
        osVersion = 'MACOS';
      } else if (Platform.isWindows) {
        osVersion = 'WINDOWS';
      }
    }
    return osVersion;
  }

  int get androidSdkVersion {
    if (Platform.isAndroid) {
      return _androidInfo.version.sdkInt;
    }

    return 30;
  }

  get deviceId {
    String deviceId = settingManager.getDeviceId();
    if (deviceId.isEmpty) {
      var uuid = const Uuid();
      deviceId = uuid.v4().replaceAll('-', '').substring(16);
      settingManager.setDeviceId(deviceId);
    }
    return deviceId;
    // return '526ca070248a88c7';
  }



  bool get _isPhysicalDevice {
    bool isPhysicalDevice = false;
    if (kIsWeb) {
      isPhysicalDevice = false;
    } else {
      if (Platform.isAndroid) {
        isPhysicalDevice = _androidInfo.isPhysicalDevice;
      } else if (Platform.isIOS) {
        isPhysicalDevice = _iosDeviceInfo.isPhysicalDevice;
      } else if (Platform.isLinux) {
        isPhysicalDevice = false;
      } else if (Platform.isMacOS) {
        isPhysicalDevice = false;
      } else if (Platform.isWindows) {
        isPhysicalDevice = false;
      }
    }

    return isPhysicalDevice;
  }

  bool get isSimulator {
    return ((Platform.isAndroid || Platform.isIOS) && !_isPhysicalDevice);
  }

  Map<String, dynamic> androidDeviceData() {
    return _androidInfo.data;
  }



  bool isDebuggableMode() {
    var debugMode = kDebugMode;
    assert(() {
      //it only runs in debug mode.
      debugMode = true;
      return true;
    }());
    return debugMode;
  }

}
