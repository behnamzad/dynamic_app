class ProductSpecificationEntity {
  final String groupTitle;
  final List<ProductSpecificationItemEntity> items;

  const ProductSpecificationEntity({
    required this.groupTitle,
    required this.items,
  });
}

class ProductSpecificationItemEntity {
  final String title;
  final List<String> values;

  const ProductSpecificationItemEntity({
    required this.title,
    required this.values,
  });
}