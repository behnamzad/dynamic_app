import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

abstract class CartRepository {
  Future<Result<CartEntity>> getCart();

  Future<Result<CartProductEntity>> addProduct({
    required ProductEntity entity,
    required int quantity,
    RecommendationAttribution? recommendationAttribution,
  });

  Future<Result<void>> removeProduct(int productId);
}
