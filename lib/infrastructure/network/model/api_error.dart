import 'package:equatable/equatable.dart';

class ApiError extends Equatable {
  final String message;
  final String? code;
  final int? httpCode;

  const ApiError(this.message, {this.code, this.httpCode = 0});

  @override
  String toString() => 'message: $message , code: $code';

  @override
  List<Object?> get props => [message, code, httpCode];
}

class InternetError extends ApiError {
  const InternetError(String message) : super(message);
}

class ConnectionClosedOnHttpError extends ApiError {
  const ConnectionClosedOnHttpError(String message, String code) : super(message, code: code);
}

//errorCode: 33
class InvalidPasswordOrUsername extends ApiError {
  const InvalidPasswordOrUsername(String message, String? code) : super(message, code: code);
}

//errorCode: 67 after show login dialog for update session
class SessionExpiredAndRecallService extends ApiError {
  const SessionExpiredAndRecallService(String message) : super(message);
}

class TerminateCurrentDevice extends ApiError {
  const TerminateCurrentDevice(String message) : super(message);
}

class TokenExpiredAndRecallService extends ApiError {
  const TokenExpiredAndRecallService(String message) : super(message);
}

//errorCode: 67
class SessionExpired extends ApiError {
  const SessionExpired(String message, String? code) : super(message, code: code);
}

//errorCode: 151
class UsernameAndPhoneNumberNotMatch extends ApiError {
  const UsernameAndPhoneNumberNotMatch(String message, String code) : super(message, code: code);
}

//HttpCode: 400
class BadRequest extends ApiError {
  const BadRequest(String message, String? code) : super(message, code: code);
}

//HttpCode: 401
class Unauthorized extends ApiError {
  const Unauthorized(String message, String? code) : super(message, code: code);
}

//HttpCode: 403
class Forbidden extends ApiError {
  const Forbidden(String message, String? code) : super(message, code: code);
}

//HttpCode: 404
class NotFound extends ApiError {
  const NotFound(String message) : super(message, code: '404');
}

//HttpCode: 423
class UnavailableForThisOperation extends ApiError {
  const UnavailableForThisOperation(String message, String? code) : super(message, code: code);
}

//HttpCode: 451
class UnavailableForLegalReasons extends ApiError {
  const UnavailableForLegalReasons(String message, String? code) : super(message, code: code);
}

//HttpCode: 500
class ServerError extends ApiError {
  const ServerError(String message, String? code, {int? httpCode}) : super(message, code: code, httpCode: httpCode);
}

//HttpCode: bigger than 500
class InternalServerNotUnavailable extends ApiError {
  const InternalServerNotUnavailable(String message, String? code, {int? httpCode})
      : super(message, code: code, httpCode: httpCode);
}

//HttpCode: 503
class ServiceUnavailable extends ApiError {
  const ServiceUnavailable(String message, String? code, {int? httpCode})
      : super(message, code: code, httpCode: httpCode);
}

//HttpCode: 504
class TimeOutError extends ApiError {
  const TimeOutError(String message, String? code, {int? httpCode}) : super(message, code: code, httpCode: httpCode);
}

class UncaughtError extends ApiError {
  const UncaughtError(String message, {String? code}) : super(message, code: code);
}
