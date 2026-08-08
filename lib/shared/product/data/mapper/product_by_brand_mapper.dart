import 'package:dynamic_app/shared/product/data/mapper/product_mapper.dart';
import 'package:dynamic_app/shared/product/data/models/product_by_brand/product_by_brand_response.dart';
import 'package:dynamic_app/shared/product/domain/entities/brand_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/search_result_entity.dart';

extension ProductByBrandMapper on ProductByBrandResponse {
  SearchResultEntity toEntity() {
    final BrandEntity brand = BrandEntity(
      id: result.brand.id,
      titleFa: result.brand.titleFa,
      titleEn: result.brand.titleEn,
      image: result.brand.image,
    );
    return SearchResultEntity(
      brands: <BrandEntity>[brand],
      products: result.products
          .map(
            (product) => product.toEntity(
              brandOverride: product.brand.id > 0 ? null : brand,
            ),
          )
          .toList(growable: false),
    );
  }
}
