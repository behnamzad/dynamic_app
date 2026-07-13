class CartDto {
  final String id;

  const CartDto({required this.id});

  factory CartDto.fromJson(Map<String, dynamic> json) {
    return CartDto(id: json['id']?.toString() ?? '');
  }
}

class CartProductDto {
  final int productId;
  final int categoryId;
  final int quantity;

  const CartProductDto({
    required this.productId,
    required this.categoryId,
    required this.quantity,
  });

  factory CartProductDto.fromJson(Map<String, dynamic> json) {
    return CartProductDto(
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
    );
  }
}

class CartResponseDto {
  final String cartId;
  final List<CartProductDto> products;

  const CartResponseDto({required this.cartId, required this.products});
}
