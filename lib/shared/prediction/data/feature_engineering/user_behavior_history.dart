part of 'prediction_input_builder.dart';

/// یک رفتار آماده‌شده که فقط اطلاعات لازم برای ساخت ویژگی‌های مدل را نگه می‌دارد.
class _BehaviorHistoryEntry {
  const _BehaviorHistoryEntry({
    required this.type,
    required this.occurredAt,
    required this.sessionId,
    required this.productContext,
    required this.durationMs,
  });

  final BehaviorEventType type;
  final DateTime occurredAt;
  final String sessionId;
  final BehaviorProductSnapshot productContext;
  final int? durationMs;

  factory _BehaviorHistoryEntry.fromEvent(BehaviorEvent event, {BehaviorProductSnapshot? productContext}) {
    return _BehaviorHistoryEntry(
      type: event.type,
      occurredAt: event.eventTimestamp.toUtc(),
      sessionId: event.sessionId,
      productContext: productContext ?? event.subject,
      durationMs: event.durationMs,
    );
  }
}

enum _BehaviorTargetScope { product, category, brand }

typedef _BehaviorTarget = ({_BehaviorTargetScope scope, String id});
typedef _BehaviorEventCountKey = ({_BehaviorTargetScope scope, String id, BehaviorEventType eventType});
typedef _TimedInterestScore = ({DateTime occurredAt, double score});

/// رفتارهای قبلی کاربر را یک‌بار آماده می‌کند تا شمارش و جست‌وجوی آن‌ها سریع باشد.
class _UserBehaviorHistory {
  _UserBehaviorHistory._(Map<String, double> eventWeightByTypeName)
    : _eventWeightByTypeName = Map<String, double>.unmodifiable(eventWeightByTypeName);

  factory _UserBehaviorHistory.fromEvents({
    required List<BehaviorEvent> events,
    required Map<String, double> eventWeightByTypeName,
    required DateTime predictionTime,
  }) {
    final DateTime predictionTimeUtc = predictionTime.toUtc();
    final List<BehaviorEvent> orderedPastEvents =
        events
            .where((BehaviorEvent event) => !event.eventTimestamp.toUtc().isAfter(predictionTimeUtc))
            .toList(growable: false)
          ..sort((BehaviorEvent left, BehaviorEvent right) {
            final int timeOrder = left.eventTimestamp.compareTo(right.eventTimestamp);
            return timeOrder != 0 ? timeOrder : left.eventId.compareTo(right.eventId);
          });

    final _UserBehaviorHistory history = _UserBehaviorHistory._(eventWeightByTypeName);
    for (final BehaviorEvent event in orderedPastEvents) {
      for (final _BehaviorHistoryEntry entry in history._expandEventIntoHistoryEntries(event)) {
        history._recordEntry(entry);
      }
    }
    return history;
  }

  final Map<String, double> _eventWeightByTypeName;
  final Map<_BehaviorEventCountKey, int> _eventCountByTargetAndType = <_BehaviorEventCountKey, int>{};
  final Map<_BehaviorEventCountKey, List<DateTime>> _eventTimesByTargetAndType =
      <_BehaviorEventCountKey, List<DateTime>>{};
  final Map<_BehaviorTarget, double> _interestScoreByTarget = <_BehaviorTarget, double>{};
  final Map<_BehaviorTarget, List<_TimedInterestScore>> _interestChangesByTarget =
      <_BehaviorTarget, List<_TimedInterestScore>>{};
  final Map<String, double> _productDwellSecondsById = <String, double>{};
  final Map<String, DateTime> _lastProductInteractionAtById = <String, DateTime>{};
  final Map<String, int> _eventCountBySessionId = <String, int>{};
  int _totalEventCount = 0;

  int get totalEventCount => _totalEventCount;

  List<_BehaviorHistoryEntry> _expandEventIntoHistoryEntries(BehaviorEvent event) {
    final Map<String, dynamic> payload = event.payload.toJson();
    if (event.type != BehaviorEventType.purchaseSucceeded || _nonEmptyId(event.subject.productId) != null) {
      return <_BehaviorHistoryEntry>[_BehaviorHistoryEntry.fromEvent(event)];
    }

    final List<String> purchasedProductIds = _readStringList(payload['product_ids']);
    final Map<String, BehaviorProductSnapshot> productSnapshotById = <String, BehaviorProductSnapshot>{};
    final dynamic rawProductSnapshots = payload['product_snapshots'];
    if (rawProductSnapshots is List) {
      for (final dynamic value in rawProductSnapshots) {
        if (value is! Map) continue;
        final BehaviorProductSnapshot snapshot = BehaviorProductSnapshot.fromJson(Map<String, dynamic>.from(value));
        final String? productId = _nonEmptyId(snapshot.productId);
        if (productId != null) productSnapshotById[productId] = snapshot;
      }
    }
    if (purchasedProductIds.isEmpty) {
      return <_BehaviorHistoryEntry>[_BehaviorHistoryEntry.fromEvent(event)];
    }
    return purchasedProductIds
        .map((String productId) {
          return _BehaviorHistoryEntry.fromEvent(
            event,
            productContext: productSnapshotById[productId] ?? BehaviorProductSnapshot(productId: productId),
          );
        })
        .toList(growable: false);
  }

