import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';

class CartProductEntity {
  final int productId;
  final int categoryId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final int price;
  final RecommendationAttribution? recommendationAttribution;

  const CartProductEntity({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    this.recommendationAttribution,
  });

  CartProductEntity copyWith({
    String? productName,
    String? imageUrl,
    int? quantity,
    int? price,
    RecommendationAttribution? recommendationAttribution,
  }) {
    return CartProductEntity(
      productId: productId,
      categoryId: categoryId,
      productName: productName ?? this.productName,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      recommendationAttribution: recommendationAttribution ?? this.recommendationAttribution,
    );
  }
}
