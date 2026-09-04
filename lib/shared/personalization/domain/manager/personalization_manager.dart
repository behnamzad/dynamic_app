import 'package:dynamic_app/core/model/result.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalization_action.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalization_decision.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalized_product_suggestion.dart';
import 'package:dynamic_app/shared/prediction/domain/entities/personalization_thresholds.dart';
import 'package:dynamic_app/shared/prediction/domain/entities/prediction_model_info.dart';
import 'package:dynamic_app/shared/prediction/domain/entities/product_prediction.dart';
import 'package:dynamic_app/shared/prediction/domain/manager/prediction_manager.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/shared/product/domain/repository/product_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

/// مدل و مرزهایش را می‌خواند و تصمیم آماده UI را می‌سازد.
@lazySingleton
class PersonalizationManager {
  const PersonalizationManager(this._predictionManager, this._productRepo);

  final PredictionManager _predictionManager;
  final ProductRepo _productRepo;

  Future<PersonalizationDecision> decisionForProduct(ProductEntity product) async {
    final PredictionModelInfo model = await _predictionManager.modelInfo();
    final ProductPrediction prediction = await _predictionManager.purchasePrediction(product);
    return PersonalizationDecision(
      decisionId: const Uuid().v4(),
      action: actionForPurchaseProbability(
        probability: prediction.purchaseProbability,
        thresholds: model.personalizationThresholds,
      ),
      purchaseProbability: prediction.purchaseProbability,
      modelVersion: prediction.modelVersion,
    );
  }

  Future<List<PersonalizedProductSuggestion>> alternativeProductsFor(ProductEntity product) async {
    final List<ProductPrediction> predictions = await _predictionManager.relatedProductsByPurchaseProbability(
      product,
      limit: 6,
    );
    final List<PersonalizedProductSuggestion> suggestions = <PersonalizedProductSuggestion>[];
    final Set<int> addedProductIds = <int>{product.id};

    for (final ProductPrediction prediction in predictions) {
      final int? productId = int.tryParse(prediction.productId);
      if (productId == null || !addedProductIds.add(productId)) continue;

      final Result<ProductEntity> result = await _productRepo.getProduct(id: productId);
      if (result case Success<ProductEntity>(data: final ProductEntity suggestedProduct)) {
        suggestions.add(PersonalizedProductSuggestion(product: suggestedProduct, prediction: prediction));
      }
    }
    return suggestions;
  }

  static PersonalizationAction actionForPurchaseProbability({
    required double probability,
    required PersonalizationThresholds thresholds,
  }) {
    if (!probability.isFinite || probability < 0 || probability > 1) {
      throw RangeError.range(probability, 0, 1, 'probability');
    }
    if (!_validThresholds(thresholds)) {
      throw ArgumentError.value(thresholds, 'thresholds', 'Invalid personalization thresholds');
    }
    if (probability <= thresholds.alternativeProductsMax) {
      return PersonalizationAction.showAlternativeProducts;
    }
    if (probability <= thresholds.informationHighlightMax) {
      return PersonalizationAction.highlightReviewsAndSpecifications;
    }
    return PersonalizationAction.highlightAddToCartButton;
  }

  static bool _validThresholds(PersonalizationThresholds thresholds) {
    final double first = thresholds.alternativeProductsMax;
    final double second = thresholds.informationHighlightMax;
    return first.isFinite && second.isFinite && first >= 0 && first <= second && second <= 1;
  }
}
