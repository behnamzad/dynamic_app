import 'dart:async';

import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/cart/domain/models/cart_totals.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_repository.dart';
import 'package:dynamic_app/shared/orders/domain/entities/address_entity.dart';
import 'package:dynamic_app/shared/orders/domain/entities/order_entity.dart';
import 'package:dynamic_app/shared/orders/domain/repository/order_repository.dart';

part 'checkout_cart_bloc.freezed.dart';
part 'checkout_cart_event.dart';
part 'checkout_cart_state.dart';

@injectable
class CheckoutCartBloc extends Bloc<CheckoutCartEvent, CheckoutCartState> {
  final CartRepository _cartRepository;
  final OrderRepository _orderRepository;
  final CartManager _cartManager;

  CheckoutCartBloc(this._cartRepository, this._orderRepository, this._cartManager)
    : super(CheckoutCartState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_SyncLocalCart>(_onSyncLocalCart);
    on<_SelectAddress>(_onSelectAddress);
    on<_AddAddress>(_onAddAddress);
    on<_DeleteAddress>(_onDeleteAddress);
    on<_PlaceOrder>(_onPlaceOrder);
    on<_ClearFeedback>(_onClearFeedback);
    _cartManager.addListener(_onCartManagerChanged);
  }

  void _onCartManagerChanged() {
    if (!isClosed) add(const CheckoutCartEvent.syncLocalCart());
  }

  void _onSyncLocalCart(_SyncLocalCart event, Emitter<CheckoutCartState> emit) {
    final cart = _cartManager.cart;
    emit(state.copyWith(cart: cart, cartTotals: _cartManager.calculateTotals(cart)));
  }

  Future<void> _onInitialize(_Initialize event, Emitter<CheckoutCartState> emit) async {
    emit(
      state.copyWith(
        status: CheckoutCartStatus.loading,
        cart: const CartEntity.empty(),
        cartTotals: const CartTotals.empty(),
        addressesStatus: CheckoutCartAddressesStatus.loading,
        feedback: CheckoutCartFeedback.none,
        errorMessage: null,
      ),
    );

    final cartResult = await _cartRepository.getCart();
    switch (cartResult) {
      case Success<CartEntity>(data: final cart):
        emit(
          state.copyWith(status: CheckoutCartStatus.loaded, cart: cart, cartTotals: _cartManager.calculateTotals(cart)),
        );
      case Failure<CartEntity>(error: final error):
        emit(state.copyWith(status: CheckoutCartStatus.failed, errorMessage: error.message));
    }

    final addressResult = await _orderRepository.getAddresses();
    switch (addressResult) {
      case Success<List<AddressEntity>>(data: final addresses):
        final selectedAddress = addresses.contains(state.selectedAddress)
            ? state.selectedAddress
            : addresses.firstOrNull;
        emit(
          state.copyWith(
            addresses: addresses,
            addressesStatus: CheckoutCartAddressesStatus.loaded,
            selectedAddress: selectedAddress,
          ),
        );
      case Failure<List<AddressEntity>>(error: final error):
        emit(
          state.copyWith(
            addressesStatus: CheckoutCartAddressesStatus.loadFailed,
            errorMessage: state.errorMessage ?? error.message,
          ),
        );
    }
  }

  void _onSelectAddress(_SelectAddress event, Emitter<CheckoutCartState> emit) {
    emit(
      state.copyWith(
        selectedAddress: event.address,
        addressesStatus: CheckoutCartAddressesStatus.loaded,
        actionStatus: CheckoutCartActionStatus.initial,
        feedback: CheckoutCartFeedback.none,
      ),
    );
  }

