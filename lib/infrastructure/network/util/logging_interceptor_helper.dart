import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptorHelper {
  static Future<void> requestLogger(RequestOptions options) async {
    if (kDebugMode) {
      debugPrint('┝╺ ${options.method.toUpperCase()} ${'${options.baseUrl}${options.path}'}');

      debugPrint('┝╺ Headers:');
      options.headers.forEach((k, v) => debugPrint('$k: $v'));
      debugPrint('┝╺ queryParameters:');
      options.queryParameters.forEach((k, v) => debugPrint('$k: $v'));
      if (options.data != null) {
        debugPrint('┝╺ Body: ${options.data}');
      }
      print('└ ─────────────── END ${options.method.toUpperCase()}─────────────────────────────────────');
    }
  }

  static Future<void> responseLogger(Response options) async {
    if (kDebugMode) {
      print('<-- ${options.statusCode} ${((options.requestOptions.baseUrl + options.requestOptions.path))}');
      print('Headers:');
      options.headers.forEach((k, v) => debugPrint('$k: $v'));
      print('Response: ${options.data}');
      print('<-- END HTTP');
    }
  }

  static void errorLogger(DioException dioError) {
    if (kDebugMode) {
      print(
        '<-- ${dioError.message} ${(dioError.response?.requestOptions != null ? (dioError.response!.requestOptions.baseUrl + dioError.response!.requestOptions.path) : 'URL')}',
      );
      print('${dioError.response != null ? dioError.response!.data : 'Unknown Error'}');
      print('<-- End error');
    }
  }

  static void keyValueLogger(String title, String message) {
    if (kDebugMode) {
      print('<-- $title =====> $message');
      print('<-- End logger');
    }
  }

  static void printMessageLogger(String message) {
    if (kDebugMode) {
      print('<-- $message');
      print('<-- End logger');
    }
  }
}
