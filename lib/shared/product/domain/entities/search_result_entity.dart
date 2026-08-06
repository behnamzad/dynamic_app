import 'package:dynamic_app/shared/product/domain/entities/brand_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

// search and get by category
class SearchResultEntity {
  final List<BrandEntity> brands;
  final List<ProductEntity> products;

  const SearchResultEntity({required this.brands, required this.products});
}
