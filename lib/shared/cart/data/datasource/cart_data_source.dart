import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:dynamic_app/shared/cart/data/models/cart_dto.dart';

abstract class CartDataSource {
  Future<ApiResponse<CartResponseDto>> getCart();

  Future<ApiResponse<CartProductDto>> addProduct({
    required int productId,
    required int categoryId,
    required int quantity,
  });

  Future<ApiResponse<void>> removeProduct(int productId);
}
