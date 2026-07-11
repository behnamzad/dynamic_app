import 'package:dynamic_app/core/config/strings.dart';
import 'package:dynamic_app/core/util/extension/string_ext.dart';

class ResultException implements Exception {
  final String? code;
  final String message;

  ResultException({this.code, String? errorMessage})
    : message = errorMessage.isNotNullOrBlank ? errorMessage! : ss.generalError;

  factory ResultException.def() {
    return ResultException(errorMessage: ss.generalError, code: '0');
  }

  @override
  String toString() => 'ResultException(errorCode: $code, errorMessage: $message)';
}
