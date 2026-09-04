part of 'product_info_bloc.dart';

enum ProductLoadStatus {
  initial,
  loading,
  loaded,
  failed;

  bool get isLoading => this == ProductLoadStatus.loading;

  bool get isLoaded => this == ProductLoadStatus.loaded;

  bool get isFailed => this == ProductLoadStatus.failed;
}

enum CartActionStatus {
  initial,
  loading,
  added,
  removed,
  failed;

  bool get isLoading => this == CartActionStatus.loading;
}

enum PersonalizationStatus {
  initial,
  loading,
  ready,
  unavailable;

  bool get isReady => this == PersonalizationStatus.ready;
}

@freezed
class ProductInfoState with _$ProductInfoState {
  factory ProductInfoState.initial({
    @Default(ProductLoadStatus.initial) ProductLoadStatus status,
    @Default(CartActionStatus.initial) CartActionStatus cartActionStatus,
    @Default(false) bool isInCart,
    ProductEntity? productEntity,
    @Default(PersonalizationStatus.initial)
    PersonalizationStatus personalizationStatus,
    PersonalizationDecision? personalizationDecision,
    @Default(<PersonalizedProductSuggestion>[])
    List<PersonalizedProductSuggestion> alternativeProductSuggestions,
    String? recommendationStrategy,
    String? errorMessage,
  }) = _Initial;
}
