import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_recommendation_attribution_store.dart';
import 'package:dynamic_app/shared/orders/data/datasource/order_data_source.dart';
import 'package:dynamic_app/shared/orders/data/mapper/address_mapper.dart';
import 'package:dynamic_app/shared/orders/data/mapper/order_mapper.dart';
import 'package:dynamic_app/shared/orders/domain/entities/address_entity.dart';
import 'package:dynamic_app/shared/orders/domain/entities/order_entity.dart';
import 'package:dynamic_app/shared/orders/domain/repository/order_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource _dataSource;
  final CartRecommendationAttributionStore _attributionStore;
  final CartManager _cartManager;

  OrderRepositoryImpl(this._dataSource, this._attributionStore, this._cartManager);

  @override
  Future<Result<List<OrderEntity>>> getOrders() async {
    final response = await _dataSource.getOrders();
    return response.when(
      completed: (data, _) => Result.success(data.map((item) => item.toEntity()).toList(growable: false)),
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  @override
  Future<Result<OrderEntity>> placeOrder({required String addressId, required String deliveryWindow}) async {
    final String cartId = _cartManager.cart.id;
    final response = await _dataSource.placeOrder(addressId: addressId, deliveryWindow: deliveryWindow);
    return response.when(
      completed: (data, _) async {
        await _attributionStore.clear(cartId);
        _cartManager.clear();
        return Result.success(data.toEntity());
      },
      error: (error) async => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  @override
  Future<Result<List<AddressEntity>>> getAddresses() async {
    final response = await _dataSource.getAddresses();
    return response.when(
      completed: (data, _) => Result.success(data.map((item) => item.toEntity()).toList(growable: false)),
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  @override
  Future<Result<AddressEntity>> addAddress({
    required String province,
    required String city,
    required String addressLine,
  }) async {
    final response = await _dataSource.addAddress(province: province, city: city, addressLine: addressLine);
    return response.when(
      completed: (data, _) => Result.success(data.toEntity()),
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }

  @override
  Future<Result<void>> deleteAddress(String addressId) async {
    final response = await _dataSource.deleteAddress(addressId);
    return response.when(
      completed: (_, __) => const Result.success(null),
      error: (error) => Result.failure(ResultException(code: error.code, errorMessage: error.message)),
    );
  }
}
