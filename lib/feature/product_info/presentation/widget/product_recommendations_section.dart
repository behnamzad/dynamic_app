import 'package:dynamic_app/core/presentation/widget/app/product_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/ai_personalization_card.dart';
import 'package:dynamic_app/shared/behavior/data/mapper/product_behavior_snapshot_mapper.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalized_product_suggestion.dart';

/// لیست افقی محصولاتی که مدل برای این درخواست مرتب کرده است.
class ProductRecommendationsSection extends StatelessWidget {
  const ProductRecommendationsSection({
    super.key,
    required this.suggestions,
    required this.requestId,
    required this.strategy,
  });

  final List<PersonalizedProductSuggestion> suggestions;
  final String requestId;
  final String strategy;

  @override
  Widget build(BuildContext context) {
    return AiPersonalizationCard(
      title: ss.aiRecommendedProducts,
      child: SizedBox(
        height: Dimen.productCardHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            final PersonalizedProductSuggestion suggestion = suggestions[index];
            return ProductWidget.card(
              entity: suggestion.product,
              sourceScreen: 'product_detail_alternatives',
              position: index,
              recommendationAttribution: RecommendationAttribution(
                requestId: requestId,
                productSnapshot: suggestion.product.toBehaviorSnapshot(),
                modelVersion: suggestion.prediction.modelVersion,
                strategy: strategy,
                confidence: suggestion.prediction.purchaseProbability,
                displayRank: index,
                displaySlot: 'product_detail_alternatives',
              ),
            );
          },
        ),
      ),
    );
  }
}
