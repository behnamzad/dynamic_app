import 'dart:async';

import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_of_category_entity.dart';
import 'package:dynamic_app/shared/product/domain/repository/product_repo.dart';

part 'product_list_bloc.freezed.dart';
part 'product_list_event.dart';
part 'product_list_state.dart';

@injectable
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepo _productRepo;

  ProductListBloc(this._productRepo) : super(ProductListState.initial()) {
    on<_Init>(_onInit);
    on<_GetProductAndBrandsByCategory>(_onGetProductAndBrandsByCategory);
  }

  Future<void> _onInit(_Init event, Emitter<ProductListState> emit) async {}

  Future<void> _onGetProductAndBrandsByCategory(
    _GetProductAndBrandsByCategory event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(productByCategoryStatus: ProductListStatus.loading));
    final result = await _productRepo.getProductByCategory(categoryId: event.entity.id, page: event.page);
    switch (result) {
      case Success<ProductAndBrandsOfCategoryResultEntity>(data: final entity):
        emit(
          state.copyWith(
            categoryEntity: event.entity,
            productByCategoryStatus: ProductListStatus.loaded,
            horizontalProduct: entity.product.sublist(0, 10),
            loadedProduct: entity.product,
            brands: entity.brands,
          ),
        );
      case Failure<ProductAndBrandsOfCategoryResultEntity>(error: final error):
        emit(state.copyWith(productByCategoryStatus: ProductListStatus.failed, errorMessage: error.message));
    }
  }
}
