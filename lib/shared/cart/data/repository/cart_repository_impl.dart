import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/cart/data/datasource/cart_data_source.dart';
import 'package:dynamic_app/shared/cart/data/mapper/cart_mapper.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_repository.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_recommendation_attribution_store.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartDataSource _dataSource;
  final CartRecommendationAttributionStore _attributionStore;
  final CartManager _cartManager;

  CartRepositoryImpl(this._dataSource, this._attributionStore, this._cartManager);

  @override
  Future<Result<CartEntity>> getCart() async {
    if (_cartManager.isCartLoaded) {
      return Result.success(_cartManager.cart);
    }

    final response = await _dataSource.getCart();
    return response.when(
      completed: (data, _) async {
        final CartEntity cart = data.toEntity();
        return _restoreAttributions(cart);
      },
      error: (error) async => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  Future<Result<CartEntity>> _restoreAttributions(CartEntity cart) async {
    final Map<int, RecommendationAttribution> attributions = await _attributionStore.read(cart.id);
    final CartEntity restored = cart.copyWith(
      products: cart.products
          .map(
            (CartProductEntity product) => product.copyWith(
              recommendationAttribution: attributions[product.productId],
            ),
          )
          .toList(growable: false),
    );
    _cartManager.setCart(restored);
    return Result.success(restored);
  }

  @override
  Future<Result<CartProductEntity>> addProduct({
    required ProductEntity entity,
    required int quantity,
    RecommendationAttribution? recommendationAttribution,
  }) async {
    final CartProductEntity? currentProduct = _cartManager.findProduct(entity.id);
    final int updatedQuantity = (currentProduct?.quantity ?? 0) + quantity;
    final response = await _dataSource.addProduct(
      productId: entity.id,
      categoryId: entity.categoryId,
      productName: entity.titleFa,
      imageUrl: entity.images.isEmpty ? '' : entity.images.first,
      quantity: updatedQuantity,
      price: entity.price,
    );
    return response.when(
      completed: (data, _) async {
        final RecommendationAttribution? effectiveAttribution =
            recommendationAttribution ?? currentProduct?.recommendationAttribution;
        final CartProductEntity product = data.toEntity().copyWith(
          recommendationAttribution: effectiveAttribution,
        );
        _cartManager.addOrUpdateProduct(product);
        if (effectiveAttribution != null) {
          await _attributionStore.save(
            cartId: _cartManager.cart.id,
            productId: product.productId,
            attribution: effectiveAttribution,
          );
        }
        return Result.success(product);
      },
      error: (error) async => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  @override
  Future<Result<void>> removeProduct(int productId) async {
    final currentProduct = _cartManager.findProduct(productId);
    final currentQuantity = currentProduct?.quantity ?? 1;
    final response = await _dataSource.removeProduct(productId, currentQuantity: currentQuantity);
    return response.when(
      completed: (_, __) async {
        if (currentProduct != null && currentQuantity > 1) {
          _cartManager.addOrUpdateProduct(currentProduct.copyWith(quantity: currentQuantity - 1));
        } else {
          _cartManager.removeProduct(productId);
          await _attributionStore.remove(cartId: _cartManager.cart.id, productId: productId);
        }
        return const Result.success(null);
      },
      error: (error) async => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }
}
