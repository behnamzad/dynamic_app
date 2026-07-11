part of 'login_bloc.dart';

enum Status {
  initial,
  loading,
  success,
  error,
  invalidInput;

  bool get isInitial => this == Status.initial;

  bool get isLoading => this == Status.loading;

  bool get isSuccess => this == Status.success;

  bool get isError => this == Status.error;

  bool get isInvalidInput => this == Status.invalidInput;
}

enum LoginMode {
  login,
  register;

  bool get isLogin => this == LoginMode.login;

  bool get isRegister => this == LoginMode.register;
}

@freezed
sealed class LoginState with _$LoginState {
  factory LoginState.initial({
    @Default(Status.initial) Status status,
    @Default(LoginMode.login) LoginMode mode,
    String? userName,
    String? email,
    String? passWord,
    String? infoMessage,
    String? errorMessage,
    @Default(LoginFeedbackCode.none) LoginFeedbackCode feedbackCode,
  }) = _Initial;
}
