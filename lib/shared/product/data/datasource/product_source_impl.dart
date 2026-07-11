import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/di/di_const.dart';
import 'package:dynamic_app/infrastructure/network/dio_caller.dart';
import 'package:dynamic_app/shared/product/data/models/category/category_response.dart';
import 'package:dynamic_app/shared/product/data/models/product/product_response.dart';
import 'package:dynamic_app/shared/product/data/models/product_specifications/product_specifications_dto.dart';

import 'product_date_source.dart';

@Injectable(as: ProductDateSource)
class ProductDateSourceImpl implements ProductDateSource {
  final DioCaller dioCaller;

  ProductDateSourceImpl({@Named(DiConst.dioDigikala) required this.dioCaller});

  @override
  Future<ApiResponse<ProductResponse>> search({required String query, int? page}) {
    return dioCaller.get(
      'search/',
      queryParameters: {'q': query, if (page != null) 'page': page},
      fromJson: ProductResponse.fromJson,
    );
  }

  @override
  Future<ApiResponse<ProductResponse>> getProduct({required int id})  {
      return dioCaller.get('product/', queryParameters: {'id': id}, fromJson: ProductResponse.fromJson);

  }

  @override
  Future<ApiResponse<CategoryResponse>> getCategories() {
    return dioCaller.get('categories/', fromJson: CategoryResponse.fromJson);
  }

  @override
  Future<ApiResponse<dynamic>> getProductByCategory({required int categoryId, int? page}) {
    return dioCaller.get(
      'category/',
      queryParameters: {'id': categoryId, if (page != null) 'page': page},
      fromJson: CategoryResponse.fromJson,
    );
  }

  @override
  Future<ApiResponse<ProductSpecificationDto>> getProductSpecifications({required int id}) {
    return dioCaller.get('product/specifications/', queryParameters: {'id': id}, fromJson: CategoryResponse.fromJson);
  }
}
