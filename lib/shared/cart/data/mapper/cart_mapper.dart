import 'package:dynamic_app/shared/cart/data/models/cart_dto.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';

extension CartResponseDtoMapper on CartResponseDto {
  CartEntity toEntity() {
    return CartEntity(
      id: cartId,
      products: products.map((product) => product.toEntity()).toList(growable: false),
    );
  }
}

extension CartProductDtoMapper on CartProductDto {
  CartProductEntity toEntity() {
    return CartProductEntity(productId: productId, categoryId: categoryId, quantity: quantity);
  }
}
