import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/cart/data/datasource/cart_data_source.dart';
import 'package:dynamic_app/shared/cart/data/mapper/cart_mapper.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_repository.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartDataSource _dataSource;
  final CartManager _cartManager;

  CartRepositoryImpl(this._dataSource, this._cartManager);

  @override
  Future<Result<CartEntity>> getCart() async {
    if (_cartManager.isCartLoaded) {
      return Result.success(_cartManager.cart);
    }

    final response = await _dataSource.getCart();
    return response.when(
      completed: (data, _) {
        final cart = data.toEntity();
        _cartManager.setCart(cart);
        return Result.success(cart);
      },
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  @override
  Future<Result<CartProductEntity>> addProduct({required ProductEntity entity, required int quantity}) async {
    final currentProduct = _cartManager.findProduct(entity.id);
    final updatedQuantity = (currentProduct?.quantity ?? 0) + quantity;
    final response = await _dataSource.addProduct(
      productId: entity.id,
      categoryId: entity.categoryId,
      productName: entity.titleFa,
      imageUrl: entity.images.isEmpty ? '' : entity.images.first,
      quantity: updatedQuantity,
      price: entity.price,
    );
    return response.when(
      completed: (data, _) {
        final product = data.toEntity();
        _cartManager.addOrUpdateProduct(product);
        return Result.success(product);
      },
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  @override
  Future<Result<void>> removeProduct(int productId) async {
    final currentProduct = _cartManager.findProduct(productId);
    final currentQuantity = currentProduct?.quantity ?? 1;
    final response = await _dataSource.removeProduct(productId, currentQuantity: currentQuantity);
    return response.when(
      completed: (_, __) {
        if (currentProduct != null && currentQuantity > 1) {
          _cartManager.addOrUpdateProduct(currentProduct.copyWith(quantity: currentQuantity - 1));
        } else {
          _cartManager.removeProduct(productId);
        }
        return const Result.success(null);
      },
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }
}
