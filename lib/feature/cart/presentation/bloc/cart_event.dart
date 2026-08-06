part of 'cart_bloc.dart';

@freezed
sealed class CartEvent with _$CartEvent {
  const factory CartEvent.initialize() = _Initialize;

  const factory CartEvent.refreshCart() = _RefreshCart;

  const factory CartEvent.syncLocalCart() = _SyncLocalCart;

  const factory CartEvent.loadOrders() = _LoadOrders;

  const factory CartEvent.clearFeedback() = _ClearFeedback;
}
