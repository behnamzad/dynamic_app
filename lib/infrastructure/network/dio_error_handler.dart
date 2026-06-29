import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dynamic_app/infrastructure/network/model/api_error.dart';
import 'package:dynamic_app/infrastructure/network/model/error_model.dart';
import 'package:dynamic_app/infrastructure/network/model/third_party_error_model.dart';
import 'package:flutter/cupertino.dart';

import 'config/strings.dart';

ApiError handleDioError({DioException? dioException, Response? response}) {
  if (_isConnectionClosedOnHttpException(dioException)) {
    return const ConnectionClosedOnHttpError(Strings.serverErrorConnection, '500');
  }
  if (dioException != null && dioException.type == DioExceptionType.connectionTimeout) {
    return const TimeOutError(Strings.timeOutException, '500');
  }

  if (dioException != null && ((dioException.error is SocketException))) {
    return const InternetError(Strings.internetError);
  }

  if (dioException != null && ((dioException.error is SessionExpiredAndRecallService))) {
    return const SessionExpiredAndRecallService(Strings.internetError);
  }

  if (response == null) {
    return const UncaughtError(Strings.serverError);
  }

  try {
    var data = response.data;

    if (response.data.containsKey('errorMessage')) {
      data.putIfAbsent('error_message', () => response.data['errorMessage']);
    }

    if (response.data.containsKey('errorCode')) {
      data.putIfAbsent('error_code', () => response.data['errorCode'].toString());
    }

    if (response.data.containsKey('error_code')) {
      response.data['error_code'] = response.data['error_code'].toString();
    }

    try {
      String? thirdPartyErrorCode;
      String? thirdPartyErrorMessage;

      if (data.containsKey('thirdPartyError')) {
        var thirdPartyErrorModel = ThirdPartyErrorModel.fromJson(data);
        thirdPartyErrorCode = thirdPartyErrorModel.thirdPartyError!.errorCode;
        thirdPartyErrorMessage = thirdPartyErrorModel.thirdPartyError!.errorMessage;
        response.data['error_code'] = thirdPartyErrorCode;
        response.data['error_message'] = thirdPartyErrorMessage;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    final errorModel = ErrorModel.fromJson(data);
    if (errorModel.code != null && errorModel.code!.isNotEmpty && errorModel.code != 'null') {
      String code = errorModel.code!;
      switch (int.parse(code)) {
        case 33:
          return InvalidPasswordOrUsername(errorModel.message, code);
        case 67:
          return SessionExpired(errorModel.message, code);
        case 151:
          return UsernameAndPhoneNumberNotMatch(errorModel.message, code);
        case 101: //when terminate devices in 401 statusCode
          return TerminateCurrentDevice(errorModel.message);
      }
    }

    switch (response.statusCode) {
      case 400:
        return BadRequest(errorModel.message, errorModel.code);

      case 401:
        return Unauthorized(errorModel.message, errorModel.code);

      case 403:
        return Forbidden(errorModel.message, errorModel.code);

      case 404:
        return NotFound(errorModel.message.isNotEmpty ? errorModel.message : Strings.serverError);

      case 423:
        return UnavailableForThisOperation(errorModel.message, errorModel.code);

      case 451:
        return UnavailableForLegalReasons(errorModel.message, errorModel.code);

      case 500:
        String errMsg = Strings.serverError;
        try {
          if (errorModel.message.isNotEmpty && errorModel.message != 'null') {
            errMsg = errorModel.message;
          }
        } catch (e) {
          debugPrint(e.toString());
        }

        return ServerError(errMsg, '500', httpCode: 500);

      case 503:
        return ServiceUnavailable(errorModel.message, errorModel.code, httpCode: 503);

      case 504:
        return TimeOutError(errorModel.message, errorModel.code, httpCode: 504);

      default:
        return UncaughtError(errorModel.message.isNotEmpty ? errorModel.message : Strings.serverError,
            code: errorModel.code ?? '');
    }
  } catch (e) {
    if (response.statusCode! > 500) {
      return const InternalServerNotUnavailable(Strings.serverError, '500');
    } else {
      return const UncaughtError(Strings.serverError);
    }
  }
}

bool _isConnectionClosedOnHttpException(DioException? err) {
  return err != null &&
      err.type == DioExceptionType.unknown &&
      (err.error is HttpException &&
          (err.message?.contains('Connection closed before full header was received') ?? false));
}
