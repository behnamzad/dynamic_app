import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';

/// مشخص می‌کند هر event برای معتبر بودن به شناسه و snapshot کدام موضوع نیاز دارد.
enum BehaviorSubjectRequirement { none, product, category, brand }

/// تعریف مستند هر event؛ catalog و اعتبارسنج برای توضیح کاربرد مدل از آن استفاده می‌کنند.
class BehaviorEventDefinition {
  const BehaviorEventDefinition({
    required this.type,
    required this.family,
    required this.description,
    required this.modelUses,
    this.subjectRequirement = BehaviorSubjectRequirement.none,
  });

  final BehaviorEventType type;
  final String family;
  final String description;
  final List<String> modelUses;
  final BehaviorSubjectRequirement subjectRequirement;
}

/// مرجع مرکزی eventها؛ logger قبل از ذخیره draft را با قوانین داده و حریم خصوصی آن بررسی می‌کند.
class BehaviorEventCatalog {
  const BehaviorEventCatalog._();

  static final Map<BehaviorEventType, BehaviorEventDefinition> definitions = {
    for (final BehaviorEventType type in BehaviorEventType.values) type: _definitionFor(type),
  };

  /// شناسه‌ها، snapshot، مقادیر منفی و کلیدهای ممنوع payload را قبل از SQLite کنترل می‌کند.
  static void validateDraft(BehaviorEventDraft draft) {
    final BehaviorEventDefinition definition = definitions[draft.type]!;
    final BehaviorProductSnapshot subject = draft.product;
    switch (definition.subjectRequirement) {
      case BehaviorSubjectRequirement.none:
        break;
      case BehaviorSubjectRequirement.product:
        _require(subject.productId, 'product_id', draft.type);
        _require(subject.productName, 'product_name', draft.type);
        _require(subject.categoryId, 'category_id', draft.type);
        _require(subject.categoryName, 'category_name', draft.type);
        _require(subject.brandId, 'brand_id', draft.type);
        _require(subject.brandName, 'brand_name', draft.type);
        break;
      case BehaviorSubjectRequirement.category:
        _require(subject.categoryId, 'category_id', draft.type);
        _require(subject.categoryName, 'category_name', draft.type);
        break;
      case BehaviorSubjectRequirement.brand:
        _require(subject.brandId, 'brand_id', draft.type);
        _require(subject.brandName, 'brand_name', draft.type);
        break;
    }

    if (draft.durationMs != null && draft.durationMs! < 0) {
      throw ArgumentError.value(draft.durationMs, 'durationMs', 'Duration cannot be negative');
    }
    if (draft.position != null && draft.position! < 0) {
      throw ArgumentError.value(draft.position, 'position', 'Position cannot be negative');
    }

    _validatePayloadKeys(draft.payload.toJson());
  }

  static void _require(String? value, String field, BehaviorEventType type) {
    if (value == null || value.trim().isEmpty) {
      throw ArgumentError('$field is required for ${type.wireName}');
    }
  }

  static void _validatePayloadKeys(dynamic value) {
    if (value is Map) {
      for (final MapEntry<dynamic, dynamic> entry in value.entries) {
        final String key = entry.key.toString().toLowerCase();
        if (_forbiddenKeys.contains(key)) {
          throw ArgumentError('Behavior telemetry must not contain forbidden field: $key');
        }
        _validatePayloadKeys(entry.value);
      }
    } else if (value is Iterable) {
      for (final dynamic item in value) {
        _validatePayloadKeys(item);
      }
    }
  }

  static const _forbiddenKeys = {
    'price',
    'original_price',
    'final_price',
    'discount',
    'discount_percent',
    'stock',
    'availability',
    'available',
    'remained_count',
    'cart_value',
    'cart_total',
    'password',
    'access_token',
    'refresh_token',
    'payment_secret',
    'card_number',
    'cvv',
    'review_text',
    'comment_text',
  };

