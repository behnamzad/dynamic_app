import 'dart:math' as math;

import 'package:dynamic_app/shared/prediction/domain/entities/personalization_thresholds.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

/// شکل کوچک محصول که برای ساخت ورودی مدل کافی است.
class PredictionProduct {
  const PredictionProduct({
    required this.productId,
    required this.categoryId,
    required this.brandId,
    this.globalProductClickRate = 0.10,
    this.globalProductPurchaseRate = 0.01,
    this.globalCategoryPurchaseRate = 0.01,
  });

  final String productId;
  final String categoryId;
  final String brandId;
  final double globalProductClickRate;
  final double globalProductPurchaseRate;
  final double globalCategoryPurchaseRate;

  factory PredictionProduct.fromEntity(ProductEntity product, {PredictionProduct? behavioralPrior}) {
    return PredictionProduct(
      productId: product.id.toString(),
      categoryId: product.categoryId.toString(),
      brandId: product.brand.id.toString(),
      globalProductClickRate: behavioralPrior?.globalProductClickRate ?? 0.10,
      globalProductPurchaseRate: behavioralPrior?.globalProductPurchaseRate ?? 0.01,
      globalCategoryPurchaseRate: behavioralPrior?.globalCategoryPurchaseRate ?? 0.01,
    );
  }

  factory PredictionProduct.fromJson(Map<String, dynamic> json) {
    return PredictionProduct(
      productId: json['product_id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? 'unknown-category',
      brandId: json['brand_id']?.toString() ?? 'unknown-brand',
      globalProductClickRate: (json['global_product_click_rate'] as num?)?.toDouble() ?? 0.10,
      globalProductPurchaseRate: (json['global_product_purchase_rate'] as num?)?.toDouble() ?? 0.01,
      globalCategoryPurchaseRate: (json['global_category_purchase_rate'] as num?)?.toDouble() ?? 0.01,
    );
  }
}

class RelatedProductCandidate {
  const RelatedProductCandidate({required this.productId, required this.score});

  final String productId;
  final double score;

  factory RelatedProductCandidate.fromJson(Map<String, dynamic> json) {
    return RelatedProductCandidate(
      productId: json['product_id']?.toString() ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// JSONهای کنار مدل را یک‌بار می‌خوانیم و اینجا نگه می‌داریم.
class PredictionArtifacts {
  const PredictionArtifacts({
    required this.featureNames,
    required this.featureTransforms,
    required this.eventWeights,
    required this.mean,
    required this.scale,
    required this.calibrationCoefficient,
    required this.calibrationIntercept,
    required this.decisionThreshold,
    required this.modelVersion,
    required this.inputSchemaVersion,
    required this.personalizationThresholds,
    required this.catalog,
    required this.relatedProducts,
  });

  final List<String> featureNames;
  final Map<String, String> featureTransforms;
  final Map<String, double> eventWeights;
  final List<double> mean;
  final List<double> scale;
  final double calibrationCoefficient;
  final double calibrationIntercept;
  final double decisionThreshold;
  final String modelVersion;
  final String inputSchemaVersion;
  final PersonalizationThresholds personalizationThresholds;
  final Map<String, PredictionProduct> catalog;
  final Map<String, List<RelatedProductCandidate>> relatedProducts;

  List<double> normalize(List<double> values) {
    if (values.length != featureNames.length ||
        mean.length != featureNames.length ||
        scale.length != featureNames.length) {
      throw StateError('Model input files do not match the feature count');
    }
    return List<double>.generate(values.length, (int index) {
      final double transformedValue = _transformFeature(featureNames[index], values[index]);
      final double divisor = scale[index] == 0 ? 1 : scale[index];
      return (transformedValue - mean[index]) / divisor;
    }, growable: false);
  }

  double _transformFeature(String featureName, double value) {
    return switch (featureTransforms[featureName]) {
      null => value,
      'log1p' => math.log(1 + math.max(0, value)),
      'signed_log1p' => (value.isNegative ? -1.0 : 1.0) * math.log(1 + value.abs()),
      final String transform => throw StateError('Unknown model feature transform: $transform'),
    };
  }

  /// Python همین logistic calibration را بعد از خروجی خام TFLite اجرا می‌کند.
  double calibrate(double rawProbability) {
    final double value = calibrationCoefficient * rawProbability + calibrationIntercept;
    return 1 / (1 + math.exp(-value));
  }
}
