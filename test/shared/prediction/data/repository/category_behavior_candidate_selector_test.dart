import 'package:dynamic_app/shared/prediction/data/models/prediction_artifacts.dart';
import 'package:dynamic_app/shared/prediction/data/repository/category_behavior_candidate_selector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('selects same-category fallbacks by purchase rate then click rate', () {
    const List<PredictionProduct> catalog = <PredictionProduct>[
      PredictionProduct(
        productId: 'source',
        categoryId: 'laptop',
        brandId: 'brand',
        globalProductPurchaseRate: 0.90,
        globalProductClickRate: 0.90,
      ),
      PredictionProduct(
        productId: 'best-purchase',
        categoryId: 'laptop',
        brandId: 'brand',
        globalProductPurchaseRate: 0.08,
        globalProductClickRate: 0.10,
      ),
      PredictionProduct(
        productId: 'best-click',
        categoryId: 'laptop',
        brandId: 'brand',
        globalProductPurchaseRate: 0.04,
        globalProductClickRate: 0.30,
      ),
      PredictionProduct(
        productId: 'lower-click',
        categoryId: 'laptop',
        brandId: 'brand',
        globalProductPurchaseRate: 0.04,
        globalProductClickRate: 0.20,
      ),
      PredictionProduct(
        productId: 'phone',
        categoryId: 'phone',
        brandId: 'brand',
        globalProductPurchaseRate: 0.50,
        globalProductClickRate: 0.50,
      ),
    ];

    final List<String> selected = CategoryBehaviorCandidateSelector.select(
      catalog: catalog,
      productId: 'source',
      categoryId: 'laptop',
      limit: 3,
    );

    expect(selected, <String>['best-purchase', 'best-click', 'lower-click']);
  });
}