  static BehaviorEventDefinition _definitionFor(BehaviorEventType type) {
    if (_productEvents.contains(type)) {
      return BehaviorEventDefinition(
        type: type,
        family: 'product',
        description: _productDescription(type),
        modelUses: const ['user-product features', 'interest ranking', 'purchase probability'],
        subjectRequirement: BehaviorSubjectRequirement.product,
      );
    }
    if (_categoryEvents.contains(type)) {
      return BehaviorEventDefinition(
        type: type,
        family: 'category',
        description: 'Category exposure or engagement.',
        modelUses: const ['category affinity', 'category ranking'],
        subjectRequirement: BehaviorSubjectRequirement.category,
      );
    }
    if (_brandEvents.contains(type)) {
      return BehaviorEventDefinition(
        type: type,
        family: 'brand',
        description: 'Brand exposure or engagement.',
        modelUses: const ['brand affinity', 'candidate ranking'],
        subjectRequirement: BehaviorSubjectRequirement.brand,
      );
    }
    if (_searchEvents.contains(type)) {
      return BehaviorEventDefinition(
        type: type,
        family: 'search',
        description: 'Search intent, exposure, refinement, or selection.',
        modelUses: const ['intent features', 'category/product affinity', 'conversion attribution'],
        subjectRequirement: type == BehaviorEventType.searchResultClick
            ? BehaviorSubjectRequirement.product
            : BehaviorSubjectRequirement.none,
      );
    }
    if (_cartPurchaseEvents.contains(type)) {
      return BehaviorEventDefinition(
        type: type,
        family: 'conversion',
        description: 'Cart, checkout, payment, purchase, or abandonment outcome.',
        modelUses: const ['purchase labels', 'cart propensity', 'conversion history'],
        subjectRequirement: _singleProductCartEvents.contains(type)
            ? BehaviorSubjectRequirement.product
            : BehaviorSubjectRequirement.none,
      );
    }
    if (_recommendationEvents.contains(type)) {
      return BehaviorEventDefinition(
        type: type,
        family: 'recommendation',
        description: 'Recommendation request, exposure, action, or attributed outcome.',
        modelUses: const ['recommendation negatives', 'ranking evaluation', 'attribution'],
        subjectRequirement: _recommendationProductEvents.contains(type)
            ? BehaviorSubjectRequirement.product
            : BehaviorSubjectRequirement.none,
      );
    }
    if (_feedbackEvents.contains(type)) {
      return BehaviorEventDefinition(
        type: type,
        family: 'feedback',
        description: 'Explicit user feedback without free-text telemetry.',
        modelUses: const ['explicit interest', 'ranking targets'],
      );
    }
    return BehaviorEventDefinition(
      type: type,
      family: 'navigation_lifecycle',
      description: 'Session, lifecycle, navigation, or UI exposure context.',
      modelUses: const ['session features', 'sequence features', 'dwell and abandonment'],
    );
  }

  static String _productDescription(BehaviorEventType type) {
    if (type == BehaviorEventType.productReviewsView) {
      return 'The user deliberately opened the reviews area for the product; review text is never collected.';
    }
    return 'Product exposure or engagement with an interaction-time product/category/brand snapshot.';
  }

  static const _productEvents = {
    BehaviorEventType.productImpression,
    BehaviorEventType.productClick,
    BehaviorEventType.productDetailView,
    BehaviorEventType.productViewEnd,
    BehaviorEventType.productRevisit,
    BehaviorEventType.productDescriptionView,
    BehaviorEventType.productReviewsView,
    BehaviorEventType.productGalleryOpen,
    BehaviorEventType.productImageView,
    BehaviorEventType.productImageSwipe,
    BehaviorEventType.productScrollDepth,
    BehaviorEventType.productVariantSelected,
    BehaviorEventType.productQuantityChanged,
    BehaviorEventType.productShared,
  };
  static const _categoryEvents = {
    BehaviorEventType.categoryImpression,
    BehaviorEventType.categoryClick,
    BehaviorEventType.categoryView,
    BehaviorEventType.categoryViewEnd,
  };
  static const _brandEvents = {
    BehaviorEventType.brandImpression,
    BehaviorEventType.brandClick,
    BehaviorEventType.brandView,
    BehaviorEventType.brandViewEnd,
  };
  static const _searchEvents = {
    BehaviorEventType.searchSubmitted,
    BehaviorEventType.searchResultsImpression,
    BehaviorEventType.searchResultClick,
    BehaviorEventType.searchRefined,
    BehaviorEventType.searchNoResults,
  };
  static const _cartPurchaseEvents = {
    BehaviorEventType.cartAdd,
    BehaviorEventType.cartRemove,
    BehaviorEventType.cartQuantityChanged,
    BehaviorEventType.cartAbandoned,
    BehaviorEventType.checkoutStarted,
    BehaviorEventType.checkoutStepViewed,
    BehaviorEventType.checkoutStepCompleted,
    BehaviorEventType.paymentAttempted,
    BehaviorEventType.purchaseSucceeded,
    BehaviorEventType.purchaseFailed,
  };
  static const _singleProductCartEvents = {
    BehaviorEventType.cartAdd,
    BehaviorEventType.cartRemove,
    BehaviorEventType.cartQuantityChanged,
  };
  static const _recommendationEvents = {
    BehaviorEventType.recommendationRequested,
    BehaviorEventType.recommendationImpression,
    BehaviorEventType.recommendationClick,
    BehaviorEventType.recommendationDismissed,
    BehaviorEventType.recommendationCartAdd,
    BehaviorEventType.recommendationPurchase,
  };
  static const _recommendationProductEvents = {
    BehaviorEventType.recommendationClick,
    BehaviorEventType.recommendationDismissed,
    BehaviorEventType.recommendationCartAdd,
    BehaviorEventType.recommendationPurchase,
  };
  static const _feedbackEvents = {
    BehaviorEventType.ratingSubmitted,
    BehaviorEventType.liked,
    BehaviorEventType.disliked,
    BehaviorEventType.favoriteAdded,
    BehaviorEventType.favoriteRemoved,
    BehaviorEventType.reviewSubmitted,
  };
}
