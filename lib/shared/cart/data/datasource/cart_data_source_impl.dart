import 'package:dio/dio.dart';
import 'package:dynamic_app/core/config/strings.dart';
import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/di/di_const.dart';
import 'package:dynamic_app/infrastructure/network/dio_caller.dart';
import 'package:dynamic_app/infrastructure/network/model/api_error.dart';
import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:dynamic_app/shared/cart/data/datasource/cart_data_source.dart';
import 'package:dynamic_app/shared/cart/data/models/cart_dto.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartDataSource)
class CartDataSourceImpl implements CartDataSource {
  final DioCaller _dioCaller;
  final UserManager _userManager;
  final CartManager _cartManager;

  CartDataSourceImpl(
    @Named(DiConst.dioSupabaseRest) this._dioCaller,
    this._userManager,
    this._cartManager,
  );

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
    required String productName,
    required String imageUrl,
    required int quantity,
    required int price,
  }) async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(
        apiError: Unauthorized(ss.userNotLoggedIn, '401'),
      );
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
              'product_name': productName,
              'image_url': imageUrl,
              'quantity': quantity,
              'price': price,
            },
          ],
          queryParameters: {'on_conflict': 'cart_id,product_id'},
          options: Options(
            headers: {
              'Prefer': 'resolution=merge-duplicates,return=representation',
            },
          ),
          fromJson: (json) => CartProductDto.fromJson(
            Map<String, dynamic>.from((json as List).first as Map),
          ),
        );
      },
      error: (error) async => ApiResponse.error(apiError: error),
    );
  }

  @override
  Future<ApiResponse<void>> removeProduct(
    int productId, {
    required int currentQuantity,
  }) async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(
        apiError: Unauthorized(ss.userNotLoggedIn, '401'),
      );
    }
    final queryParameters = {
      'product_id': 'eq.$productId',
      'user_id': 'eq.$userId',
    };
    if (currentQuantity > 1) {
      return _dioCaller.patch<void>(
        'cart_items',
        data: {'quantity': currentQuantity - 1},
        queryParameters: queryParameters,
        fromJson: (_) {},
      );
    }

    return _dioCaller.delete<void>(
      'cart_items',
      queryParameters: queryParameters,
      fromJson: (_) {},
    );
  }

  Future<ApiResponse<CartDto>> _getOrCreateActiveCart() async {
    final userId = _userId;
    if (userId == null) {
      return ApiResponse.error(
        apiError: Unauthorized(ss.userNotLoggedIn, '401'),
      );
    }

    if (_cartManager.hasCart) {
      return ApiResponse.completed(data: CartDto(id: _cartManager.cart.id));
    }

    final response = await _dioCaller.get<List<CartDto>>(
      'carts',
      queryParameters: {
        'select': '*',
        'user_id': 'eq.$userId',
        'status': 'eq.active',
        'limit': 1,
      },
      fromJson: (json) => (json as List)
          .map(
            (item) => CartDto.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
    );

    return response.when(
      completed: (carts, statusCode) {
        if (carts.isNotEmpty) {
          _cartManager.setCartId(carts.first.id);
          return ApiResponse.completed(
            data: carts.first,
            statusCode: statusCode,
          );
        }
        return _createCart(userId);
      },
      error: (error) async => ApiResponse.error(apiError: error),
    );
  }

  Future<ApiResponse<CartDto>> _createCart(String userId) async {
    final response = await _dioCaller.post<CartDto>(
      'carts',
      data: {'user_id': userId},
      queryParameters: {'select': '*'},
      options: Options(headers: {'Prefer': 'return=representation'}),
      fromJson: (json) => CartDto.fromJson(
        Map<String, dynamic>.from((json as List).first as Map),
      ),
    );

    return response.when(
      completed: (cart, statusCode) {
        _cartManager.setCartId(cart.id);
        return ApiResponse.completed(data: cart, statusCode: statusCode);
      },
      error: (error) => ApiResponse.error(apiError: error),
    );
  }

  Future<ApiResponse<List<CartProductDto>>> _getProducts(String cartId) {
    return _dioCaller.get<List<CartProductDto>>(
      'cart_items',
      queryParameters: {
        'select': '*',
        'cart_id': 'eq.$cartId',
        'order': 'created_at.asc',
      },
      fromJson: (json) => (json as List)
          .map(
            (item) =>
                CartProductDto.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
    );
  }
}
