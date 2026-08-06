import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:dynamic_app/shared/product/data/models/category/category_response.dart';
import 'package:dynamic_app/shared/product/data/models/product/product_response.dart';
import 'package:dynamic_app/shared/product/data/models/product_by_brand/product_by_brand_response.dart';
import 'package:dynamic_app/shared/product/data/models/product_of_category/product_of_category_response.dart';
import 'package:dynamic_app/shared/product/data/models/product_specifications/product_specifications_dto.dart';
import 'package:dynamic_app/shared/product/data/models/search/search_response.dart';

abstract class ProductDateSource {
  Future<ApiResponse<SearchResponse>> search({
    required String query,
    int? page,
  });

  Future<ApiResponse<ProductResponse>> getProduct({required int id});

  Future<ApiResponse<CategoryResponse>> getCategories();

  Future<ApiResponse<ProductOfCategoryResponse>> getProductByCategory({
    required int categoryId,
    int? page,
  });

  Future<ApiResponse<ProductByBrandResponse>> getProductByBrand({
    required int brandId,
    int? page,
  });

  Future<ApiResponse<ProductSpecificationDto>> getProductSpecifications({
    required int id,
  });
}
