import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:dynamic_app/shared/interest/domain/entities/category_interest.dart';

class CategoryInterestBuilder {
  const CategoryInterestBuilder();

  List<CategoryInterest> build({
    required List<BehaviorEvent> events,
    required Map<String, double> eventWeights,
    required DateTime now,
    required int limit,
  }) {
    if (limit <= 0) return const <CategoryInterest>[];

    final DateTime nowUtc = now.toUtc();
    final DateTime recentStart = nowUtc.subtract(const Duration(days: 30));
    final Map<String, _CategoryScore> scores = <String, _CategoryScore>{};

    for (final BehaviorEvent event in events) {
      final DateTime eventTime = event.eventTimestamp.toUtc();
      if (eventTime.isAfter(nowUtc)) continue;
      final double weight = eventWeights[event.type.wireName] ?? 0;
      if (weight == 0) continue;

      for (final BehaviorProductSnapshot product in _eventProducts(event)) {
        final String categoryId = product.categoryId?.trim() ?? '';
        if (categoryId.isEmpty) continue;
        final _CategoryScore score = scores.putIfAbsent(
          categoryId,
          _CategoryScore.new,
        );
        score.total += weight;
        if (!eventTime.isBefore(recentStart)) score.recent += weight;
        final String categoryName = product.categoryName?.trim() ?? '';
        if (categoryName.isNotEmpty) score.name = categoryName;
      }
    }

    final List<CategoryInterest> result =
        scores.entries
            .where(
              (MapEntry<String, _CategoryScore> entry) =>
                  entry.value.total > 0 || entry.value.recent > 0,
            )
            .map(
              (MapEntry<String, _CategoryScore> entry) => CategoryInterest(
                categoryId: entry.key,
                categoryName: entry.value.name,
                totalScore: entry.value.total,
                recentScore: entry.value.recent,
              ),
            )
            .toList(growable: false)
          ..sort(_compare);
    return List<CategoryInterest>.unmodifiable(result.take(limit));
  }

  List<BehaviorProductSnapshot> _eventProducts(BehaviorEvent event) {
    if ((event.subject.categoryId?.trim() ?? '').isNotEmpty) {
      return <BehaviorProductSnapshot>[event.subject];
    }
    final dynamic values = event.payload.toJson()['product_snapshots'];
    if (values is! List) return const <BehaviorProductSnapshot>[];
    return values
        .whereType<Map>()
        .map(
          (Map<dynamic, dynamic> value) => BehaviorProductSnapshot.fromJson(
            Map<String, dynamic>.from(value),
          ),
        )
        .toList(growable: false);
  }

  int _compare(CategoryInterest left, CategoryInterest right) {
    final int recentOrder = right.recentScore.compareTo(left.recentScore);
    if (recentOrder != 0) return recentOrder;
    final int totalOrder = right.totalScore.compareTo(left.totalScore);
    return totalOrder != 0
        ? totalOrder
        : left.categoryId.compareTo(right.categoryId);
  }
}

class _CategoryScore {
  String name = '';
  double total = 0;
  double recent = 0;
}
