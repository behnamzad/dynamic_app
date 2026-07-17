part of 'product_list_bloc.dart';

enum ProductListStatus {
  initial,
  loading,
  loaded,
  failed;

  bool get isInitial => this == ProductListStatus.initial;

  bool get isLoading => this == ProductListStatus.loading;

  bool get isLoaded => this == ProductListStatus.loaded;

  bool get isFailed => this == ProductListStatus.failed;
}

@freezed
class ProductListState with _$ProductListState {
  factory ProductListState.initial({
    @Default(ProductListStatus.initial) ProductListStatus status,
    // add other get product type like: search or ..
    @Default(ProductListStatus.initial) ProductListStatus productByCategoryStatus,
    @Default([]) List<ProductEntity> loadedProduct,
    @Default([]) List<ProductEntity> horizontalProduct,
    @Default([]) List<BrandOfCategoryEntity> brands,
    String? errorMessage,
  }) = _Initial;
}
