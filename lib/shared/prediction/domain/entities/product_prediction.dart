/// نتیجه اجرای مدل برای یک محصول.
class ProductPrediction {
  const ProductPrediction({
    required this.productId,
    required this.purchaseProbability,
    required this.decisionThreshold,
    required this.modelVersion,
    this.relatedScore,
  });

  final String productId;
  final double purchaseProbability;
  final double decisionThreshold;
  final String modelVersion;

  /// ارتباط این محصول با محصول مبدأ؛ خروجی مدل نیست.
  final double? relatedScore;

  double get purchasePercent => purchaseProbability * 100;

  bool get isLikelyPurchase => purchaseProbability >= decisionThreshold;
}
