import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';

abstract class CategoryDataSource {
  Future<List<CategoryEntity>> getCategories();

  Future<bool> setCategories(List<CategoryEntity> categories);
}
