import 'dart:async';

import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_repository.dart';

part 'home_shop_bloc.freezed.dart';
part 'home_shop_event.dart';
part 'home_shop_state.dart';

@injectable
class HomeShopBloc extends Bloc<HomeShopEvent, HomeShopState> {
  final CartRepository _cartRepository;
  final CartManager _cartManager;

  HomeShopBloc(this._cartRepository, this._cartManager) : super(HomeShopState.initial()) {
    on<_Init>(_onInit);
  }

  Future<void> _onInit(_Init event, Emitter<HomeShopState> emit) async {
    emit(state.copyWith(status: HomeShopStatus.loading));
    final result = await _cartRepository.getCart();
    switch (result) {
      case Success<CartEntity>(data: final cart):
        // فقط Success باعث جایگزینی سبد مشترک اپ می‌شود.
        _cartManager.setCart(cart);
        emit(state.copyWith(status: HomeShopStatus.loaded));
      case Failure<CartEntity>(error: final error):
        emit(state.copyWith(status: HomeShopStatus.failed, errorMessage: error.message));
    }
  }
}
