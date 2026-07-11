import 'package:dio/dio.dart';
import 'package:dynamic_app/di/di_const.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class SupabaseCartDataSource {
  final SupabaseClient _client;
  final Dio _dio;

  SupabaseCartDataSource(
    this._client,
    @Named(DiConst.dioSupabaseRest) this._dio,
  );

  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in');
    }
    return user.id;
  }

  Future<Map<String, dynamic>> getActiveCart() async {
    final userId = _userId;

    // شروع عملیات سبد خرید از CartBloc/CartPage خواهد بود و اینجا با Dio به جدول carts می‌رود.
    final existingCartResponse = await _dio.get(
      'carts',
      queryParameters: {
        'select': '*',
        'user_id': 'eq.$userId',
        'status': 'eq.active',
        'limit': 1,
      },
    );
    final existingCarts = List<Map<String, dynamic>>.from(existingCartResponse.data as List);

    if (existingCarts.isNotEmpty) {
      return existingCarts.first;
    }

    final createCartResponse = await _dio.post(
      'carts',
      data: {'user_id': userId},
      queryParameters: {'select': '*'},
      options: Options(headers: {'Prefer': 'return=representation'}),
    );
    final createdCarts = List<Map<String, dynamic>>.from(createCartResponse.data as List);
    return createdCarts.first;
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final cart = await getActiveCart();

    // خواندن آیتم‌های سبد از مسیر Dio انجام می‌شود تا request/response در PrettyDioLogger دیده شود.
    final response = await _dio.get(
      'cart_items',
      queryParameters: {
        'select': '*',
        'cart_id': 'eq.${cart['id']}',
        'order': 'created_at.asc',
      },
    );

    return List<Map<String, dynamic>>.from(response.data as List);
  }

  Future<void> addOrUpdateItem({
    required String productId,
    required String productTitle,
    required int quantity,
    required num unitPrice,
  }) async {
    final userId = _userId;
    final cart = await getActiveCart();

    // افزودن یا به‌روزرسانی محصول از REST API Supabase انجام می‌شود و لاگ کامل Dio دارد.
    await _dio.post(
      'cart_items',
      data: [
        {
          'cart_id': cart['id'],
          'user_id': userId,
          'product_id': productId,
          'product_title': productTitle,
          'quantity': quantity,
          'unit_price': unitPrice,
        }
      ],
      queryParameters: {'on_conflict': 'cart_id,product_id'},
      options: Options(headers: {'Prefer': 'resolution=merge-duplicates,return=minimal'}),
    );
  }

  Future<void> removeItem(String itemId) async {
    // حذف آیتم سبد از همین مسیر Dio می‌گذرد تا عملیات قابل ردگیری باشد.
    await _dio.delete(
      'cart_items',
      queryParameters: {
        'id': 'eq.$itemId',
        'user_id': 'eq.$_userId',
      },
    );
  }

  Future<void> clearCart() async {
    final cart = await getActiveCart();

    // پاک کردن کامل سبد از CartPage/CartBloc شروع می‌شود و اینجا به cart_items می‌رسد.
    await _dio.delete(
      'cart_items',
      queryParameters: {
        'cart_id': 'eq.${cart['id']}',
        'user_id': 'eq.$_userId',
      },
    );
  }
}
