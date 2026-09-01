import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_session_manager.dart';
import 'package:dynamic_app/shared/behavior/domain/repository/behavior_event_repository.dart';
import 'package:dynamic_app/shared/prediction/data/datasource/prediction_model_data_source.dart';
import 'package:dynamic_app/shared/prediction/data/feature_engineering/prediction_input_builder.dart';
import 'package:dynamic_app/shared/prediction/data/models/prediction_artifacts.dart';
import 'package:dynamic_app/shared/prediction/domain/entities/prediction_model_info.dart';
import 'package:dynamic_app/shared/prediction/domain/entities/product_prediction.dart';
import 'package:dynamic_app/shared/prediction/domain/repository/prediction_repository.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PredictionRepository)
class PredictionRepositoryImpl implements PredictionRepository {
  const PredictionRepositoryImpl(
    this._modelDataSource,
    this._inputBuilder,
    this._behaviorRepository,
    this._userManager,
    this._sessionManager,
  );

  final PredictionModelDataSource _modelDataSource;
  final PredictionInputBuilder _inputBuilder;
  final BehaviorEventRepository _behaviorRepository;
  final UserManager _userManager;
  final BehaviorSessionManager _sessionManager;

  @override
  Future<ProductPrediction> predictPurchase(
    ProductEntity product, {
    int displayPosition = 0,
  }) async {
    final PredictionArtifacts artifacts = await _modelDataSource
        .loadArtifacts();
    final PredictionInputContext context = await _buildInputContext(artifacts);
    return _predict(
      product: PredictionProduct.fromEntity(product),
      context: context,
      artifacts: artifacts,
      displayPosition: displayPosition,
    );
  }

  @override
  Future<List<String>> getRelatedProductIds(
    ProductEntity product, {
    int limit = 12,
  }) async {
    if (limit <= 0) return const <String>[];
    final PredictionArtifacts artifacts = await _modelDataSource
        .loadArtifacts();
    final List<RelatedProductCandidate> candidates = _relatedCandidates(
      product,
      artifacts,
    );
    return candidates
        .take(limit)
        .map((RelatedProductCandidate item) => item.productId)
        .toList(growable: false);
  }

  @override
  Future<List<ProductPrediction>> getPersonalizedRelatedProducts(
    ProductEntity product, {
    int limit = 12,
  }) async {
    if (limit <= 0) return const <ProductPrediction>[];
    final PredictionArtifacts artifacts = await _modelDataSource
        .loadArtifacts();
    final PredictionInputContext context = await _buildInputContext(artifacts);
    final List<RelatedProductCandidate> candidates = _relatedCandidates(
      product,
      artifacts,
    );
    final Map<String, ProductEntity> entityCandidates = <String, ProductEntity>{
      for (final ProductEntity item in product.relatedProducts)
        item.id.toString(): item,
    };
    final List<ProductPrediction> predictions = <ProductPrediction>[];
    for (int index = 0; index < candidates.length; index++) {
      final RelatedProductCandidate candidate = candidates[index];
      final PredictionProduct? predictionProduct =
          artifacts.catalog[candidate.productId] ??
          _predictionProduct(entityCandidates[candidate.productId]);
      if (predictionProduct == null) continue;
      predictions.add(
        await _predict(
          product: predictionProduct,
          context: context,
          artifacts: artifacts,
          displayPosition: index,
          relatedScore: candidate.score,
        ),
      );
    }
    predictions.sort(_comparePredictions);
    return List<ProductPrediction>.unmodifiable(predictions.take(limit));
  }

  @override
  Future<List<ProductPrediction>> rankProducts(
    List<ProductEntity> products,
  ) async {
    if (products.isEmpty) return const <ProductPrediction>[];
    final PredictionArtifacts artifacts = await _modelDataSource
        .loadArtifacts();
    final PredictionInputContext context = await _buildInputContext(artifacts);
    final List<ProductPrediction> predictions = <ProductPrediction>[];
    for (int index = 0; index < products.length; index++) {
      predictions.add(
        await _predict(
          product: PredictionProduct.fromEntity(products[index]),
          context: context,
          artifacts: artifacts,
          displayPosition: index,
        ),
      );
    }
    predictions.sort(_comparePredictions);
    return List<ProductPrediction>.unmodifiable(predictions);
  }

  @override
  Future<PredictionModelInfo> getModelInfo() async {
    final PredictionArtifacts artifacts = await _modelDataSource
        .loadArtifacts();
    return PredictionModelInfo(
      modelVersion: artifacts.modelVersion,
      inputSchemaVersion: artifacts.inputSchemaVersion,
      inputCount: artifacts.featureNames.length,
      decisionThreshold: artifacts.decisionThreshold,
    );
  }

  Future<PredictionInputContext> _buildInputContext(
    PredictionArtifacts artifacts,
  ) async {
    final String userId = _currentUserId;
    final List<BehaviorEvent> events = await _behaviorRepository.getUserHistory(
      userId,
    );
    return _inputBuilder.buildContext(
      events: events,
      eventWeightByTypeName: artifacts.eventWeights,
      currentSessionId: _sessionManager.currentSessionId,
      userAge: _userManager.currentAge,
      userGender: _userManager.currentGender,
      predictionTime: DateTime.now().toUtc(),
    );
  }

  String get _currentUserId =>
      _userManager.currentUserId ?? _sessionManager.anonymousId;

  Future<ProductPrediction> _predict({
    required PredictionProduct product,
    required PredictionInputContext context,
    required PredictionArtifacts artifacts,
    required int displayPosition,
    double? relatedScore,
  }) async {
    final List<double> rawFeatureVector = _inputBuilder.buildRawFeatureVector(
      context: context,
      candidateProduct: product,
      orderedFeatureNames: artifacts.featureNames,
      displayPosition: displayPosition,
    );
    final List<double> normalizedInput = artifacts.normalize(rawFeatureVector);
    final double rawProbability = await _modelDataSource.run(normalizedInput);
    final double probability = artifacts
        .calibrate(rawProbability)
        .clamp(0.0, 1.0)
        .toDouble();
    return ProductPrediction(
      productId: product.productId,
      purchaseProbability: probability,
      decisionThreshold: artifacts.decisionThreshold,
      modelVersion: artifacts.modelVersion,
      relatedScore: relatedScore,
    );
  }

  List<RelatedProductCandidate> _relatedCandidates(
    ProductEntity product,
    PredictionArtifacts artifacts,
  ) {
    final List<RelatedProductCandidate>? learned =
        artifacts.relatedProducts[product.id.toString()];
    if (learned != null && learned.isNotEmpty) return learned;
    return product.relatedProducts
        .map(
          (ProductEntity item) =>
              RelatedProductCandidate(productId: item.id.toString(), score: 0),
        )
        .toList(growable: false);
  }

  PredictionProduct? _predictionProduct(ProductEntity? product) {
    return product == null ? null : PredictionProduct.fromEntity(product);
  }

  int _comparePredictions(ProductPrediction left, ProductPrediction right) {
    final int probabilityOrder = right.purchaseProbability.compareTo(
      left.purchaseProbability,
    );
    if (probabilityOrder != 0) return probabilityOrder;
    final int relatedOrder = (right.relatedScore ?? 0).compareTo(
      left.relatedScore ?? 0,
    );
    return relatedOrder != 0
        ? relatedOrder
        : left.productId.compareTo(right.productId);
  }
}
