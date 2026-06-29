part of 'login_bloc.dart';

@freezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.init() = _Init;
  const factory LoginEvent.validation() = _Validation;
  const factory LoginEvent.login() = _Login;
}
