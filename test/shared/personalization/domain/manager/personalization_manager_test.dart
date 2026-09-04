import 'package:dynamic_app/shared/personalization/domain/entities/personalization_action.dart';
import 'package:dynamic_app/shared/personalization/domain/manager/personalization_manager.dart';
import 'package:dynamic_app/shared/prediction/domain/entities/personalization_thresholds.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersonalizationManager', () {
    const PersonalizationThresholds thresholds = PersonalizationThresholds(
      alternativeProductsMax: 0.025,
      informationHighlightMax: 0.05,
    );

    test('maps the exact model boundaries to the intended UI actions', () {
      expect(
        PersonalizationManager.actionForPurchaseProbability(probability: 0, thresholds: thresholds),
        PersonalizationAction.showAlternativeProducts,
      );
      expect(
        PersonalizationManager.actionForPurchaseProbability(probability: 0.025, thresholds: thresholds),
        PersonalizationAction.showAlternativeProducts,
      );
      expect(
        PersonalizationManager.actionForPurchaseProbability(probability: 0.0250001, thresholds: thresholds),
        PersonalizationAction.highlightReviewsAndSpecifications,
      );
      expect(
        PersonalizationManager.actionForPurchaseProbability(probability: 0.05, thresholds: thresholds),
        PersonalizationAction.highlightReviewsAndSpecifications,
      );
      expect(
        PersonalizationManager.actionForPurchaseProbability(probability: 0.0500001, thresholds: thresholds),
        PersonalizationAction.highlightAddToCartButton,
      );
      expect(
        PersonalizationManager.actionForPurchaseProbability(probability: 1, thresholds: thresholds),
        PersonalizationAction.highlightAddToCartButton,
      );
    });

    test('rejects non-finite and out-of-range probabilities', () {
      expect(
        () => PersonalizationManager.actionForPurchaseProbability(probability: double.nan, thresholds: thresholds),
        throwsRangeError,
      );
      expect(
        () => PersonalizationManager.actionForPurchaseProbability(probability: double.infinity, thresholds: thresholds),
        throwsRangeError,
      );
      expect(
        () => PersonalizationManager.actionForPurchaseProbability(probability: -0.01, thresholds: thresholds),
        throwsRangeError,
      );
      expect(
        () => PersonalizationManager.actionForPurchaseProbability(probability: 1.01, thresholds: thresholds),
        throwsRangeError,
      );
    });

  });
}
