import 'dart:convert';

import 'package:dynamic_app/shared/prediction/data/datasource/prediction_model_data_source.dart';
import 'package:dynamic_app/shared/prediction/data/models/prediction_artifacts.dart';
import 'package:dynamic_app/shared/prediction/domain/entities/personalization_thresholds.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

@LazySingleton(as: PredictionModelDataSource)
class PredictionModelDataSourceImpl implements PredictionModelDataSource {
  static const String _assetRoot = 'assets/ml';

  Interpreter? _interpreter;
  Future<PredictionArtifacts>? _artifactsFuture;

  @override
  Future<PredictionArtifacts> loadArtifacts() {
    return _artifactsFuture ??= _loadArtifacts();
  }

  Future<PredictionArtifacts> _loadArtifacts() async {
    final List<String> jsonFiles = await Future.wait(<Future<String>>[
      rootBundle.loadString('$_assetRoot/preprocessing.json'),
      rootBundle.loadString('$_assetRoot/manifest.json'),
      rootBundle.loadString('$_assetRoot/catalog.json'),
      rootBundle.loadString('$_assetRoot/collaborative_candidates.json'),
    ]);
    final Map<String, dynamic> preprocessing = Map<String, dynamic>.from(jsonDecode(jsonFiles[0]) as Map);
    final Map<String, dynamic> manifest = Map<String, dynamic>.from(jsonDecode(jsonFiles[1]) as Map);
    final List<dynamic> catalogJson = jsonDecode(jsonFiles[2]) as List<dynamic>;
    final Map<String, dynamic> relatedJson = Map<String, dynamic>.from(jsonDecode(jsonFiles[3]) as Map);
    final Map<String, dynamic> normalization = Map<String, dynamic>.from(preprocessing['normalization'] as Map);
    final Map<String, dynamic> calibration = Map<String, dynamic>.from(preprocessing['calibration'] as Map);
    final Map<String, dynamic> output = Map<String, dynamic>.from(preprocessing['output'] as Map);
    final Map<String, dynamic> personalization = Map<String, dynamic>.from(
      preprocessing['personalization'] as Map? ?? const <String, dynamic>{},
    );

    final Map<String, PredictionProduct> catalog = <String, PredictionProduct>{};
    for (final dynamic item in catalogJson) {
      final PredictionProduct product = PredictionProduct.fromJson(Map<String, dynamic>.from(item as Map));
      if (product.productId.isNotEmpty) {
        catalog[product.productId] = product;
      }
    }

    final Map<String, List<RelatedProductCandidate>> relatedProducts = <String, List<RelatedProductCandidate>>{};
    for (final MapEntry<String, dynamic> entry in relatedJson.entries) {
      final List<dynamic> values = entry.value as List<dynamic>? ?? <dynamic>[];
      relatedProducts[entry.key] = values
          .map((dynamic item) => RelatedProductCandidate.fromJson(Map<String, dynamic>.from(item as Map)))
          .where((RelatedProductCandidate item) => item.productId.isNotEmpty)
          .toList(growable: false);
    }

    return PredictionArtifacts(
      featureNames: _stringList(preprocessing['feature_names']),
      featureTransforms: _stringMap(preprocessing['feature_transforms']),
      eventWeights: _doubleMap(preprocessing['event_weights'], fieldName: 'event_weights'),
      mean: _doubleList(normalization['mean']),
      scale: _doubleList(normalization['scale']),
      calibrationCoefficient: (calibration['coefficient'] as num).toDouble(),
      calibrationIntercept: (calibration['intercept'] as num).toDouble(),
      decisionThreshold: (output['classification_threshold'] as num).toDouble(),
      modelVersion: manifest['model_version']?.toString() ?? 'unknown',
      inputSchemaVersion: manifest['feature_schema_version']?.toString() ?? 'unknown',
      personalizationThresholds: _personalizationThresholds(personalization),
      catalog: Map<String, PredictionProduct>.unmodifiable(catalog),
      relatedProducts: Map<String, List<RelatedProductCandidate>>.unmodifiable(relatedProducts),
    );
  }

  @override
  Future<double> run(List<double> normalizedInput) async {
    final PredictionArtifacts artifacts = await loadArtifacts();
    if (normalizedInput.length != artifacts.featureNames.length) {
      throw ArgumentError('The model needs ${artifacts.featureNames.length} inputs');
    }
    final Interpreter interpreter = _interpreter ??= await Interpreter.fromAsset('$_assetRoot/model.tflite');
    final List<List<double>> input = <List<double>>[normalizedInput];
    final List<List<double>> output = <List<double>>[
      <double>[0],
    ];
    interpreter.run(input, output);
    return output.first.first;
  }

  List<String> _stringList(dynamic value) {
    return (value as List<dynamic>).map((dynamic item) => item.toString()).toList(growable: false);
  }

  List<double> _doubleList(dynamic value) {
    return (value as List<dynamic>).map((dynamic item) => (item as num).toDouble()).toList(growable: false);
  }

  Map<String, double> _doubleMap(dynamic value, {required String fieldName}) {
    if (value is! Map || value.isEmpty) {
      throw FormatException('Model preprocessing is missing $fieldName');
    }
    final Map<String, double> result = <String, double>{};
    for (final MapEntry<dynamic, dynamic> entry in value.entries) {
      if (entry.value is! num) {
        throw FormatException('Model preprocessing has a non-numeric $fieldName value');
      }
      result[entry.key.toString()] = (entry.value as num).toDouble();
    }
    return Map<String, double>.unmodifiable(result);
  }

  Map<String, String> _stringMap(dynamic value) {
    if (value == null) return const <String, String>{};
    if (value is! Map) throw const FormatException('Model feature transforms must be a map');
    return Map<String, String>.unmodifiable(
      value.map((dynamic key, dynamic item) => MapEntry<String, String>(key.toString(), item.toString())),
    );
  }

  PersonalizationThresholds _personalizationThresholds(Map<String, dynamic> values) {
    if (values.isEmpty) return PersonalizationThresholds.fallback;
    return PersonalizationThresholds(
      alternativeProductsMax: (values['alternative_products_max'] as num).toDouble(),
      informationHighlightMax: (values['information_highlight_max'] as num).toDouble(),
    );
  }

  @override
  @disposeMethod
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
