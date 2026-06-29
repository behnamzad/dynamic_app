part of 'login_bloc.dart';

enum Status {
  initial,
  loading,
  success,
  error;

  bool get isInitial => this == Status.initial;

  bool get isLoading => this == Status.loading;

  bool get isSuccess => this == Status.success;

  bool get isError => this == Status.error;
}

@freezed
sealed class LoginState with _$LoginState {
  factory LoginState.initial({
    @Default(Status.initial) Status status,
    String? userName,
    String? passWord,
    String? infoMessage,
    String? errorMessage,
  }) = _Initial;
}
