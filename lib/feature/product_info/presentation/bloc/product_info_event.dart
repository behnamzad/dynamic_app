part of 'product_info_bloc.dart';

@freezed
class ProductInfoEvent with _$ProductInfoEvent {
  const factory ProductInfoEvent.init({ProductEntity? entity, int? productId}) = _Init;

  const factory ProductInfoEvent.getProduct(int productId) = _GetProduct;

  const factory ProductInfoEvent.loadPersonalization(ProductEntity product) = _LoadPersonalization;

  const factory ProductInfoEvent.addToCart(
    ProductEntity product, {
    @Default(1) int quantity,
    RecommendationAttribution? recommendationAttribution,
  }) = _AddToCart;

  const factory ProductInfoEvent.removeFromCart(int productId) = _RemoveFromCart;
}
