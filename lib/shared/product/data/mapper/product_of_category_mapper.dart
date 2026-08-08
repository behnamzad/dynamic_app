import 'package:dynamic_app/shared/product/data/mapper/product_mapper.dart';
import 'package:dynamic_app/shared/product/data/models/brand/brand_dto.dart';
import 'package:dynamic_app/shared/product/data/models/product/product_dto.dart';
import 'package:dynamic_app/shared/product/data/models/product_of_category/product_of_category_response.dart';
import 'package:dynamic_app/shared/product/domain/entities/brand_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/search_result_entity.dart';

extension ProductOfCategoryMapper on ProductOfCategoryResponse {
  SearchResultEntity toEntity() {
    final List<BrandEntity> brands = result
        .expand((item) => item.data.brands ?? const <BrandDto>[])
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
      products: result
          .expand((item) => item.data.products ?? const <ProductDto>[])
          .map(
            (product) => product.toEntity(
              brandOverride: resolveProductBrand(product, brands),
            ),
          )
          .toList(growable: false),
    );
  }
}
