import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_session_manager.dart';
import 'package:dynamic_app/shared/behavior/domain/repository/behavior_event_repository.dart';
import 'package:dynamic_app/shared/interest/data/category_interest_builder.dart';
import 'package:dynamic_app/shared/interest/domain/entities/category_interest.dart';
import 'package:dynamic_app/shared/interest/domain/repository/user_interest_repository.dart';
import 'package:dynamic_app/shared/prediction/data/datasource/prediction_model_data_source.dart';
import 'package:dynamic_app/shared/prediction/data/models/prediction_artifacts.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserInterestRepository)
class UserInterestRepositoryImpl implements UserInterestRepository {
  const UserInterestRepositoryImpl(
    this._behaviorRepository,
    this._modelDataSource,
    this._userManager,
    this._sessionManager,
  );

  final BehaviorEventRepository _behaviorRepository;
  final PredictionModelDataSource _modelDataSource;
  final UserManager _userManager;
  final BehaviorSessionManager _sessionManager;
  final CategoryInterestBuilder _builder = const CategoryInterestBuilder();

  @override
  Future<List<CategoryInterest>> getTopCategories({int limit = 5}) async {
    if (limit <= 0) return const <CategoryInterest>[];
    final String userId = _userManager.currentUserId ?? _sessionManager.anonymousId;
    final List<BehaviorEvent> events = await _behaviorRepository.getUserHistory(userId);
    final PredictionArtifacts artifacts = await _modelDataSource.loadArtifacts();
    return _builder.build(
      events: events,
      eventWeights: artifacts.eventWeights,
      now: DateTime.now().toUtc(),
      limit: limit,
    );
  }
}
