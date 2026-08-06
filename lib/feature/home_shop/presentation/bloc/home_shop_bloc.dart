import 'dart:async';

import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_repository.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';
import 'package:dynamic_app/shared/category/domain/repository/category_repository.dart';

part 'home_shop_bloc.freezed.dart';
part 'home_shop_event.dart';
part 'home_shop_state.dart';

@injectable
class HomeShopBloc extends Bloc<HomeShopEvent, HomeShopState> {
  final CartRepository _cartRepository;
  final CategoryRepository _categoryRepository;

  HomeShopBloc(this._cartRepository, this._categoryRepository) : super(HomeShopState.initial()) {
    on<_Init>(_onInit);
  }

  Future<void> _onInit(_Init event, Emitter<HomeShopState> emit) async {
    emit(state.copyWith(status: HomeShopStatus.loading));
    final cartResult = await _cartRepository.getCart();
    final categories = await _categoryRepository.getCategories();

    switch (cartResult) {
      case Success<CartEntity>():
        emit(
          state.copyWith(
            status: HomeShopStatus.loaded,
            categoryList: categories,
            // todo change it to 4 later
            categoryForHorizontalProductLis: categories.take(1).toList(growable: false),
          ),
        );
      case Failure<CartEntity>(error: final error):
        emit(state.copyWith(status: HomeShopStatus.failed, errorMessage: error.message));
    }
  }
}
