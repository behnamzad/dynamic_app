import 'package:dynamic_app/core/util/shared_preferences_helper.dart';
import 'package:dynamic_app/shared/category/data/datasource/category_data_source.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoryDataSource)
class CategoryDataSourceImpl implements CategoryDataSource {
  final SharedPreferencesHelper prefs;
  final String _categoryKey = 'category_key_v5';

  CategoryDataSourceImpl(this.prefs);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final jsonObject = prefs.getJsonObject(_categoryKey, defaultValue: '[]');

    if (jsonObject is! List) {
      return [];
    }

    return jsonObject
        .whereType<Map>()
        .map((item) => CategoryEntity.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  @override
  Future<bool> setCategories(List<CategoryEntity> categories) {
    return prefs.setJsonObject(_categoryKey, categories.map((category) => category.toJson()).toList(growable: false));
  }
}
