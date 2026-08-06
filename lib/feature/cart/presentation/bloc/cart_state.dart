part of 'cart_bloc.dart';

enum CartStatus {
  initial,
  loading,
  loaded,
  failed;

  bool get isLoading => this == CartStatus.loading;
}

enum CartFeedback { none, error }

@freezed
class CartState with _$CartState {
  factory CartState.initial({
    @Default(CartStatus.initial) CartStatus status,
    @Default(CartFeedback.none) CartFeedback feedback,
    @Default(false) bool ordersLoading,
    @Default(CartEntity.empty()) CartEntity cart,
    @Default(<OrderEntity>[]) List<OrderEntity> orders,
    @Default(CartTotals.empty()) CartTotals cartTotals,
    String? errorMessage,
  }) = _Initial;
}
