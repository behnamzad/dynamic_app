import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:dynamic_app/shared/product/data/models/category/category_response.dart';
import 'package:dynamic_app/shared/product/data/models/product/product_response.dart';
import 'package:dynamic_app/shared/product/data/models/product_specifications/product_specifications_dto.dart';

abstract class ProductDateSource {
  Future<ApiResponse<ProductResponse>> search({required String query, int? page});

  Future<ApiResponse<ProductResponse>> getProduct({required int id});

  Future<ApiResponse<CategoryResponse>> getCategories();

  Future<ApiResponse<dynamic>> getProductByCategory({required int categoryId, int? page});

  Future<ApiResponse<ProductSpecificationDto>> getProductSpecifications({required int id});

}
