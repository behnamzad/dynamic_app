import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/cart/data/datasource/cart_data_source.dart';
import 'package:dynamic_app/shared/cart/data/mapper/cart_mapper.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartDataSource _dataSource;

  CartRepositoryImpl(this._dataSource);

  @override
  Future<Result<CartEntity>> getCart() async {
    final response = await _dataSource.getCart();
    return response.when(
      completed: (data, _) => Result.success(data.toEntity()),
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  @override
  Future<Result<CartProductEntity>> addProduct({
    required int productId,
    required int categoryId,
    required int quantity,
  }) async {
    final response = await _dataSource.addProduct(
      productId: productId,
      categoryId: categoryId,
      quantity: quantity,
    );
    return response.when(
      completed: (data, _) => Result.success(data.toEntity()),
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  @override
  Future<Result<void>> removeProduct(int productId) async {
    final response = await _dataSource.removeProduct(productId);
    return response.when(
      completed: (_, __) => const Result.success(null),
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }
}
