import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/cart/data/datasource/cart_recommendation_attribution_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const RecommendationAttribution attribution = RecommendationAttribution(
    requestId: 'request-1',
    productSnapshot: BehaviorProductSnapshot(
      productId: '42',
      productName: 'گوشی نمونه',
      categoryId: '7',
      categoryName: 'موبایل',
      brandId: '3',
      brandName: 'برند نمونه',
    ),
    modelVersion: 'model-v1',
    strategy: 'collaborative_purchase_probability',
    confidence: 0.024,
    displayRank: 2,
    displaySlot: 'product_detail_alternatives',
  );

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('persists and restores attribution for a cart product', () async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final CartRecommendationAttributionDataSource dataSource =
        CartRecommendationAttributionDataSource(preferences);

    await dataSource.save(cartId: 'cart-1', productId: 42, attribution: attribution);
    final Map<int, RecommendationAttribution> restored = await dataSource.read('cart-1');

    expect(restored[42]?.requestId, 'request-1');
    expect(restored[42]?.productSnapshot.categoryName, 'موبایل');
    expect(restored[42]?.confidence, 0.024);
  });

  test('removes one product without clearing other attributions', () async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final CartRecommendationAttributionDataSource dataSource =
        CartRecommendationAttributionDataSource(preferences);

    await dataSource.save(cartId: 'cart-1', productId: 42, attribution: attribution);
    await dataSource.save(cartId: 'cart-1', productId: 43, attribution: attribution);
    await dataSource.remove(cartId: 'cart-1', productId: 42);
    final Map<int, RecommendationAttribution> restored = await dataSource.read('cart-1');

    expect(restored.containsKey(42), isFalse);
    expect(restored.containsKey(43), isTrue);
  });
}
