import 'dart:math' as math;

import 'package:dynamic_app/core/local/user/user.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:dynamic_app/shared/prediction/data/models/prediction_artifacts.dart';
import 'package:injectable/injectable.dart';

part 'prediction_feature_vector_builder.dart';
part 'prediction_input_context.dart';
part 'user_behavior_history.dart';

/// تاریخچه، اطلاعات کاربر و محصول را به آرایه عددی موردنیاز مدل تبدیل می‌کند.
@lazySingleton
class PredictionInputBuilder {
  final _PredictionFeatureVectorBuilder _featureVectorBuilder =
      const _PredictionFeatureVectorBuilder();

  PredictionInputContext buildContext({
    required List<BehaviorEvent> events,
    required Map<String, double> eventWeightByTypeName,
    required String currentSessionId,
    required int? userAge,
    required AppUserGender userGender,
    required DateTime predictionTime,
  }) {
    final int validAge = userAge != null && userAge >= 1 && userAge <= 120
        ? userAge
        : 0;
    return PredictionInputContext._(
      behaviorHistory: _UserBehaviorHistory.fromEvents(
        events: events,
        eventWeightByTypeName: eventWeightByTypeName,
        predictionTime: predictionTime,
      ),
      currentSessionId: currentSessionId,
      predictionTime: predictionTime.toUtc(),
      userAgeFeature: validAge.toDouble(),
      userAgeKnownFeature: validAge > 0 ? 1 : 0,
      genderMaleFeature: userGender == AppUserGender.male ? 1 : 0,
      genderFemaleFeature: userGender == AppUserGender.female ? 1 : 0,
    );
  }

  List<double> buildRawFeatureVector({
    required PredictionInputContext context,
    required PredictionProduct candidateProduct,
    required List<String> orderedFeatureNames,
    int displayPosition = 0,
  }) {
    final Map<String, double> namedFeatureValues = _featureVectorBuilder
        .buildNamedFeatures(
          context: context,
          candidateProduct: candidateProduct,
          displayPosition: displayPosition,
        );
    final List<String> missingFeatureNames = orderedFeatureNames
        .where(
          (String featureName) => !namedFeatureValues.containsKey(featureName),
        )
        .toList(growable: false);
    if (missingFeatureNames.isNotEmpty) {
      throw StateError(
        'Flutter cannot build these model features: ${missingFeatureNames.join(', ')}',
      );
    }
    return orderedFeatureNames
        .map((String featureName) => namedFeatureValues[featureName]!)
        .toList(growable: false);
  }
}
