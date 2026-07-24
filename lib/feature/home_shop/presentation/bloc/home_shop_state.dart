part of 'home_shop_bloc.dart';

enum HomeShopStatus {
  initial,
  loading,
  loaded,
  failed;

  bool get isInitial => this == HomeShopStatus.initial;

  bool get isLoading => this == HomeShopStatus.loading;

  bool get isLoaded => this == HomeShopStatus.loaded;

  bool get isFailed => this == HomeShopStatus.failed;
}

@freezed
class HomeShopState with _$HomeShopState {
  factory HomeShopState.initial({
    @Default(HomeShopStatus.initial) HomeShopStatus status,
    List<CategoryEntity>? categoryList,
    List<CategoryEntity>? categoryForHorizontalProductLis,
    String? errorMessage,
  }) = _Initial;
}
