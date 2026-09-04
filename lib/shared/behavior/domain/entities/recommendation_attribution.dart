import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';

/// اطلاعات غیرقیمتی لازم برای وصل‌کردن کلیک پیشنهاد به سبد و خرید.
class RecommendationAttribution {
  const RecommendationAttribution({
    required this.requestId,
    required this.productSnapshot,
    required this.modelVersion,
    required this.strategy,
    required this.confidence,
    required this.displayRank,
    required this.displaySlot,
  });

  final String requestId;
  final BehaviorProductSnapshot productSnapshot;
  final String modelVersion;
  final String strategy;
  final double confidence;
  final int displayRank;
  final String displaySlot;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'request_id': requestId,
    'product_snapshot': productSnapshot.toJson(),
    'model_version': modelVersion,
    'strategy': strategy,
    'confidence': confidence,
    'display_rank': displayRank,
    'display_slot': displaySlot,
  };

  factory RecommendationAttribution.fromJson(Map<String, dynamic> json) {
    return RecommendationAttribution(
      requestId: json['request_id']?.toString() ?? '',
      productSnapshot: BehaviorProductSnapshot.fromJson(
        Map<String, dynamic>.from(json['product_snapshot'] as Map? ?? const <String, dynamic>{}),
      ),
      modelVersion: json['model_version']?.toString() ?? '',
      strategy: json['strategy']?.toString() ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      displayRank: (json['display_rank'] as num?)?.toInt() ?? 0,
      displaySlot: json['display_slot']?.toString() ?? '',
    );
  }

  bool get isValid =>
      requestId.trim().isNotEmpty &&
      productSnapshot.productId?.trim().isNotEmpty == true &&
      productSnapshot.productName?.trim().isNotEmpty == true &&
      productSnapshot.categoryId?.trim().isNotEmpty == true &&
      productSnapshot.categoryName?.trim().isNotEmpty == true &&
      productSnapshot.brandId?.trim().isNotEmpty == true &&
      productSnapshot.brandName?.trim().isNotEmpty == true &&
      modelVersion.trim().isNotEmpty &&
      strategy.trim().isNotEmpty &&
      confidence.isFinite &&
      confidence >= 0 &&
      confidence <= 1 &&
      displayRank >= 0 &&
      displaySlot.trim().isNotEmpty;
}
