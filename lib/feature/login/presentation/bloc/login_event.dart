part of 'login_bloc.dart';

@freezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.init() = _Init;
  const factory LoginEvent.validation() = _Validation;
  const factory LoginEvent.changeMode(LoginMode mode) = _ChangeMode;
  const factory LoginEvent.login({required String email, required String password}) = _Login;
  const factory LoginEvent.register({
    required String email,
    required String username,
    required String password,
    required String gender,
    required int? age,
  }) = _Register;
}
