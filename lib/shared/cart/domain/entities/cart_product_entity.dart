class CartProductEntity {
  final int productId;
  final int categoryId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final int price;

  const CartProductEntity({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  CartProductEntity copyWith({
    String? productName,
    String? imageUrl,
    int? quantity,
    int? price,
  }) {
    return CartProductEntity(
      productId: productId,
      categoryId: categoryId,
      productName: productName ?? this.productName,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
