part of 'prediction_input_builder.dart';

/// اطلاعات مشترکی که موقع امتیازدهی چند محصول دوباره استفاده می‌شود.
class PredictionInputContext {
  const PredictionInputContext._({
    required _UserBehaviorHistory behaviorHistory,
    required this.currentSessionId,
    required this.predictionTime,
    required double userAgeFeature,
    required double userAgeKnownFeature,
    required double genderMaleFeature,
    required double genderFemaleFeature,
  }) : _behaviorHistory = behaviorHistory,
       _userAgeFeature = userAgeFeature,
       _userAgeKnownFeature = userAgeKnownFeature,
       _genderMaleFeature = genderMaleFeature,
       _genderFemaleFeature = genderFemaleFeature;

  final _UserBehaviorHistory _behaviorHistory;
  final double _userAgeFeature;
  final double _userAgeKnownFeature;
  final double _genderMaleFeature;
  final double _genderFemaleFeature;
  final String currentSessionId;
  final DateTime predictionTime;
}