  void _recordEntry(_BehaviorHistoryEntry entry) {
    final String? productId = _nonEmptyId(entry.productContext.productId);
    final List<_BehaviorTarget> affectedTargets = _behaviorTargetsFor(entry.productContext, productId);

    _recordSessionAndLastInteraction(entry, productId);
    _recordOccurrence(entry, affectedTargets);
    _recordInterest(entry, affectedTargets);
    _recordProductDwellTime(entry, productId);
  }

  List<_BehaviorTarget> _behaviorTargetsFor(BehaviorProductSnapshot productContext, String? productId) {
    return <_BehaviorTarget>[
      (scope: _BehaviorTargetScope.category, id: _nonEmptyId(productContext.categoryId) ?? 'unknown-category'),
      (scope: _BehaviorTargetScope.brand, id: _nonEmptyId(productContext.brandId) ?? 'unknown-brand'),
      if (productId != null) (scope: _BehaviorTargetScope.product, id: productId),
    ];
  }

  void _recordSessionAndLastInteraction(_BehaviorHistoryEntry entry, String? productId) {
    final String sessionId = _nonEmptyId(entry.sessionId) ?? 'unknown-session';
    _totalEventCount++;
    _eventCountBySessionId.update(sessionId, (int count) => count + 1, ifAbsent: () => 1);
    if (productId != null) {
      _lastProductInteractionAtById[productId] = entry.occurredAt;
    }
  }

  void _recordOccurrence(_BehaviorHistoryEntry entry, List<_BehaviorTarget> affectedTargets) {
    for (final _BehaviorTarget target in affectedTargets) {
      final _BehaviorEventCountKey key = (scope: target.scope, id: target.id, eventType: entry.type);
      _eventCountByTargetAndType.update(key, (int count) => count + 1, ifAbsent: () => 1);
      _eventTimesByTargetAndType.putIfAbsent(key, () => <DateTime>[]).add(entry.occurredAt);
    }
  }

  void _recordInterest(_BehaviorHistoryEntry entry, List<_BehaviorTarget> affectedTargets) {
    final double score = _eventWeightByTypeName[entry.type.wireName] ?? 0;
    if (score == 0) return;

    for (final _BehaviorTarget target in affectedTargets) {
      _interestScoreByTarget.update(target, (double current) => current + score, ifAbsent: () => score);
      _interestChangesByTarget.putIfAbsent(target, () => <_TimedInterestScore>[]).add((
        occurredAt: entry.occurredAt,
        score: score,
      ));
    }
  }

  void _recordProductDwellTime(_BehaviorHistoryEntry entry, String? productId) {
    if (productId == null || entry.type != BehaviorEventType.productViewEnd) {
      return;
    }
    final double dwellSeconds = math.max(0, entry.durationMs ?? 0) / 1000;
    _productDwellSecondsById.update(
      productId,
      (double current) => current + dwellSeconds,
      ifAbsent: () => dwellSeconds,
    );
  }

  double lifetimeEventCount(_BehaviorTargetScope scope, String id, BehaviorEventType eventType) {
    final _BehaviorEventCountKey key = (scope: scope, id: id, eventType: eventType);
    return (_eventCountByTargetAndType[key] ?? 0).toDouble();
  }

  double eventCountInLastDays(
    _BehaviorTargetScope scope,
    String id,
    BehaviorEventType eventType,
    DateTime predictionTime,
    int days,
  ) {
    final DateTime windowStart = predictionTime.subtract(Duration(days: days));
    final List<DateTime> eventTimes =
        _eventTimesByTargetAndType[(scope: scope, id: id, eventType: eventType)] ?? const <DateTime>[];
    int count = 0;
    for (final DateTime eventTime in eventTimes.reversed) {
      if (eventTime.isBefore(windowStart)) break;
      count++;
    }
    return count.toDouble();
  }

  double lifetimeInterestScore(_BehaviorTargetScope scope, String id) {
    return _interestScoreByTarget[(scope: scope, id: id)] ?? 0;
  }

  double interestScoreInLastDays(_BehaviorTargetScope scope, String id, DateTime predictionTime, int days) {
    final DateTime windowStart = predictionTime.subtract(Duration(days: days));
    final List<_TimedInterestScore> changes =
        _interestChangesByTarget[(scope: scope, id: id)] ?? const <_TimedInterestScore>[];
    double score = 0;
    for (final _TimedInterestScore change in changes.reversed) {
      if (change.occurredAt.isBefore(windowStart)) break;
      score += change.score;
    }
    return score;
  }

  double lifetimeProductDwellSeconds(String productId) => _productDwellSecondsById[productId] ?? 0;

  DateTime? lastProductInteractionAt(String productId) => _lastProductInteractionAtById[productId];

  double eventCountForSession(String sessionId) => (_eventCountBySessionId[sessionId] ?? 0).toDouble();

  List<String> _readStringList(dynamic value) {
    return value is List ? value.map((dynamic item) => item.toString()).toList(growable: false) : const <String>[];
  }

  String? _nonEmptyId(String? value) {
    final String id = value?.trim() ?? '';
    return id.isEmpty ? null : id;
  }
}
