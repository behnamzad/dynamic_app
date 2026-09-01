import 'package:dynamic_app/shared/prediction/data/models/prediction_artifacts.dart';

/// تنها کلاس وابسته به فایل‌های asset و کتابخانه TFLite پشت این قرارداد است.
abstract interface class PredictionModelDataSource {
  Future<PredictionArtifacts> loadArtifacts();

  Future<double> run(List<double> normalizedInput);

  void dispose();
}
