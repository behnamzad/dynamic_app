import 'package:dynamic_app/core/config/configs.dart';
import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/category/data/datasource/category_data_source.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';
import 'package:dynamic_app/shared/category/domain/repository/category_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource _dataSource;

  CategoryRepositoryImpl(this._dataSource);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final storedCategories = await _dataSource.getCategories();
      final categories = _prepareCategories(storedCategories);

      if (storedCategories.isEmpty) {
        await _dataSource.setCategories(categories);
      }

      return categories;
    } catch (e) {
      return Configs.defaultCategories;
    }
  }

  @override
  Future<Result<void>> setCategories(List<CategoryEntity> categories) async {
    try {
      final preparedCategories = _prepareCategories(categories);
      final isSaved = await _dataSource.setCategories(preparedCategories);
      return isSaved ? const Result.success(null) : Result.failure(ResultException.def());
    } catch (_) {
      return Result.failure(ResultException.def());
    }
  }

  @override
  Future<Result<void>> replaceCategory(CategoryEntity category) async {
    try {
      final storedCategories = await _dataSource.getCategories();
      final categories = _prepareCategories(storedCategories).toList();
      final categoryIndex = categories.indexWhere((item) => item.id == category.id);

      if (categoryIndex == -1) {
        return Result.failure(ResultException.def());
      }

      categories[categoryIndex] = category;
      final preparedCategories = _prepareCategories(categories);
      final isSaved = await _dataSource.setCategories(preparedCategories);

      return isSaved ? const Result.success(null) : Result.failure(ResultException.def());
    } catch (_) {
      return Result.failure(ResultException.def());
    }
  }

  List<CategoryEntity> _prepareCategories(List<CategoryEntity> storedCategories) {
    final categories = <CategoryEntity>[];

    // ترتیب ذخیره‌شده حفظ می‌شود و دسته تکراری دوباره اضافه نمی‌شود.
    for (final storedCategory in storedCategories) {
      final isAlreadyAdded = categories.any((category) => category.id == storedCategory.id);

      if (!isAlreadyAdded) {
        categories.add(storedCategory);
      }
    }

    // اگر یکی از ۱۰ دسته در حافظه نبود، دوباره به لیست اضافه می‌شود.
    for (final defaultCategory in Configs.defaultCategories) {
      final isAlreadyAdded = categories.any((category) => category.id == defaultCategory.id);

      if (!isAlreadyAdded) {
        categories.add(defaultCategory);
      }
    }

    // پیشنهادهای AI بدون تغییر ترتیب داخلی‌شان، ابتدای لیست قرار می‌گیرند.
    final aiSuggestedCategories = categories.where((category) => category.aiSuggest);
    final otherCategories = categories.where((category) => !category.aiSuggest);

    return List.unmodifiable([...aiSuggestedCategories, ...otherCategories]);
  }
}
