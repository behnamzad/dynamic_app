import 'dart:async';

import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_repository.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/shared/product/domain/repository/product_repo.dart';

part 'product_info_bloc.freezed.dart';
part 'product_info_event.dart';
part 'product_info_state.dart';

@injectable
class ProductInfoBloc extends Bloc<ProductInfoEvent, ProductInfoState> {
  final ProductRepo _productRepo;
  final CartRepository _cartRepository;
  final CartManager _cartManager;

  ProductInfoBloc(this._productRepo, this._cartRepository, this._cartManager) : super(ProductInfoState.initial()) {
    on<_Init>(_onInit);
    on<_getProduct>(_onGetProduct);
    // on<_getProductSpecifications>(_onGetProductSpecifications);
    on<_AddToCart>(_onAddToCart);
    on<_RemoveFromCart>(_onRemoveFromCart);
  }

  FutureOr<void> _onInit(_Init event, Emitter<ProductInfoState> emit) {
    emit(state.copyWith(status: Status.loading));
    if (event.entity != null) {
      emit(
        state.copyWith(
          status: Status.loaded,
          productEntity: event.entity,
          isInCart: _cartManager.containsProduct(event.entity!.id),
        ),
      );
    } else if (event.productId != null) {
      add(ProductInfoEvent.getProduct(event.productId!));
    } else {
      emit(state.copyWith(status: Status.failed, errorMessage: ss.productNotProvided));
    }
  }

  FutureOr<void> _onGetProduct(_getProduct event, Emitter<ProductInfoState> emit) async {
    try {
      emit(state.copyWith(status: Status.loading));
      // add(ProductInfoEvent.getProductSpecifications(event.productId));
      Result<ProductEntity> result = await _productRepo.getProduct(id: event.productId);
      switch (result) {
        case Success<ProductEntity>(data: ProductEntity entity):
          emit(
            state.copyWith(
              status: Status.loaded,
              productEntity: entity,
              isInCart: _cartManager.containsProduct(entity.id),
            ),
          );

        case Failure<ProductEntity>(:final error):
          emit(state.copyWith(status: Status.failed, errorMessage: error.message));
      }
    } catch (e) {
      emit(state.copyWith(status: Status.failed, errorMessage: ss.generalError));
    }
  }

  Future<void> _onAddToCart(_AddToCart event, Emitter<ProductInfoState> emit) async {
    emit(state.copyWith(cartActionStatus: CartActionStatus.loading));
    final result = await _cartRepository.addProduct(entity: event.product, quantity: event.quantity);
    switch (result) {
      case Success<CartProductEntity>():
        emit(state.copyWith(cartActionStatus: CartActionStatus.added, isInCart: true));
      case Failure<CartProductEntity>(error: final error):
        emit(state.copyWith(cartActionStatus: CartActionStatus.failed, errorMessage: error.message));
    }
  }

  Future<void> _onRemoveFromCart(_RemoveFromCart event, Emitter<ProductInfoState> emit) async {
    emit(state.copyWith(cartActionStatus: CartActionStatus.loading));
    final result = await _cartRepository.removeProduct(event.productId);
    switch (result) {
      case Success<void>():
        emit(
          state.copyWith(
            cartActionStatus: CartActionStatus.removed,
            isInCart: _cartManager.containsProduct(event.productId),
          ),
        );
      case Failure<void>(error: final error):
        emit(state.copyWith(cartActionStatus: CartActionStatus.failed, errorMessage: error.message));
    }
  }

  // FutureOr<void> _onGetProductSpecifications(_getProductSpecifications event, Emitter<ProductInfoState> emit) async {
  //   emit(state.copyWith(specificationStatus: SpecificationStatus.loading));
  //   Result<List<ProductSpecificationEntity>> result = await _productRepo.getProductSpecifications(id: event.productId);
  //   switch (result) {
  //     case Success<List<ProductSpecificationEntity>>(data: List<ProductSpecificationEntity> list):
  //       emit(state.copyWith(specificationStatus: SpecificationStatus.loaded, productSpecificationEntityList: list));
  //
  //     case Failure<List<ProductSpecificationEntity>>(:final error):
  //       emit(state.copyWith(specificationStatus: SpecificationStatus.failed, errorMessage: error.message));
  //   }
  // }
}
