part of 'checkout_cart_bloc.dart';

@freezed
sealed class CheckoutCartEvent with _$CheckoutCartEvent {
  const factory CheckoutCartEvent.initialize() = _Initialize;

  const factory CheckoutCartEvent.syncLocalCart() = _SyncLocalCart;

  const factory CheckoutCartEvent.selectAddress(AddressEntity address) = _SelectAddress;

  const factory CheckoutCartEvent.addAddress({
    required String province,
    required String city,
    required String addressLine,
  }) = _AddAddress;

  const factory CheckoutCartEvent.deleteAddress(AddressEntity address) = _DeleteAddress;

  const factory CheckoutCartEvent.placeOrder({required String deliveryWindow}) = _PlaceOrder;

  const factory CheckoutCartEvent.clearFeedback() = _ClearFeedback;
}
