import 'package:dynamic_app/shared/prediction/data/models/prediction_artifacts.dart';

/// برای محصول بدون رابطه مشارکتی، محصولات همان دسته را با آمار گذشته مرتب می‌کند.
abstract final class CategoryBehaviorCandidateSelector {
  static List<String> select({
    required Iterable<PredictionProduct> catalog,
    required String productId,
    required String categoryId,
    required int limit,
  }) {
    if (limit <= 0) return const <String>[];
    final List<PredictionProduct> candidates =
        catalog
            .where(
              (PredictionProduct candidate) => candidate.productId != productId && candidate.categoryId == categoryId,
            )
            .toList(growable: false)
          ..sort(_compare);
    return candidates.take(limit).map((PredictionProduct candidate) => candidate.productId).toList(growable: false);
  }

  static int _compare(PredictionProduct left, PredictionProduct right) {
    final int purchaseRateOrder = right.globalProductPurchaseRate.compareTo(left.globalProductPurchaseRate);
    if (purchaseRateOrder != 0) return purchaseRateOrder;
    final int clickRateOrder = right.globalProductClickRate.compareTo(left.globalProductClickRate);
    return clickRateOrder != 0 ? clickRateOrder : left.productId.compareTo(right.productId);
  }
}
