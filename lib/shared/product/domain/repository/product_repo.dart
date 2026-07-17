import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_of_category_entity.dart';

abstract class ProductRepo {
  Future<Result<dynamic>> search({required String query, int? page});

  Future<Result<ProductEntity>> getProduct({required int id});

  Future<Result<dynamic>> getCategories();

  Future<Result<ProductAndBrandsOfCategoryResultEntity>> getProductByCategory({required int categoryId, int? page});

  Future<Result<List<ProductSpecificationEntity>>> getProductSpecifications({required int id});
}
