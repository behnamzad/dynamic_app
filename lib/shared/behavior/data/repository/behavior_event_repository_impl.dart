import 'package:dynamic_app/shared/behavior/data/datasource/behavior_local_data_source.dart';
import 'package:dynamic_app/shared/behavior/data/models/behavior_event_dto.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/repository/behavior_event_repository.dart';
import 'package:injectable/injectable.dart';

/// واسط دامنه را به SQLite متصل می‌کند و batch را هم‌زمان با محدودیت تعداد و حجم می‌سازد.
@LazySingleton(as: BehaviorEventRepository)
class BehaviorEventRepositoryImpl implements BehaviorEventRepository {
  BehaviorEventRepositoryImpl(this._localDataSource);

  final BehaviorLocalDataSource _localDataSource;

  @override
  Future<void> record(BehaviorEvent event) {
    return _localDataSource.insert(BehaviorEventDto(event: event));
  }

  @override
  Future<List<BehaviorEvent>> getPendingBatch({
    required String userId,
    required int maxRows,
    required int maxBytes,
  }) async {
    if (maxRows <= 0 || maxBytes <= 0) {
      throw ArgumentError('Batch row and byte limits must be positive');
    }
    final List<BehaviorEventDto> candidates = await _localDataSource.getPending(userId: userId, limit: maxRows);
    final List<BehaviorEvent> batch = <BehaviorEvent>[];
    int bytes = 2;
    for (final BehaviorEventDto candidate in candidates) {
      final int eventBytes = candidate.serializedRemoteBytes + (batch.isEmpty ? 0 : 1);
      if (batch.isNotEmpty && bytes + eventBytes > maxBytes) {
        break;
      }
      batch.add(candidate.event);
      bytes += eventBytes;
      if (bytes >= maxBytes) {
        break;
      }
    }
    return List.unmodifiable(batch);
  }

  @override
  Future<void> markSynced(Set<String> acknowledgedEventIds, DateTime syncedAt) {
    return _localDataSource.markSynced(acknowledgedEventIds, syncedAt);
  }

  @override
  Future<void> markSyncFailed(Set<String> eventIds, String error, DateTime attemptedAt) {
    return _localDataSource.markSyncFailed(eventIds, error, attemptedAt);
  }

  @override
  Future<int> pendingCount() => _localDataSource.pendingCount();

  @override
  Future<void> attributePendingAnonymousEvents({required String anonymousId, required String userId}) {
    return _localDataSource.attributePendingAnonymousEvents(anonymousId: anonymousId, userId: userId);
  }
}
