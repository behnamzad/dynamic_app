import 'package:dynamic_app/shared/prediction/domain/entities/personalization_thresholds.dart';

/// اطلاعات کوتاه مدل فعال برای نمایش یا ثبت در eventهای پیشنهاد.
class PredictionModelInfo {
  const PredictionModelInfo({
    required this.modelVersion,
    required this.inputSchemaVersion,
    required this.inputCount,
    required this.decisionThreshold,
    required this.personalizationThresholds,
  });

  final String modelVersion;
  final String inputSchemaVersion;
  final int inputCount;
  final double decisionThreshold;
  final PersonalizationThresholds personalizationThresholds;

  /// مدل فعلی فقط همین خروجی را تولید می‌کند.
  List<String> get outputs => const <String>['purchase_probability'];
}
