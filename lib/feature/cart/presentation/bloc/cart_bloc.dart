import 'dart:async';

import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/cart/domain/models/cart_totals.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_repository.dart';
import 'package:dynamic_app/shared/orders/domain/entities/order_entity.dart';
import 'package:dynamic_app/shared/orders/domain/repository/order_repository.dart';

part 'cart_bloc.freezed.dart';
part 'cart_event.dart';
part 'cart_state.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final OrderRepository _orderRepository;
  final CartManager _cartManager;

  CartBloc(this._cartRepository, this._orderRepository, this._cartManager) : super(CartState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_RefreshCart>(_onRefreshCart);
    on<_SyncLocalCart>(_onSyncLocalCart);
    on<_LoadOrders>(_onLoadOrders);
    on<_ClearFeedback>(_onClearFeedback);
    _cartManager.addListener(_onCartManagerChanged);
  }

  void _onCartManagerChanged() {
    if (!isClosed) add(const CartEvent.syncLocalCart());
  }

  void _onSyncLocalCart(_SyncLocalCart event, Emitter<CartState> emit) {
    final cart = _cartManager.cart;
    emit(state.copyWith(cart: cart, cartTotals: _cartManager.calculateTotals(cart)));
  }

  Future<void> _onInitialize(_Initialize event, Emitter<CartState> emit) async {
    emit(
      state.copyWith(
        status: CartStatus.loading,
        cart: const CartEntity.empty(),
        cartTotals: const CartTotals.empty(),
        errorMessage: null,
        feedback: CartFeedback.none,
      ),
    );

    final result = await _cartRepository.getCart();
    switch (result) {
      case Success<CartEntity>(data: final cart):
        emit(state.copyWith(status: CartStatus.loaded, cart: cart, cartTotals: _cartManager.calculateTotals(cart)));
      case Failure<CartEntity>(error: final error):
        emit(state.copyWith(status: CartStatus.failed, feedback: CartFeedback.error, errorMessage: error.message));
    }
  }

  Future<void> _onRefreshCart(_RefreshCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    final result = await _cartRepository.getCart();
    switch (result) {
      case Success<CartEntity>(data: final cart):
        emit(state.copyWith(status: CartStatus.loaded, cart: cart, cartTotals: _cartManager.calculateTotals(cart)));
      case Failure<CartEntity>(error: final error):
        emit(state.copyWith(status: CartStatus.failed, feedback: CartFeedback.error, errorMessage: error.message));
    }
  }

  Future<void> _onLoadOrders(_LoadOrders event, Emitter<CartState> emit) async {
    emit(state.copyWith(ordersLoading: true, errorMessage: null));
    final result = await _orderRepository.getOrders();
    switch (result) {
      case Success<List<OrderEntity>>(data: final orders):
        emit(state.copyWith(ordersLoading: false, orders: orders));
      case Failure<List<OrderEntity>>(error: final error):
        emit(state.copyWith(ordersLoading: false, feedback: CartFeedback.error, errorMessage: error.message));
    }
  }

  void _onClearFeedback(_ClearFeedback event, Emitter<CartState> emit) {
    emit(state.copyWith(feedback: CartFeedback.none, errorMessage: null));
  }

  @override
  Future<void> close() {
    _cartManager.removeListener(_onCartManagerChanged);
    return super.close();
  }
}
