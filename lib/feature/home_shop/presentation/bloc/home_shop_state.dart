part of 'home_shop_bloc.dart';

enum HomeShopStatus {
  initial,
  loading,
  loaded,
  failed;

  bool get isFailed => this == HomeShopStatus.failed;
}

@freezed
class HomeShopState with _$HomeShopState {
  factory HomeShopState.initial({
    @Default(HomeShopStatus.initial) HomeShopStatus status,
    String? errorMessage,
  }) = _Initial;
}
