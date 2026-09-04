import 'package:dynamic_app/shared/personalization/domain/entities/personalization_action.dart';

/// تصمیم آماده‌ای که UI اجرا و ثبت می‌کند.
class PersonalizationDecision {
  const PersonalizationDecision({
    required this.decisionId,
    required this.action,
    required this.purchaseProbability,
    required this.modelVersion,
  });

  final String decisionId;
  final PersonalizationAction action;
  final double purchaseProbability;
  final String modelVersion;

  PersonalizationDecision withAction(PersonalizationAction newAction) {
    return PersonalizationDecision(
      decisionId: decisionId,
      action: newAction,
      purchaseProbability: purchaseProbability,
      modelVersion: modelVersion,
    );
  }
}
