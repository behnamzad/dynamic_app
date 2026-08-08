import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';

/// قرارداد payloadهای مرحله جمع‌آوری داده؛ این کلاس ورودی یا خروجی inference مدل آینده نیست.
abstract interface class BehaviorEventPayload {
  Map<String, dynamic> toJson();
}

/// برای eventهایی که اطلاعات اختصاصی ندارند و فقط پوشش عمومی آن‌ها کافی است.
class EmptyBehaviorPayload implements BehaviorEventPayload {
  const EmptyBehaviorPayload();

  @override
  Map<String, dynamic> toJson() => const {};
}

/// داده اختصاصی ذخیره‌شده را از SQLite بازسازی می‌کند و برای فراداده توسعه‌پذیر نیز قابل استفاده است.
class MapBehaviorPayload implements BehaviorEventPayload {
  const MapBehaviorPayload(this.values);

  final Map<String, dynamic> values;

  @override
  Map<String, dynamic> toJson() => Map.unmodifiable(values);
}

/// جزئیات مسیر، tab و scroll؛ observerهای navigation و صفحات از آن استفاده خواهند کرد.
class NavigationBehaviorPayload implements BehaviorEventPayload {
  const NavigationBehaviorPayload({
    this.routeName,
    this.previousRouteName,
    this.tabId,
    this.scrollDepthPercent,
    this.listPosition,
    this.visibleItemIds = const [],
  });

  final String? routeName;
  final String? previousRouteName;
  final String? tabId;
  final double? scrollDepthPercent;
  final int? listPosition;
  final List<String> visibleItemIds;

  @override
  Map<String, dynamic> toJson() => {
    if (routeName != null) 'route_name': routeName,
    if (previousRouteName != null) 'previous_route_name': previousRouteName,
    if (tabId != null) 'tab_id': tabId,
    if (scrollDepthPercent != null) 'scroll_depth_percent': scrollDepthPercent,
    if (listPosition != null) 'list_position': listPosition,
    if (visibleItemIds.isNotEmpty) 'visible_item_ids': visibleItemIds,
  };
}

/// جزئیات تعامل با محصول، تصویر، توضیح و نظر؛ صفحات محصول و لیست‌ها مصرف‌کننده آن هستند.
class ProductBehaviorPayload implements BehaviorEventPayload {
  const ProductBehaviorPayload({
    this.displaySource,
    this.displayRank,
    this.displaySlot,
    this.impressionId,
    this.imageIndex,
    this.imageCount,
    this.distinctImagesViewed,
    this.swipeDirection,
    this.scrollDepthPercent,
    this.contentType,
    this.reviewCount,
    this.entryTrigger,
    this.quantityBefore,
    this.quantityAfter,
    this.variantId,
    this.variantName,
  });

  final String? displaySource;
  final int? displayRank;
  final String? displaySlot;
  final String? impressionId;
  final int? imageIndex;
  final int? imageCount;
  final int? distinctImagesViewed;
  final String? swipeDirection;
  final double? scrollDepthPercent;
  final String? contentType;
  final int? reviewCount;
  final String? entryTrigger;
  final int? quantityBefore;
  final int? quantityAfter;
  final String? variantId;
  final String? variantName;

  @override
  Map<String, dynamic> toJson() => {
    if (displaySource != null) 'display_source': displaySource,
    if (displayRank != null) 'display_rank': displayRank,
    if (displaySlot != null) 'display_slot': displaySlot,
    if (impressionId != null) 'impression_id': impressionId,
    if (imageIndex != null) 'image_index': imageIndex,
    if (imageCount != null) 'image_count': imageCount,
    if (distinctImagesViewed != null) 'distinct_images_viewed': distinctImagesViewed,
    if (swipeDirection != null) 'swipe_direction': swipeDirection,
    if (scrollDepthPercent != null) 'scroll_depth_percent': scrollDepthPercent,
    if (contentType != null) 'content_type': contentType,
    if (reviewCount != null) 'review_count': reviewCount,
    if (entryTrigger != null) 'entry_trigger': entryTrigger,
    if (quantityBefore != null) 'quantity_before': quantityBefore,
    if (quantityAfter != null) 'quantity_after': quantityAfter,
    if (variantId != null) 'variant_id': variantId,
    if (variantName != null) 'variant_name': variantName,
  };
}

/// جزئیات نمایش دسته/برند و filter/sort؛ صفحات home، search و product-list آن را مصرف می‌کنند.
class CategoryBrandBehaviorPayload implements BehaviorEventPayload {
  const CategoryBrandBehaviorPayload({
    this.displaySource,
    this.displayRank,
    this.displaySlot,
    this.filterName,
    this.filterValues = const [],
    this.sortMode,
    this.transitionFromId,
    this.transitionToId,
    this.visibleProductIds = const [],
  });

