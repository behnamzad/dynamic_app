import 'package:dynamic_app/shared/product/data/mapper/product_mapper.dart';
import 'package:dynamic_app/shared/product/data/models/product/product_dto.dart';
import 'package:dynamic_app/shared/product/data/models/product_of_category/product_of_category_response.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_of_category_entity.dart';

extension ProductOfCategoryMapper on ProductOfCategoryResponse {
  ProductAndBrandsOfCategoryResultEntity toEntity() {
    return ProductAndBrandsOfCategoryResultEntity(
      brands: result
          .expand((item) => item.data.brands ?? const <BrandElement>[])
          .map(
            (brand) =>
                BrandOfCategoryEntity(id: brand.id, titleFa: brand.titleFa, titleEn: brand.titleEn, image: brand.image),
          )
          .toList(growable: false),
      product: result
          .expand((item) => item.data.products ?? const <ProductDto>[])
          .map((product) => product.toEntity())
          .toList(growable: false),
    );
  }
}

extension on Data {
  ProductAndBrandsOfCategoryResultEntity toEntity() {
    return ProductAndBrandsOfCategoryResultEntity(
      brands: (brands ?? [])
          .map(
            (brand) =>
                BrandOfCategoryEntity(id: brand.id, titleFa: brand.titleFa, titleEn: brand.titleEn, image: brand.image),
          )
          .toList(growable: false),
      product: (products ?? []).map((product) => product.toEntity()).toList(growable: false),
    );
  }
}
