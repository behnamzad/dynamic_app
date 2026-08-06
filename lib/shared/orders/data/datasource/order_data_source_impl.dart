import 'package:dio/dio.dart';
import 'package:dynamic_app/core/config/strings.dart';
import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/di/di_const.dart';
import 'package:dynamic_app/infrastructure/network/dio_caller.dart';
import 'package:dynamic_app/infrastructure/network/model/api_error.dart';
import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:dynamic_app/shared/orders/data/datasource/order_data_source.dart';
import 'package:dynamic_app/shared/orders/data/models/address_dto.dart';
import 'package:dynamic_app/shared/orders/data/models/order_dto.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderDataSource)
class OrderDataSourceImpl implements OrderDataSource {
  final DioCaller _dioCaller;
  final UserManager _userManager;

  OrderDataSourceImpl(@Named(DiConst.dioSupabaseRest) this._dioCaller, this._userManager);

  String? get _userId => _userManager.currentUserId;

  @override
  Future<ApiResponse<List<OrderDto>>> getOrders() async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(apiError: Unauthorized(ss.userNotLoggedIn, '401'));
    }

    return _dioCaller.get<List<OrderDto>>(
      'orders',
      queryParameters: {'select': '*,order_items(*)', 'user_id': 'eq.$userId', 'order': 'created_at.desc'},
      fromJson: (json) => (json as List)
          .map((item) => OrderDto.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
    );
  }

  @override
  Future<ApiResponse<OrderDto>> placeOrder({required String addressId, required String deliveryWindow}) {
    return _dioCaller.post<OrderDto>(
      'rpc/checkout_cart',
      data: {'input_address_id': addressId, 'input_delivery_window': deliveryWindow},
      fromJson: (json) {
        final value = json is List && json.isNotEmpty ? json.first : json;
        return OrderDto.fromJson(Map<String, dynamic>.from(value as Map));
      },
    );
  }

  @override
  Future<ApiResponse<List<AddressDto>>> getAddresses() async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(apiError: Unauthorized(ss.userNotLoggedIn, '401'));
    }

    return _dioCaller.get<List<AddressDto>>(
      'addresses',
      queryParameters: {'select': '*', 'user_id': 'eq.$userId', 'order': 'created_at.desc'},
      fromJson: (json) => (json as List)
          .map((item) => AddressDto.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
    );
  }

  @override
  Future<ApiResponse<AddressDto>> addAddress({
    required String province,
    required String city,
    required String addressLine,
  }) async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(apiError: Unauthorized(ss.userNotLoggedIn, '401'));
    }

    return _dioCaller.post<AddressDto>(
      'addresses',
      data: {'user_id': userId, 'province': province, 'city': city, 'address_line': addressLine},
      queryParameters: {'select': '*'},
      options: Options(headers: {'Prefer': 'return=representation'}),
      fromJson: (json) => AddressDto.fromJson(Map<String, dynamic>.from((json as List).first as Map)),
    );
  }

  @override
  Future<ApiResponse<void>> deleteAddress(String addressId) async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(apiError: Unauthorized(ss.userNotLoggedIn, '401'));
    }

    return _dioCaller.delete<void>(
      'addresses',
      queryParameters: {'id': 'eq.$addressId', 'user_id': 'eq.$userId'},
      fromJson: (_) {},
    );
  }
}
