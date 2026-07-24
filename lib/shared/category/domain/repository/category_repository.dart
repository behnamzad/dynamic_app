import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();

  Future<Result<void>> setCategories(List<CategoryEntity> categories);

  Future<Result<void>> replaceCategory(CategoryEntity category);
}
