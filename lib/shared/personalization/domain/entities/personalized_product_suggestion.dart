import 'package:dynamic_app/shared/prediction/domain/entities/product_prediction.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

/// محصول قابل‌نمایش را کنار امتیازی که مدل داده نگه می‌دارد.
class PersonalizedProductSuggestion {
  const PersonalizedProductSuggestion({required this.product, required this.prediction});

  final ProductEntity product;
  final ProductPrediction prediction;
}
