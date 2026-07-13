import 'package:dio/dio.dart';
import 'package:dynamic_app/core/config/strings.dart';
import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/di/di_const.dart';
import 'package:dynamic_app/infrastructure/network/dio_caller.dart';
import 'package:dynamic_app/infrastructure/network/model/api_error.dart';
import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:dynamic_app/shared/cart/data/datasource/cart_data_source.dart';
import 'package:dynamic_app/shared/cart/data/models/cart_dto.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartDataSource)
class CartDataSourceImpl implements CartDataSource {
  final DioCaller _dioCaller;
  final UserManager _userManager;

  CartDataSourceImpl(@Named(DiConst.dioSupabaseRest) this._dioCaller, this._userManager);

  String? get _userId => _userManager.currentUserId;

  @override
  Future<ApiResponse<CartResponseDto>> getCart() async {
    final cartResponse = await _getOrCreateActiveCart();
    return cartResponse.when(
      completed: (cart, _) async {
        final productsResponse = await _getProducts(cart.id);
        return productsResponse.when(
          completed: (products, statusCode) => ApiResponse.completed(
            data: CartResponseDto(cartId: cart.id, products: products),
            statusCode: statusCode,
          ),
          error: (error) => ApiResponse.error(apiError: error),
        );
      },
      error: (error) async => ApiResponse.error(apiError: error),
    );
  }

  @override
  Future<ApiResponse<CartProductDto>> addProduct({
    required int productId,
    required int categoryId,
    required int quantity,
  }) async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(apiError: Unauthorized(ss.userNotLoggedIn, '401'));
    }

    final cartResponse = await _getOrCreateActiveCart();
    return cartResponse.when(
      completed: (cart, _) {
        // درخواست افزودن از ProductInfoBloc شروع و با DioCaller به cart_items ارسال می‌شود.
        return _dioCaller.post<CartProductDto>(
          'cart_items',
          data: [
            {
              'cart_id': cart.id,
              'user_id': userId,
              'product_id': productId,
              'category_id': categoryId,
              'quantity': quantity,
            },
          ],
          queryParameters: {'on_conflict': 'cart_id,product_id'},
          options: Options(headers: {'Prefer': 'resolution=merge-duplicates,return=representation'}),
          fromJson: (json) => CartProductDto.fromJson(Map<String, dynamic>.from((json as List).first as Map)),
        );
      },
      error: (error) async => ApiResponse.error(apiError: error),
    );
  }

  @override
  Future<ApiResponse<void>> removeProduct(int productId) async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(apiError: Unauthorized(ss.userNotLoggedIn, '401'));
    }

    // حذف محصول نیز فقط از DioCaller مشترک عبور می‌کند تا خطا به ApiResponse تبدیل شود.
    return _dioCaller.delete<void>(
      'cart_items',
      queryParameters: {'product_id': 'eq.$productId', 'user_id': 'eq.$userId'},
      fromJson: (_) {},
    );
  }

  Future<ApiResponse<CartDto>> _getOrCreateActiveCart() async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(apiError: Unauthorized(ss.userNotLoggedIn, '401'));
    }

    final response = await _dioCaller.get<List<CartDto>>(
      'carts',
      queryParameters: {'select': '*', 'user_id': 'eq.$userId', 'status': 'eq.active', 'limit': 1},
      fromJson: (json) => (json as List)
          .map((item) => CartDto.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
    );

    return response.when(
      completed: (carts, statusCode) {
        if (carts.isNotEmpty) {
          return ApiResponse.completed(data: carts.first, statusCode: statusCode);
        }
        return _createCart(userId);
      },
      error: (error) async => ApiResponse.error(apiError: error),
    );
  }

  Future<ApiResponse<CartDto>> _createCart(String userId) {
    return _dioCaller.post<CartDto>(
      'carts',
      data: {'user_id': userId},
      queryParameters: {'select': '*'},
      options: Options(headers: {'Prefer': 'return=representation'}),
      fromJson: (json) => CartDto.fromJson(Map<String, dynamic>.from((json as List).first as Map)),
    );
  }

  Future<ApiResponse<List<CartProductDto>>> _getProducts(String cartId) {
    return _dioCaller.get<List<CartProductDto>>(
      'cart_items',
      queryParameters: {'select': '*', 'cart_id': 'eq.$cartId', 'order': 'created_at.asc'},
      fromJson: (json) => (json as List)
          .map((item) => CartProductDto.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
    );
  }
}
