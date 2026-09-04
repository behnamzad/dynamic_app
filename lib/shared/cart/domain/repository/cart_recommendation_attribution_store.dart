import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';

/// قرارداد ذخیره محلی attribution سبد؛ لایه‌های بالاتر به SharedPreferences وابسته نیستند.
abstract interface class CartRecommendationAttributionStore {
  Future<Map<int, RecommendationAttribution>> read(String cartId);

  Future<void> save({
    required String cartId,
    required int productId,
    required RecommendationAttribution attribution,
  });

  Future<void> remove({required String cartId, required int productId});

  Future<void> clear(String cartId);
}
