import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/orders/domain/entities/address_entity.dart';
import 'package:dynamic_app/shared/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Result<List<OrderEntity>>> getOrders();

  Future<Result<OrderEntity>> placeOrder({
    required String addressId,
    required String deliveryWindow,
  });

  Future<Result<List<AddressEntity>>> getAddresses();

  Future<Result<AddressEntity>> addAddress({
    required String province,
    required String city,
    required String addressLine,
  });

  Future<Result<void>> deleteAddress(String addressId);
}
