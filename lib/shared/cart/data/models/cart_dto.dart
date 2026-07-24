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
  final String productName;
  final String imageUrl;
  final int quantity;
  final int price;

  const CartProductDto({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  factory CartProductDto.fromJson(Map<String, dynamic> json) {
    return CartProductDto(
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
      productName: json['product_name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      price: int.tryParse(json['price'].toString()) ?? 0,
    );
  }
}

class CartResponseDto {
  final String cartId;
  final List<CartProductDto> products;

  const CartResponseDto({required this.cartId, required this.products});
}
