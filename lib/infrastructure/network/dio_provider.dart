import 'package:dio/dio.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:dynamic_app/infrastructure/network/config/const.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


import 'util/headers_interceptor.dart';

Dio provideDio(
    {List<Interceptor>? interceptors,
    required String baseUrl,
    Duration? networkTimeout,
    bool setFalseEncryptionEnabledKey = false,
    bool setTrueEncryptionEnabledKey = false,
    Map<String, dynamic>? customHeaders}) {
  final dio = Dio(
    BaseOptions(
        connectTimeout: networkTimeout ?? Const.networkTimeout,
        receiveTimeout: networkTimeout ?? Const.networkTimeout,
        sendTimeout: networkTimeout ?? Const.networkTimeout,
        responseType: ResponseType.json,
        baseUrl: baseUrl,
        headers: customHeaders ?? {}),
  );

  if (interceptors != null) {
    for (var element in interceptors) {
      dio.interceptors.add(element);
    }
  }

  dio.interceptors.add((HeadersInterceptor(isAddTestData: false)));

  dio.interceptors.add(inject<PrettyDioLogger>());

  return dio;
}
