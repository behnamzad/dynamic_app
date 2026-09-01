import 'dart:convert';

import 'package:dynamic_app/core/local/user/user.dart';
import 'package:dynamic_app/shared/prediction/data/feature_engineering/prediction_input_builder.dart';
import 'package:dynamic_app/shared/prediction/data/models/prediction_artifacts.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_context.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<String> orderedFeatureNames;
  late Map<String, double> eventWeightByTypeName;

  setUpAll(() async {
    final Map<String, dynamic> preprocessing = Map<String, dynamic>.from(
      jsonDecode(await rootBundle.loadString('assets/ml/preprocessing.json'))
          as Map,
    );
    orderedFeatureNames = (preprocessing['feature_names'] as List)
        .map((dynamic value) => value.toString())
        .toList(growable: false);
    eventWeightByTypeName =
        Map<String, dynamic>.from(preprocessing['event_weights'] as Map).map(
          (String key, dynamic value) =>
              MapEntry<String, double>(key, (value as num).toDouble()),
        );
  });

  test(
    'builds inputs with the order and event weights published by Python',
    () {
      final PredictionInputBuilder inputBuilder = PredictionInputBuilder();
      final DateTime predictionTime = DateTime.utc(2026, 8, 25, 12);
      const BehaviorProductSnapshot product = BehaviorProductSnapshot(
        productId: '10',
        categoryId: '20',
        brandId: '30',
      );
      final List<BehaviorEvent> events = <BehaviorEvent>[
        _event(
          id: '1',
          type: BehaviorEventType.productImpression,
          time: predictionTime.subtract(const Duration(days: 2)),
          product: product,
        ),
        _event(
          id: '2',
          type: BehaviorEventType.productClick,
          time: predictionTime.subtract(const Duration(days: 1)),
          product: product,
        ),
        _event(
          id: '3',
          type: BehaviorEventType.productDetailView,
          time: predictionTime.subtract(const Duration(hours: 12)),
          product: product,
        ),
        _event(
          id: '4',
          type: BehaviorEventType.productViewEnd,
          time: predictionTime.subtract(const Duration(hours: 11)),
          product: product,
          durationMs: 12000,
        ),
        _event(
          id: '5',
          type: BehaviorEventType.cartAdd,
          time: predictionTime.subtract(const Duration(hours: 5)),
          product: product,
        ),
      ];
      final PredictionInputContext context = inputBuilder.buildContext(
        events: events,
        eventWeightByTypeName: eventWeightByTypeName,
        currentSessionId: 'session-1',
        userAge: 27,
        userGender: AppUserGender.male,
        predictionTime: predictionTime,
      );
      final Map<String, double> features = _buildNamedFeatureValues(
        inputBuilder: inputBuilder,
        context: context,
        product: const PredictionProduct(
          productId: '10',
          categoryId: '20',
          brandId: '30',
        ),
        orderedFeatureNames: orderedFeatureNames,
        displayPosition: 4,
      );

      expect(features, hasLength(orderedFeatureNames.length));
      expect(features['product_impressions_lifetime'], 1);
      expect(features['product_clicks_7d'], 1);
      expect(features['product_views_lifetime'], 1);
      expect(features['product_cart_adds_30d'], 1);
      expect(features['product_dwell_seconds_lifetime'], 12);
      expect(features['category_affinity_lifetime'], closeTo(7.7, 0.0001));
      expect(features['session_event_count'], 5);
      expect(features['display_position'], 4);
      expect(features['user_age'], 27);
      expect(features['user_age_known'], 1);
      expect(features['gender_male'], 1);
      expect(features['gender_female'], 0);
    },
  );

  test(
    'ignores future events and counts recent events inside their time window',
    () {
      final PredictionInputBuilder inputBuilder = PredictionInputBuilder();
      final DateTime predictionTime = DateTime.utc(2026, 8, 25, 12);
      const BehaviorProductSnapshot product = BehaviorProductSnapshot(
        productId: '10',
        categoryId: '20',
        brandId: '30',
      );
      final PredictionInputContext context = inputBuilder.buildContext(
        events: <BehaviorEvent>[
          _event(
            id: 'old-click',
            type: BehaviorEventType.productClick,
            time: predictionTime.subtract(const Duration(days: 8)),
            product: product,
          ),
          _event(
            id: 'recent-click',
            type: BehaviorEventType.productClick,
            time: predictionTime.subtract(const Duration(days: 6)),
            product: product,
          ),
          _event(
            id: 'future-click',
            type: BehaviorEventType.productClick,
            time: predictionTime.add(const Duration(minutes: 1)),
            product: product,
          ),
        ],
        eventWeightByTypeName: eventWeightByTypeName,
        currentSessionId: 'session-1',
        userAge: null,
        userGender: AppUserGender.unknown,
        predictionTime: predictionTime,
      );
      final Map<String, double> features = _buildNamedFeatureValues(
        inputBuilder: inputBuilder,
        context: context,
        product: const PredictionProduct(
          productId: '10',
          categoryId: '20',
          brandId: '30',
        ),
        orderedFeatureNames: orderedFeatureNames,
      );

      expect(features['product_clicks_lifetime'], 2);
      expect(features['product_clicks_7d'], 1);
      expect(features['session_event_count'], 2);
      expect(features['user_age_known'], 0);
    },
  );

  test(
    'splits a multi-product purchase into one history entry per product',
    () {
      final PredictionInputBuilder inputBuilder = PredictionInputBuilder();
      final DateTime predictionTime = DateTime.utc(2026, 8, 25, 12);
      final PredictionInputContext context = inputBuilder.buildContext(
        events: <BehaviorEvent>[
          _event(
            id: 'purchase-1',
            type: BehaviorEventType.purchaseSucceeded,
            time: predictionTime.subtract(const Duration(hours: 1)),
            product: const BehaviorProductSnapshot(),
            payload: const CheckoutBehaviorPayload(
              productIds: <String>['10', '11'],
              productSnapshots: <BehaviorProductSnapshot>[
                BehaviorProductSnapshot(
                  productId: '10',
                  categoryId: '20',
                  brandId: '30',
                ),
                BehaviorProductSnapshot(
                  productId: '11',
                  categoryId: '21',
                  brandId: '31',
                ),
              ],
            ),
          ),
        ],
        eventWeightByTypeName: eventWeightByTypeName,
        currentSessionId: 'session-1',
        userAge: 27,
        userGender: AppUserGender.male,
        predictionTime: predictionTime,
      );
      final Map<String, double> firstProductFeatures = _buildNamedFeatureValues(
        inputBuilder: inputBuilder,
        context: context,
        product: const PredictionProduct(
          productId: '10',
          categoryId: '20',
          brandId: '30',
        ),
        orderedFeatureNames: orderedFeatureNames,
      );
      final Map<String, double> secondProductFeatures =
          _buildNamedFeatureValues(
            inputBuilder: inputBuilder,
            context: context,
            product: const PredictionProduct(
              productId: '11',
              categoryId: '21',
              brandId: '31',
            ),
            orderedFeatureNames: orderedFeatureNames,
          );

      expect(firstProductFeatures['product_purchases_lifetime'], 1);
      expect(secondProductFeatures['product_purchases_lifetime'], 1);
      expect(firstProductFeatures['category_purchases_lifetime'], 1);
      expect(secondProductFeatures['category_purchases_lifetime'], 1);
      expect(firstProductFeatures['user_event_count_lifetime'], 2);
    },
  );
}