  final String? displaySource;
  final int? displayRank;
  final String? displaySlot;
  final String? filterName;
  final List<String> filterValues;
  final String? sortMode;
  final String? transitionFromId;
  final String? transitionToId;
  final List<String> visibleProductIds;

  @override
  Map<String, dynamic> toJson() => {
    if (displaySource != null) 'display_source': displaySource,
    if (displayRank != null) 'display_rank': displayRank,
    if (displaySlot != null) 'display_slot': displaySlot,
    if (filterName != null) 'filter_name': filterName,
    if (filterValues.isNotEmpty) 'filter_values': filterValues,
    if (sortMode != null) 'sort_mode': sortMode,
    if (transitionFromId != null) 'transition_from_id': transitionFromId,
    if (transitionToId != null) 'transition_to_id': transitionToId,
    if (visibleProductIds.isNotEmpty) 'visible_product_ids': visibleProductIds,
  };
}

/// عبارت جست‌وجو، نتایج و انتخاب کاربر؛ بخش جست‌وجو آن را ثبت می‌کند.
class SearchBehaviorPayload implements BehaviorEventPayload {
  const SearchBehaviorPayload({
    required this.query,
    this.normalizedQuery,
    this.resultCount,
    this.resultProductIds = const [],
    this.resultSnapshots = const [],
    this.selectedProductId,
    this.selectedResultRank,
    this.previousQuery,
    this.filters = const {},
    this.sortMode,
    this.elapsedToActionMs,
  });

  final String query;
  final String? normalizedQuery;
  final int? resultCount;
  final List<String> resultProductIds;
  final List<BehaviorProductSnapshot> resultSnapshots;
  final String? selectedProductId;
  final int? selectedResultRank;
  final String? previousQuery;
  final Map<String, dynamic> filters;
  final String? sortMode;
  final int? elapsedToActionMs;

  @override
  Map<String, dynamic> toJson() => {
    'query': query,
    if (normalizedQuery != null) 'normalized_query': normalizedQuery,
    if (resultCount != null) 'result_count': resultCount,
    if (resultProductIds.isNotEmpty) 'result_product_ids': resultProductIds,
    if (resultSnapshots.isNotEmpty)
      'result_snapshots': resultSnapshots
          .map((BehaviorProductSnapshot snapshot) => snapshot.toJson())
          .toList(growable: false),
    if (selectedProductId != null) 'selected_product_id': selectedProductId,
    if (selectedResultRank != null) 'selected_result_rank': selectedResultRank,
    if (previousQuery != null) 'previous_query': previousQuery,
    if (filters.isNotEmpty) 'filters': filters,
    if (sortMode != null) 'sort_mode': sortMode,
    if (elapsedToActionMs != null) 'elapsed_to_action_ms': elapsedToActionMs,
  };
}

/// تغییرات سبد و محصولات آن؛ cart برای ساخت سیگنال intent و conversion از آن استفاده می‌کند.
class CartBehaviorPayload implements BehaviorEventPayload {
  const CartBehaviorPayload({
    this.quantityBefore,
    this.quantityAfter,
    this.cartProductIds = const [],
    this.cartProductSnapshots = const [],
    this.cartProductCount,
    this.elapsedFromFirstViewMs,
    this.recommendationRequestId,
  });

  final int? quantityBefore;
  final int? quantityAfter;
  final List<String> cartProductIds;
  final List<BehaviorProductSnapshot> cartProductSnapshots;
  final int? cartProductCount;
  final int? elapsedFromFirstViewMs;
  final String? recommendationRequestId;

  @override
  Map<String, dynamic> toJson() => {
    if (quantityBefore != null) 'quantity_before': quantityBefore,
    if (quantityAfter != null) 'quantity_after': quantityAfter,
    if (cartProductIds.isNotEmpty) 'cart_product_ids': cartProductIds,
    if (cartProductSnapshots.isNotEmpty)
      'cart_product_snapshots': cartProductSnapshots
          .map((BehaviorProductSnapshot snapshot) => snapshot.toJson())
          .toList(growable: false),
    if (cartProductCount != null) 'cart_product_count': cartProductCount,
    if (elapsedFromFirstViewMs != null) 'elapsed_from_first_view_ms': elapsedFromFirstViewMs,
    if (recommendationRequestId != null) 'recommendation_request_id': recommendationRequestId,
  };
}

/// مراحل checkout و نتیجه خرید؛ checkout ثبت و Python برچسب خرید را از آن می‌سازد.
class CheckoutBehaviorPayload implements BehaviorEventPayload {
  const CheckoutBehaviorPayload({
    this.stepName,
    this.stepIndex,
    this.outcome,
    this.failureCode,
    this.productIds = const [],
    this.productSnapshots = const [],
    this.quantities = const {},
    this.elapsedFromCartAddMs,
  });

