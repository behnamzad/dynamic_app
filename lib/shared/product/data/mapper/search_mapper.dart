import 'package:dynamic_app/shared/product/data/mapper/product_mapper.dart';
import 'package:dynamic_app/shared/product/data/models/search/search_response.dart';
import 'package:dynamic_app/shared/product/domain/entities/brand_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/search_result_entity.dart';

extension SearchMapper on SearchResponse {
  SearchResultEntity toEntity() {
    final List<BrandEntity> brands = result.brands
        .map(
          (brand) => BrandEntity(
            id: brand.id,
            titleFa: brand.titleFa,
            titleEn: brand.titleEn,
            image: brand.image,
          ),
        )
        .toList(growable: false);
    return SearchResultEntity(
      brands: brands,
      products: result.products
          .map(
            (product) => product.toEntity(
              brandOverride: resolveProductBrand(product, brands),
            ),
          )
          .toList(growable: false),
    );
  }
}
