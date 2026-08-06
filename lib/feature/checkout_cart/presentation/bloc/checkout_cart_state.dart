part of 'checkout_cart_bloc.dart';

enum CheckoutCartStatus {
  initial,
  loading,
  loaded,
  failed;

  bool get isLoading => this == CheckoutCartStatus.loading;
}

enum CheckoutCartFeedback { none, emptyCart, orderPlaced, error }

enum CheckoutCartActionStatus {
  initial,
  loading,
  succeeded,
  failed;

  bool get isLoading => this == CheckoutCartActionStatus.loading;
}

enum CheckoutCartAddressesStatus {
  initial,
  loading,
  loaded,
  loadFailed,
  adding,
  added,
  deleting,
  deleted,
  invalid,
  required,
  failed;

  bool get isLoading => this == CheckoutCartAddressesStatus.loading;

  bool get isLoadFailed => this == CheckoutCartAddressesStatus.loadFailed;

  bool get isAdding => this == CheckoutCartAddressesStatus.adding;

  bool get isBusy => isLoading || isAdding || this == CheckoutCartAddressesStatus.deleting;
}

@freezed
class CheckoutCartState with _$CheckoutCartState {
  factory CheckoutCartState.initial({
    @Default(CheckoutCartStatus.initial) CheckoutCartStatus status,
    @Default(CheckoutCartFeedback.none) CheckoutCartFeedback feedback,
    @Default(CheckoutCartActionStatus.initial) CheckoutCartActionStatus actionStatus,
    @Default(CheckoutCartAddressesStatus.initial) CheckoutCartAddressesStatus addressesStatus,
    @Default(CartEntity.empty()) CartEntity cart,
    @Default(<AddressEntity>[]) List<AddressEntity> addresses,
    AddressEntity? selectedAddress,
    @Default(CartTotals.empty()) CartTotals cartTotals,
    OrderEntity? placedOrder,
    String? errorMessage,
  }) = _Initial;
}
