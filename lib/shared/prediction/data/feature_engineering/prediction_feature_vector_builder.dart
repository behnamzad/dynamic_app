part of 'prediction_input_builder.dart';

/// از تاریخچه آماده‌شده، مقدار نام‌دار تمام ورودی‌های مدل را می‌سازد.
class _PredictionFeatureVectorBuilder {
  const _PredictionFeatureVectorBuilder();

  Map<String, double> buildNamedFeatures({
    required PredictionInputContext context,
    required PredictionProduct candidateProduct,
    required int displayPosition,
  }) {
    return <String, double>{
      ..._buildProductBehaviorFeatures(context, candidateProduct),
      ..._buildCategoryAndBrandInterestFeatures(context, candidateProduct),
      ..._buildSessionTimeAndProfileFeatures(context, displayPosition),
    };
  }

  Map<String, double> _buildProductBehaviorFeatures(PredictionInputContext context, PredictionProduct product) {
    final _UserBehaviorHistory history = context._behaviorHistory;
    const _BehaviorTargetScope productScope = _BehaviorTargetScope.product;
    final double impressions = history.lifetimeEventCount(
      productScope,
      product.productId,
      BehaviorEventType.productImpression,
    );
    final double clicks = history.lifetimeEventCount(productScope, product.productId, BehaviorEventType.productClick);
    final double views = history.lifetimeEventCount(
      productScope,
      product.productId,
      BehaviorEventType.productDetailView,
    );
    final double cartAdds = history.lifetimeEventCount(productScope, product.productId, BehaviorEventType.cartAdd);

    return <String, double>{
      'product_impressions_lifetime': impressions,
      'product_clicks_lifetime': clicks,
      'product_views_lifetime': views,
      'product_reviews_lifetime': history.lifetimeEventCount(
        productScope,
        product.productId,
        BehaviorEventType.productReviewsView,
      ),
      'product_cart_adds_lifetime': cartAdds,
      'product_purchases_lifetime': history.lifetimeEventCount(
        productScope,
        product.productId,
        BehaviorEventType.purchaseSucceeded,
      ),
      'product_clicks_7d': history.eventCountInLastDays(
        productScope,
        product.productId,
        BehaviorEventType.productClick,
        context.predictionTime,
        7,
      ),
      'product_views_7d': history.eventCountInLastDays(
        productScope,
        product.productId,
        BehaviorEventType.productDetailView,
        context.predictionTime,
        7,
      ),
      'product_cart_adds_30d': history.eventCountInLastDays(
        productScope,
        product.productId,
        BehaviorEventType.cartAdd,
        context.predictionTime,
        30,
      ),
      'product_dwell_seconds_lifetime': history.lifetimeProductDwellSeconds(product.productId),
      'product_click_through_rate': clicks / math.max(1, impressions),
      'product_cart_view_rate': cartAdds / math.max(1, views),
      'hours_since_product_interaction': _hoursSinceLastProductInteraction(
        history,
        product.productId,
        context.predictionTime,
      ),
    };
  }

  Map<String, double> _buildCategoryAndBrandInterestFeatures(
    PredictionInputContext context,
    PredictionProduct product,
  ) {
    final _UserBehaviorHistory history = context._behaviorHistory;
    const _BehaviorTargetScope categoryScope = _BehaviorTargetScope.category;
    const _BehaviorTargetScope brandScope = _BehaviorTargetScope.brand;
    return <String, double>{
      'category_impressions_lifetime': history.lifetimeEventCount(
        categoryScope,
        product.categoryId,
        BehaviorEventType.productImpression,
      ),
      'category_clicks_lifetime': history.lifetimeEventCount(
        categoryScope,
        product.categoryId,
        BehaviorEventType.productClick,
      ),
      'category_views_lifetime': history.lifetimeEventCount(
        categoryScope,
        product.categoryId,
        BehaviorEventType.productDetailView,
      ),
      'category_cart_adds_lifetime': history.lifetimeEventCount(
        categoryScope,
        product.categoryId,
        BehaviorEventType.cartAdd,
      ),
      'category_purchases_lifetime': history.lifetimeEventCount(
        categoryScope,
        product.categoryId,
        BehaviorEventType.purchaseSucceeded,
      ),
      'category_clicks_7d': history.eventCountInLastDays(
        categoryScope,
        product.categoryId,
        BehaviorEventType.productClick,
        context.predictionTime,
        7,
      ),
      'category_affinity_lifetime': history.lifetimeInterestScore(categoryScope, product.categoryId),
      'category_affinity_30d': history.interestScoreInLastDays(
        categoryScope,
        product.categoryId,
        context.predictionTime,
        30,
      ),
      'brand_affinity_lifetime': history.lifetimeInterestScore(brandScope, product.brandId),
      'brand_affinity_30d': history.interestScoreInLastDays(brandScope, product.brandId, context.predictionTime, 30),
    };
  }

  Map<String, double> _buildSessionTimeAndProfileFeatures(PredictionInputContext context, int displayPosition) {
    final double hourAngle = 2 * math.pi * context.predictionTime.hour / 24;
    return <String, double>{
      'session_event_count': context._behaviorHistory.eventCountForSession(context.currentSessionId),
      'user_event_count_lifetime': context._behaviorHistory.totalEventCount.toDouble(),
      'display_position': displayPosition.toDouble(),
      'hour_sin': math.sin(hourAngle),
      'hour_cos': math.cos(hourAngle),
      'user_age': context._userAgeFeature,
      'user_age_known': context._userAgeKnownFeature,
      'gender_male': context._genderMaleFeature,
      'gender_female': context._genderFemaleFeature,
    };
  }

  double _hoursSinceLastProductInteraction(_UserBehaviorHistory history, String productId, DateTime predictionTime) {
    final DateTime? lastInteractionAt = history.lastProductInteractionAt(productId);
    if (lastInteractionAt == null) return 24 * 365;
    final double elapsedHours = predictionTime.difference(lastInteractionAt).inSeconds / 3600;
    return math.min(24 * 365, math.max(0, elapsedHours)).toDouble();
  }
}