Map<String, double> _buildNamedFeatureValues({
  required PredictionInputBuilder inputBuilder,
  required PredictionInputContext context,
  required PredictionProduct product,
  required List<String> orderedFeatureNames,
  int displayPosition = 0,
}) {
  final List<double> values = inputBuilder.buildRawFeatureVector(
    context: context,
    candidateProduct: product,
    orderedFeatureNames: orderedFeatureNames,
    displayPosition: displayPosition,
  );
  return <String, double>{
    for (int index = 0; index < orderedFeatureNames.length; index++)
      orderedFeatureNames[index]: values[index],
  };
}

BehaviorEvent _event({
  required String id,
  required BehaviorEventType type,
  required DateTime time,
  required BehaviorProductSnapshot product,
  BehaviorEventPayload payload = const EmptyBehaviorPayload(),
  int? durationMs,
}) {
  return BehaviorEvent(
    eventId: id,
    userId: 'user-1',
    anonymousId: 'anonymous-1',
    sessionId: 'session-1',
    type: type,
    eventTimestamp: time,
    clientGeneratedAt: time,
    appVersion: '1.0.0+1',
    schemaVersion: 2,
    isAuthenticated: true,
    subject: product,
    payload: payload,
    context: const BehaviorEventContext(platform: 'android'),
    durationMs: durationMs,
  );
}
