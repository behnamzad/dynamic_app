import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';

class CartEntity {
  final String id;
  final List<CartProductEntity> products;

  const CartEntity({required this.id, required this.products});

  const CartEntity.empty() : id = '', products = const [];

  CartEntity copyWith({String? id, List<CartProductEntity>? products}) {
    return CartEntity(id: id ?? this.id, products: products ?? this.products);
  }
}
