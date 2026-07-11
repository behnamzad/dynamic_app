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

@freezed
class ProductInfoState with _$ProductInfoState {
  factory ProductInfoState.initial({
    @Default(Status.initial) Status status,
    @Default(SpecificationStatus.initial) SpecificationStatus specificationStatus,
    ProductEntity? productEntity,
    List<ProductSpecificationEntity>? productSpecificationEntityList,
    String? infoMessage,
    String? errorMessage,
  }) = _Initial;
}
