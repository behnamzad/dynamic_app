import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dynamic_app/app/route/app_router.dart';
import 'package:dynamic_app/core/util/app_logger.dart';
import 'package:dynamic_app/core/util/crypto/keystore_gcm_crypto_helper.dart';
import 'package:dynamic_app/di/di_const.dart';
import 'package:dynamic_app/infrastructure/network/dio_caller.dart';
import 'package:dynamic_app/infrastructure/network/dio_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.config.dart';

late final GetIt _getIt;
String? strFlavorName;

@InjectableInit(initializerName: r'$initGetIt')
Future<void> configureDependencies({
  bool isReInit = false,
}) async {
  _getIt = isReInit ? GetIt.asNewInstance() : GetIt.instance;

  AppLogger.debugLog1(
    isReInit ? 'Re-initializing dependencies' : 'Initializing dependencies',
  );

  await _getIt.$initGetIt();
}

GetIt get serviceLocator => _getIt;

void _defaultLogPrint(Object? object) {
  if (kDebugMode) {
    try {
      debugPrint(object.toString());
    } catch (e) {
      throw ('_defaultLogPrint===>catch');
    }
  }
}

@module
abstract class NetworkModule {
  @lazySingleton
  Logger get logger => Logger();

  PrettyDioLogger get prettyDioLogger =>
      PrettyDioLogger(requestHeader: true, requestBody: true, logPrint: _defaultLogPrint);

  @Named(DiConst.dioNamedStore)
  @lazySingleton
  Dio provideStoreDio(PrettyDioLogger prettyDioLogger) => provideDio(
        baseUrl: 'https://digikala_api/',
      );

  @Named(DiConst.dioNamedStore)
  @lazySingleton
  DioCaller provideStoreCaller(@Named(DiConst.dioNamedStore) Dio dio) => DioCaller(dio: dio);

  @Named(DiConst.dioNamedLogin)
  @lazySingleton
  Dio provideLoginDio(PrettyDioLogger prettyDioLogger) => provideDio(
        baseUrl: 'https://login/',
      );

  @Named(DiConst.dioNamedLogin)
  @lazySingleton
  DioCaller provideLoginDioCaller(@Named(DiConst.dioNamedLogin) Dio dio) => DioCaller(dio: dio);
}

@module
abstract class InjectableModule {
  @preResolve
  Future<BaseDeviceInfo> get deviceInfo async {
    if (Platform.isAndroid) {
      return DeviceInfoPlugin().androidInfo;
    } else if (Platform.isIOS) {
      return DeviceInfoPlugin().iosInfo;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @preResolve
  Future<SharedPreferences> get sharedPreferences => initSharedPreferences();
}

Future<SharedPreferences> initSharedPreferences() async {
  return await SharedPreferences.getInstance();
}

T inject<T extends Object>({dynamic param1, dynamic param2}) => _getIt.get<T>(param1: param1, param2: param2);

T injectWithNamed<T extends Object>(n) => _getIt.get<T>(instanceName: n);

resetWithNamed<T extends Object>(n) => _getIt.resetLazySingleton<T>(instanceName: n);

reset<T extends Object>() => _getIt.resetLazySingleton<T>();

resetAllServiceLocator() async => await _getIt.reset(dispose: true);

resetScopeAllServiceLocator() => _getIt.resetScope(dispose: true);

reGenerateGetIt() async {
  // reset<GetIt>();
  await resetScopeAllServiceLocator();
  await resetAllServiceLocator();
  await configureDependencies( isReInit: true);
  final KeystoreGcmCryptoHelper aesGcm = inject();
  await aesGcm.initializeSecureKey();
}

T injectAndReset<T extends Object>() => _getIt.get<T>();

resetGetItInstanceObject(Object obj) async {
  try {
    // if (_getIt.isRegistered(instance: obj)) {
    _getIt.resetLazySingleton(instance: obj);
    // }
  } catch (e) {
    debugPrint(e.toString());
  }
}

unregisterFromGetIt<T extends Object>(obj) => _getIt.unregister<T>(instance: obj);

registerToGetIt<T extends Object>(K) => _getIt.registerLazySingleton<T>(() => K);

registerWithNamedToGetIt<T extends Object>(f, n) => _getIt.registerLazySingleton<T>(() => f, instanceName: n);
// getIt.registerLazySingleton<Dio>(() => Dio()..options.headers.addAll(newHeaders));
// resetGetIt(T extends Object)   {
//   try {
//       _getIt.unregister<obj>();
//   } catch (e) {}
// }

Future<T> injectAsync<T extends Object>() => _getIt.getAsync<T>();

BuildContext get currentContext => inject<AppRouter>().navigatorKey.currentContext!;
