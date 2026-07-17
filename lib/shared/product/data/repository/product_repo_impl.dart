import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:dynamic_app/shared/product/data/mapper/product_mapper.dart';
import 'package:dynamic_app/shared/product/data/mapper/product_of_category_mapper.dart';
import 'package:dynamic_app/shared/product/data/mapper/product_specification_mapper.dart';
import 'package:dynamic_app/shared/product/data/models/product/product_response.dart';
import 'package:dynamic_app/shared/product/data/models/product_of_category/product_of_category_response.dart';
import 'package:dynamic_app/shared/product/data/models/product_specifications/product_specifications_dto.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_of_category_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/product_repo.dart';
import '../datasource/product_date_source.dart';

@Injectable(as: ProductRepo)
class ProductRepoImpl implements ProductRepo {
  final ProductDateSource _dateSource;

  ProductRepoImpl(this._dateSource);

  @override
  Future<Result<ProductEntity>> getProduct({required int id}) async {
    ApiResponse<ProductResponse> response = await _dateSource.getProduct(id: id);
    return response.when(
      completed: (data, _) {
        try {
          return Result.success(data.result.product.toEntity());
        } catch (e) {
          return Result.success(data.result.product.toEntity());
        }
      },
      error: (error) {
        return Result.failure(ResultException.def());
      },
    );
  }

  @override
  Future<Result<dynamic>> search({required String query, int? page}) async {
    _dateSource.search(query: query, page: page);
    return const Result.success('data');
  }

  @override
  Future<Result<dynamic>> getCategories() async {
    _dateSource.getCategories();
    return const Result.success('data');
  }

  @override
  Future<Result<ProductAndBrandsOfCategoryResultEntity>> getProductByCategory({
    required int categoryId,
    int? page,
  }) async {
    final ApiResponse<ProductOfCategoryResponse> response = await _dateSource.getProductByCategory(
      categoryId: categoryId,
      page: page,
    );
    return response.when(
      completed: (data, _) => Result.success(data.toEntity()),
      error: (_) => Result.failure(ResultException.def()),
    );
  }

  @override
  Future<Result<List<ProductSpecificationEntity>>> getProductSpecifications({required int id}) async {
    ApiResponse<ProductSpecificationDto> response = await _dateSource.getProductSpecifications(id: id);
    return response.when(
      completed: (data, _) {
        return Result.success(data.toEntityList());
      },
      error: (error) {
        return Result.failure(ResultException.def());
      },
    );
  }
}
