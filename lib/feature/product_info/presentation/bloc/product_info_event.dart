part of 'product_info_bloc.dart';

@freezed
class ProductInfoEvent with _$ProductInfoEvent {
  // if entity sent=> set to state or else get product with productId
  const factory ProductInfoEvent.init({ProductEntity? entity, int? productId}) = _Init;

  const factory ProductInfoEvent.getProduct(int productId) = _getProduct;

  // const factory ProductInfoEvent.getProductSpecifications(int productId) = _getProductSpecifications;
  const factory ProductInfoEvent.addToCart(ProductEntity product, {@Default(1) int quantity}) = _AddToCart;

  const factory ProductInfoEvent.removeFromCart(int productId) = _RemoveFromCart;
}
