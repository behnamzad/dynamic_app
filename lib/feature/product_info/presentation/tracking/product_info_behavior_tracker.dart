import 'package:dynamic_app/shared/behavior/data/mapper/product_behavior_snapshot_mapper.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalization_action.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalization_decision.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalized_product_suggestion.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:flutter/widgets.dart';

/// وضعیت کوتاه‌مدت ثبت رفتارهای صفحه محصول را بیرون از Widget نگه می‌دارد.
class ProductInfoBehaviorTracker {
  ProductInfoBehaviorTracker({
    required BehaviorLogger behaviorLogger,
    required CartManager cartManager,
    required ProductEntity initialProduct,
    required RecommendationAttribution? incomingRecommendation,
  }) : _behaviorLogger = behaviorLogger,
       _cartManager = cartManager,
       _product = initialProduct,
       _incomingRecommendation = incomingRecommendation;

  static const String _productDetailScreen = 'product_detail';
  static const String _alternativesSlot = 'product_detail_alternatives';

  final BehaviorLogger _behaviorLogger;
  final CartManager _cartManager;
  final RecommendationAttribution? _incomingRecommendation;

  ProductEntity _product;
  DateTime? _pageOpenedAt;
  bool _pageOpenRecorded = false;
  int _lastImageIndex = 0;
  final Set<int> _recordedScrollDepths = <int>{};
  int? _quantityBeforeCartChange;
  bool? _cartChangeIsAdd;
  final Set<String> _recordedDecisionIds = <String>{};
  final Set<String> _recordedRecommendationImpressionIds = <String>{};

  // region Product lifecycle

  void updateProduct(ProductEntity product) {
    _product = product;
  }

