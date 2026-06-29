class ProductEntity {
  final int id;
  final String name;
  final String imageUrl;
  final String amount;
  final String rate;
  final String description;
  final int reviewCount;

  ProductEntity(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.amount,
      required this.rate,
      required this.reviewCount,
      required this.description});
}
