part of 'product_info_bloc.dart';

enum Status {
  initial,
  loading,
  loaded,
  failed;

  bool get isInitial => this == Status.initial;

  bool get isLoading => this == Status.loading;

  bool get isLoaded => this == Status.loaded;

  bool get isFailed => this == Status.failed;
}
enum SpecificationStatus {
  initial,
  loading,
  loaded,
  failed;

  bool get isInitial => this == SpecificationStatus.initial;

  bool get isLoading => this == SpecificationStatus.loading;

  bool get isLoaded => this == SpecificationStatus.loaded;

  bool get isFailed => this == SpecificationStatus.failed;
}

enum CartActionStatus {
  initial,
  loading,
  added,
  removed,
  failed;

  bool get isLoading => this == CartActionStatus.loading;
}

@freezed
class ProductInfoState with _$ProductInfoState {
  factory ProductInfoState.initial({
    @Default(Status.initial) Status status,
    // @Default(SpecificationStatus.initial) SpecificationStatus specificationStatus,
    @Default(CartActionStatus.initial) CartActionStatus cartActionStatus,
    @Default(false) bool isInCart,
    ProductEntity? productEntity,
    // List<ProductSpecificationEntity>? productSpecificationEntityList,
    String? infoMessage,
    String? errorMessage,
  }) = _Initial;
}
