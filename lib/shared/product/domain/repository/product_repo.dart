import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/search_result_entity.dart';

abstract class ProductRepo {
  Future<Result<SearchResultEntity>> search({required String query, int? page});

  Future<Result<ProductEntity>> getProduct({required int id});

  Future<Result<dynamic>> getCategories();

  Future<Result<SearchResultEntity>> getProductByCategory({
    required int categoryId,
    int? page,
  });

  Future<Result<SearchResultEntity>> getProductByBrand({
    required int brandId,
    int? page,
  });

  Future<Result<List<ProductSpecificationEntity>>> getProductSpecifications({
    required int id,
  });
}
