class CartProductEntity {
  final int productId;
  final int categoryId;
  final int quantity;

  const CartProductEntity({
    required this.productId,
    required this.categoryId,
    required this.quantity,
  });

  CartProductEntity copyWith({int? quantity}) {
    return CartProductEntity(
      productId: productId,
      categoryId: categoryId,
      quantity: quantity ?? this.quantity,
    );
  }
}
