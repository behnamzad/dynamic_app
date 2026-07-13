import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';

abstract class CartRepository {
  Future<Result<CartEntity>> getCart();

  Future<Result<CartProductEntity>> addProduct({
    required int productId,
    required int categoryId,
    required int quantity,
  });

  Future<Result<void>> removeProduct(int productId);
}
