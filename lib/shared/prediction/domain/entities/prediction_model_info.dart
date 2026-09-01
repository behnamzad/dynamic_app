/// اطلاعات کوتاه مدل فعال برای نمایش یا ثبت در eventهای پیشنهاد.
class PredictionModelInfo {
  const PredictionModelInfo({
    required this.modelVersion,
    required this.inputSchemaVersion,
    required this.inputCount,
    required this.decisionThreshold,
  });

  final String modelVersion;
  final String inputSchemaVersion;
  final int inputCount;
  final double decisionThreshold;

  /// مدل فعلی فقط همین خروجی را تولید می‌کند.
  List<String> get outputs => const <String>['purchase_probability'];
}