  Future<void> _onAddAddress(_AddAddress event, Emitter<CheckoutCartState> emit) async {
    final province = event.province.trim();
    final city = event.city.trim();
    final addressLine = event.addressLine.trim();
    if (province.isEmpty || city.isEmpty || addressLine.isEmpty) {
      emit(
        state.copyWith(addressesStatus: CheckoutCartAddressesStatus.invalid, errorMessage: ss.addressFieldsRequired),
      );
      return;
    }

    emit(
      state.copyWith(
        addressesStatus: CheckoutCartAddressesStatus.adding,
        feedback: CheckoutCartFeedback.none,
        errorMessage: null,
      ),
    );
    final result = await _orderRepository.addAddress(province: province, city: city, addressLine: addressLine);
    switch (result) {
      case Success<AddressEntity>(data: final address):
        emit(
          state.copyWith(
            addresses: [address, ...state.addresses],
            addressesStatus: CheckoutCartAddressesStatus.added,
            selectedAddress: address,
          ),
        );
      case Failure<AddressEntity>(error: final error):
        emit(state.copyWith(addressesStatus: CheckoutCartAddressesStatus.failed, errorMessage: error.message));
    }
  }

  Future<void> _onDeleteAddress(_DeleteAddress event, Emitter<CheckoutCartState> emit) async {
    emit(
      state.copyWith(
        addressesStatus: CheckoutCartAddressesStatus.deleting,
        feedback: CheckoutCartFeedback.none,
        errorMessage: null,
      ),
    );
    final result = await _orderRepository.deleteAddress(event.address.id);
    switch (result) {
      case Success<void>():
        final addresses = state.addresses.where((item) => item.id != event.address.id).toList(growable: false);
        emit(
          state.copyWith(
            addressesStatus: CheckoutCartAddressesStatus.deleted,
            addresses: addresses,
            selectedAddress: state.selectedAddress?.id == event.address.id
                ? addresses.firstOrNull
                : state.selectedAddress,
          ),
        );
      case Failure<void>(error: final error):
        emit(state.copyWith(addressesStatus: CheckoutCartAddressesStatus.failed, errorMessage: error.message));
    }
  }

  Future<void> _onPlaceOrder(_PlaceOrder event, Emitter<CheckoutCartState> emit) async {
    final address = state.selectedAddress;
    if (address == null) {
      emit(
        state.copyWith(addressesStatus: CheckoutCartAddressesStatus.required, errorMessage: ss.addressRequiredForOrder),
      );
      return;
    }
    if (state.cart.products.isEmpty) {
      emit(
        state.copyWith(
          actionStatus: CheckoutCartActionStatus.failed,
          feedback: CheckoutCartFeedback.emptyCart,
          errorMessage: ss.emptyCart,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        actionStatus: CheckoutCartActionStatus.loading,
        feedback: CheckoutCartFeedback.none,
        errorMessage: null,
        placedOrder: null,
      ),
    );
    final result = await _orderRepository.placeOrder(addressId: address.id, deliveryWindow: event.deliveryWindow);
    switch (result) {
      case Success<OrderEntity>(data: final order):
        emit(
          state.copyWith(
            actionStatus: CheckoutCartActionStatus.succeeded,
            cart: const CartEntity.empty(),
            cartTotals: const CartTotals.empty(),
            placedOrder: order,
            feedback: CheckoutCartFeedback.orderPlaced,
          ),
        );
      case Failure<OrderEntity>(error: final error):
        emit(
          state.copyWith(
            actionStatus: CheckoutCartActionStatus.failed,
            feedback: CheckoutCartFeedback.error,
            errorMessage: error.message,
          ),
        );
    }
  }

  void _onClearFeedback(_ClearFeedback event, Emitter<CheckoutCartState> emit) {
    final addressesStatus = switch (state.addressesStatus) {
      CheckoutCartAddressesStatus.added ||
      CheckoutCartAddressesStatus.deleted ||
      CheckoutCartAddressesStatus.invalid ||
      CheckoutCartAddressesStatus.required ||
      CheckoutCartAddressesStatus.failed => CheckoutCartAddressesStatus.loaded,
      _ => state.addressesStatus,
    };
    emit(
      state.copyWith(
        actionStatus: CheckoutCartActionStatus.initial,
        addressesStatus: addressesStatus,
        feedback: CheckoutCartFeedback.none,
        errorMessage: null,
      ),
    );
  }

  @override
  Future<void> close() {
    _cartManager.removeListener(_onCartManagerChanged);
    return super.close();
  }
}