  final String? stepName;
  final int? stepIndex;
  final String? outcome;
  final String? failureCode;
  final List<String> productIds;
  final List<BehaviorProductSnapshot> productSnapshots;
  final Map<String, int> quantities;
  final int? elapsedFromCartAddMs;

  @override
  Map<String, dynamic> toJson() => {
    if (stepName != null) 'step_name': stepName,
    if (stepIndex != null) 'step_index': stepIndex,
    if (outcome != null) 'outcome': outcome,
    if (failureCode != null) 'failure_code': failureCode,
    if (productIds.isNotEmpty) 'product_ids': productIds,
    if (productSnapshots.isNotEmpty)
      'product_snapshots': productSnapshots
          .map((BehaviorProductSnapshot snapshot) => snapshot.toJson())
          .toList(growable: false),
    if (quantities.isNotEmpty) 'quantities': quantities,
    if (elapsedFromCartAddMs != null) 'elapsed_from_cart_add_ms': elapsedFromCartAddMs,
  };
}

/// نمایش و واکنش به پیشنهاد مدل؛ UI ثبت می‌کند تا مدل بعداً ارزیابی و بازآموزی شود.
class RecommendationBehaviorPayload implements BehaviorEventPayload {
  const RecommendationBehaviorPayload({
    required this.requestId,
    this.candidateProductIds = const [],
    this.candidateSnapshots = const [],
    this.displayedProductIds = const [],
    this.displayedSnapshots = const [],
    this.selectedProductId,
    this.displayRank,
    this.displaySlot,
    this.strategy,
    this.modelVersion,
    this.nextAction,
    this.confidence,
  });

  final String requestId;
  final List<String> candidateProductIds;
  final List<BehaviorProductSnapshot> candidateSnapshots;
  final List<String> displayedProductIds;
  final List<BehaviorProductSnapshot> displayedSnapshots;
  final String? selectedProductId;
  final int? displayRank;
  final String? displaySlot;
  final String? strategy;
  final String? modelVersion;
  final String? nextAction;
  final double? confidence;

  @override
  Map<String, dynamic> toJson() => {
    'request_id': requestId,
    if (candidateProductIds.isNotEmpty) 'candidate_product_ids': candidateProductIds,
    if (candidateSnapshots.isNotEmpty)
      'candidate_snapshots': candidateSnapshots
          .map((BehaviorProductSnapshot snapshot) => snapshot.toJson())
          .toList(growable: false),
    if (displayedProductIds.isNotEmpty) 'displayed_product_ids': displayedProductIds,
    if (displayedSnapshots.isNotEmpty)
      'displayed_snapshots': displayedSnapshots
          .map((BehaviorProductSnapshot snapshot) => snapshot.toJson())
          .toList(growable: false),
    if (selectedProductId != null) 'selected_product_id': selectedProductId,
    if (displayRank != null) 'display_rank': displayRank,
    if (displaySlot != null) 'display_slot': displaySlot,
    if (strategy != null) 'strategy': strategy,
    if (modelVersion != null) 'model_version': modelVersion,
    if (nextAction != null) 'next_action': nextAction,
    if (confidence != null) 'confidence': confidence,
  };
}

/// بازخورد صریح مانند rating و favorite؛ محصول ثبت و مدل آن را سیگنال علاقه تلقی می‌کند.
class FeedbackBehaviorPayload implements BehaviorEventPayload {
  const FeedbackBehaviorPayload({
    required this.targetType,
    required this.targetId,
    this.rating,
    this.value,
    this.isBuyer,
  });

  final String targetType;
  final String targetId;
  final double? rating;
  final String? value;
  final bool? isBuyer;

  @override
  Map<String, dynamic> toJson() => {
    'target_type': targetType,
    'target_id': targetId,
    if (rating != null) 'rating': rating,
    if (value != null) 'value': value,
    if (isBuyer != null) 'is_buyer': isBuyer,
  };
}

/// آمار lifecycle و session؛ app lifecycle برای تحلیل نشست‌ها از آن استفاده می‌کند.
class LifecycleBehaviorPayload implements BehaviorEventPayload {
  const LifecycleBehaviorPayload({this.reason, this.sessionEventCount, this.sessionDurationMs});

  final String? reason;
  final int? sessionEventCount;
  final int? sessionDurationMs;

  @override
  Map<String, dynamic> toJson() => {
    if (reason != null) 'reason': reason,
    if (sessionEventCount != null) 'session_event_count': sessionEventCount,
    if (sessionDurationMs != null) 'session_duration_ms': sessionDurationMs,
  };
}
