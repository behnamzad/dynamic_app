import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_context.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:dynamic_app/shared/interest/data/category_interest_builder.dart';
import 'package:dynamic_app/shared/interest/domain/entities/category_interest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sorts categories with recent local behavior', () {
    final DateTime now = DateTime.utc(2026, 8, 30, 12);
    final List<CategoryInterest> result = const CategoryInterestBuilder().build(
      events: <BehaviorEvent>[
        _event(
          id: 'old-click',
          type: BehaviorEventType.productClick,
          time: now.subtract(const Duration(days: 40)),
          categoryId: 'c1',
          categoryName: 'دسته اول',
        ),
        _event(
          id: 'recent-view',
          type: BehaviorEventType.productDetailView,
          time: now.subtract(const Duration(days: 2)),
          categoryId: 'c1',
          categoryName: 'دسته اول',
        ),
        _event(
          id: 'recent-cart',
          type: BehaviorEventType.cartAdd,
          time: now.subtract(const Duration(hours: 2)),
          categoryId: 'c2',
          categoryName: 'دسته دوم',
        ),
        _event(
          id: 'future-purchase',
          type: BehaviorEventType.purchaseSucceeded,
          time: now.add(const Duration(minutes: 1)),
          categoryId: 'c1',
          categoryName: 'دسته اول',
        ),
      ],
      eventWeights: const <String, double>{
        'product_click': 1,
        'product_detail_view': 1.6,
        'cart_add': 5,
        'purchase_succeeded': 8,
      },
      now: now,
      limit: 5,
    );

    expect(result.map((CategoryInterest item) => item.categoryId), <String>[
      'c2',
      'c1',
    ]);
    expect(result.first.categoryName, 'دسته دوم');
    expect(result.first.recentScore, 5);
    expect(result.last.totalScore, 2.6);
    expect(result.last.recentScore, 1.6);
  });

  test('reads every category from a multi-product purchase', () {
    final DateTime now = DateTime.utc(2026, 8, 30, 12);
    final List<CategoryInterest> result = const CategoryInterestBuilder().build(
      events: <BehaviorEvent>[
        _event(
          id: 'purchase',
          type: BehaviorEventType.purchaseSucceeded,
          time: now.subtract(const Duration(hours: 1)),
          payload: const CheckoutBehaviorPayload(
            productIds: <String>['p1', 'p2'],
            productSnapshots: <BehaviorProductSnapshot>[
              BehaviorProductSnapshot(
                productId: 'p1',
                categoryId: 'c1',
                categoryName: 'دسته اول',
              ),
              BehaviorProductSnapshot(
                productId: 'p2',
                categoryId: 'c2',
                categoryName: 'دسته دوم',
              ),
            ],
          ),
        ),
      ],
      eventWeights: const <String, double>{'purchase_succeeded': 8},
      now: now,
      limit: 5,
    );

    expect(result, hasLength(2));
    expect(
      result.every((CategoryInterest item) => item.totalScore == 8),
      isTrue,
    );
  });
}

BehaviorEvent _event({
  required String id,
  required BehaviorEventType type,
  required DateTime time,
  String? categoryId,
  String? categoryName,
  BehaviorEventPayload payload = const EmptyBehaviorPayload(),
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
    subject: BehaviorProductSnapshot(
      categoryId: categoryId,
      categoryName: categoryName,
    ),
    payload: payload,
    context: const BehaviorEventContext(platform: 'android'),
  );
}
