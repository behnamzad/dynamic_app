import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

class ProductAndBrandsOfCategoryResultEntity {
  final List<ProductEntity> product;
  final List<BrandOfCategoryEntity> brands;

  const ProductAndBrandsOfCategoryResultEntity({required this.product, required this.brands});
}

class BrandOfCategoryEntity {
  final int id;
  final String titleFa;
  final String titleEn;
  final String image;

  const BrandOfCategoryEntity({required this.id, required this.titleFa, required this.titleEn, required this.image});
}
