import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:dynamic_app/shared/orders/data/models/address_dto.dart';
import 'package:dynamic_app/shared/orders/data/models/order_dto.dart';

abstract class OrderDataSource {
  Future<ApiResponse<List<OrderDto>>> getOrders();

  Future<ApiResponse<OrderDto>> placeOrder({
    required String addressId,
    required String deliveryWindow,
  });

  Future<ApiResponse<List<AddressDto>>> getAddresses();

  Future<ApiResponse<AddressDto>> addAddress({
    required String province,
    required String city,
    required String addressLine,
  });

  Future<ApiResponse<void>> deleteAddress(String addressId);
}