  void recordPageOpenedOnce() {
    if (_pageOpenRecorded) return;
    _pageOpenRecorded = true;
    _pageOpenedAt = DateTime.now();
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.product(
        type: BehaviorEventType.productDetailView,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: _productDetailScreen,
        payload: const ProductBehaviorPayload(displaySource: 'product_list'),
      ),
    );
    if (_product.images.isNotEmpty) {
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.product(
          type: BehaviorEventType.productImageView,
          product: _product.toBehaviorSnapshot(),
          sourceScreen: _productDetailScreen,
          payload: ProductBehaviorPayload(
            imageIndex: 0,
            imageCount: _product.images.length,
            distinctImagesViewed: 1,
          ),
        ),
      );
    }
  }

  void recordPageClosed() {
    final DateTime? openedAt = _pageOpenedAt;
    if (!_pageOpenRecorded || openedAt == null) return;
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.product(
        type: BehaviorEventType.productViewEnd,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: _productDetailScreen,
        durationMs: DateTime.now().difference(openedAt).inMilliseconds,
      ),
    );
  }

  // endregion

  // region Product browsing

  void recordImageChanged(int index, int imageCount) {
    if (index == _lastImageIndex) return;
    final String direction = index > _lastImageIndex ? 'next' : 'previous';
    _lastImageIndex = index;
    final ProductBehaviorPayload payload = ProductBehaviorPayload(
      imageIndex: index,
      imageCount: imageCount,
      swipeDirection: direction,
    );
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.product(
        type: BehaviorEventType.productImageSwipe,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: _productDetailScreen,
        payload: payload,
      ),
    );
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.product(
        type: BehaviorEventType.productImageView,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: _productDetailScreen,
        payload: payload,
      ),
    );
  }

  bool recordScrollDepth(ScrollNotification notification) {
    if (!_pageOpenRecorded || notification.metrics.axis != Axis.vertical) {
      return false;
    }
    final double maxExtent = notification.metrics.maxScrollExtent;
    if (maxExtent <= 0) return false;

    final double contentExtent = maxExtent + notification.metrics.viewportDimension;
    final double visibleBottom =
        notification.metrics.pixels.clamp(0.0, maxExtent) + notification.metrics.viewportDimension;
    final double depthPercent = (visibleBottom / contentExtent) * 100;
    for (final int threshold in const <int>[25, 50, 75, 100]) {
      if (depthPercent < threshold || !_recordedScrollDepths.add(threshold)) {
        continue;
      }
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.product(
          type: BehaviorEventType.productScrollDepth,
          product: _product.toBehaviorSnapshot(),
          sourceScreen: _productDetailScreen,
          payload: ProductBehaviorPayload(scrollDepthPercent: threshold.toDouble()),
        ),
      );
    }
    return false;
  }

  // endregion

  // region Cart attribution

  void startCartChange({required int currentQuantity, required bool isAdding}) {
    _quantityBeforeCartChange = currentQuantity;
    _cartChangeIsAdd = isAdding;
  }

  void recordCartChangeResult({required bool succeeded}) {
    final int? quantityBefore = _quantityBeforeCartChange;
    final bool? isAdding = _cartChangeIsAdd;
    if (quantityBefore == null || isAdding == null) return;

    final int quantityAfter = succeeded ? _cartManager.findProduct(_product.id)?.quantity ?? 0 : quantityBefore;
    final BehaviorEventType eventType = isAdding
        ? (quantityBefore == 0 ? BehaviorEventType.cartAdd : BehaviorEventType.cartQuantityChanged)
        : (quantityBefore == 1 ? BehaviorEventType.cartRemove : BehaviorEventType.cartQuantityChanged);
    final RecommendationAttribution? attribution = isAdding && quantityBefore == 0
        ? _incomingRecommendation
        : null;
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.cart(
        type: eventType,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: _productDetailScreen,
        status: succeeded ? 'succeeded' : 'failed',
        payload: CartBehaviorPayload(
          quantityBefore: quantityBefore,
          quantityAfter: quantityAfter,
          cartProductIds: _cartManager.cart.products
              .map((item) => item.productId.toString())
              .toList(growable: false),
          cartProductCount: _cartManager.cart.products.length,
          recommendationRequestId: attribution?.requestId,
        ),
      ),
    );
    if (succeeded && attribution != null) {
      _recordRecommendationCartAdd(attribution);
    }
    _quantityBeforeCartChange = null;
    _cartChangeIsAdd = null;
  }

  void _recordRecommendationCartAdd(RecommendationAttribution attribution) {
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.recommendation(
        type: BehaviorEventType.recommendationCartAdd,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: _productDetailScreen,
        position: attribution.displayRank,
        payload: RecommendationBehaviorPayload(
          requestId: attribution.requestId,
          selectedProductId: _product.id.toString(),
          displayRank: attribution.displayRank,
          displaySlot: attribution.displaySlot,
          strategy: attribution.strategy,
          modelVersion: attribution.modelVersion,
          nextAction: 'cart_add',
          confidence: attribution.confidence,
        ),
      ),
    );
  }

  // endregion

  // region Personalization telemetry

  void recordPersonalization({
    required PersonalizationDecision decision,
    required List<PersonalizedProductSuggestion> suggestions,
    required String? recommendationStrategy,
  }) {
    _recordDecisionOnce(decision, suggestions);
    _recordRecommendationImpressionOnce(
      decision: decision,
      suggestions: suggestions,
      recommendationStrategy: recommendationStrategy,
    );
  }

  void _recordDecisionOnce(
    PersonalizationDecision decision,
    List<PersonalizedProductSuggestion> suggestions,
  ) {
    if (!_recordedDecisionIds.add(decision.decisionId)) return;
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.recommendation(
        type: BehaviorEventType.recommendationRequested,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: _productDetailScreen,
        payload: RecommendationBehaviorPayload(
          requestId: decision.decisionId,
          candidateProductIds: suggestions
              .map((PersonalizedProductSuggestion item) => item.product.id.toString())
              .toList(growable: false),
          candidateSnapshots: suggestions
              .map((PersonalizedProductSuggestion item) => item.product.toBehaviorSnapshot())
              .toList(growable: false),
          selectedProductId: _product.id.toString(),
          modelVersion: decision.modelVersion,
          nextAction: decision.action.wireName,
          confidence: decision.purchaseProbability,
        ),
      ),
    );
  }

  void _recordRecommendationImpressionOnce({
    required PersonalizationDecision decision,
    required List<PersonalizedProductSuggestion> suggestions,
    required String? recommendationStrategy,
  }) {
    if (recommendationStrategy == null ||
        suggestions.isEmpty ||
        !_recordedRecommendationImpressionIds.add(decision.decisionId)) {
      return;
    }
    final List<String> productIds = suggestions
        .map((PersonalizedProductSuggestion item) => item.product.id.toString())
        .toList(growable: false);
    final snapshots = suggestions
        .map((PersonalizedProductSuggestion item) => item.product.toBehaviorSnapshot())
        .toList(growable: false);
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.recommendation(
        type: BehaviorEventType.recommendationImpression,
        sourceScreen: _productDetailScreen,
        payload: RecommendationBehaviorPayload(
          requestId: decision.decisionId,
          candidateProductIds: productIds,
          candidateSnapshots: snapshots,
          displayedProductIds: productIds,
          displayedSnapshots: snapshots,
          displaySlot: _alternativesSlot,
          strategy: recommendationStrategy,
          modelVersion: suggestions.first.prediction.modelVersion,
          nextAction: PersonalizationAction.showAlternativeProducts.wireName,
        ),
      ),
    );
  }

  // endregion
}
