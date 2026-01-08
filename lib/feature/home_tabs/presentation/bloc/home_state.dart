part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  loading;

  bool get isInitial => this == HomeStatus.initial;

  bool get isLoading => this == HomeStatus.loading;
}

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
  }) = _HomeState;
}
