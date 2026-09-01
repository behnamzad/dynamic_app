import 'dart:math' as math;

import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

/// شکل کوچک محصول که برای ساخت ورودی مدل کافی است.
class PredictionProduct {
  const PredictionProduct({
    required this.productId,
    required this.categoryId,
    required this.brandId,
  });

  final String productId;
  final String categoryId;
  final String brandId;

  factory PredictionProduct.fromEntity(ProductEntity product) {
    return PredictionProduct(
      productId: product.id.toString(),
      categoryId: product.categoryId.toString(),
      brandId: product.brand.id.toString(),
    );
  }

  factory PredictionProduct.fromJson(Map<String, dynamic> json) {
    return PredictionProduct(
      productId: json['product_id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? 'unknown-category',
      brandId: json['brand_id']?.toString() ?? 'unknown-brand',
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
    required this.eventWeights,
    required this.mean,
    required this.scale,
    required this.calibrationCoefficient,
    required this.calibrationIntercept,
    required this.decisionThreshold,
    required this.modelVersion,
    required this.inputSchemaVersion,
    required this.catalog,
    required this.relatedProducts,
  });

  final List<String> featureNames;
  final Map<String, double> eventWeights;
  final List<double> mean;
  final List<double> scale;
  final double calibrationCoefficient;
  final double calibrationIntercept;
  final double decisionThreshold;
  final String modelVersion;
  final String inputSchemaVersion;
  final Map<String, PredictionProduct> catalog;
  final Map<String, List<RelatedProductCandidate>> relatedProducts;

  List<double> normalize(List<double> values) {
    if (values.length != featureNames.length ||
        mean.length != featureNames.length ||
        scale.length != featureNames.length) {
      throw StateError('Model input files do not match the feature count');
    }
    return List<double>.generate(values.length, (int index) {
      final double divisor = scale[index] == 0 ? 1 : scale[index];
      return (values[index] - mean[index]) / divisor;
    }, growable: false);
  }

  /// Python همین logistic calibration را بعد از خروجی خام TFLite اجرا می‌کند.
  double calibrate(double rawProbability) {
    final double value =
        calibrationCoefficient * rawProbability + calibrationIntercept;
    return 1 / (1 + math.exp(-value));
  }
}
