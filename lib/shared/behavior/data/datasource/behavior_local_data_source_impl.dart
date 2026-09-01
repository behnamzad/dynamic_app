import 'package:dynamic_app/shared/behavior/data/database/behavior_database.dart';
import 'package:dynamic_app/shared/behavior/data/datasource/behavior_local_data_source.dart';
import 'package:dynamic_app/shared/behavior/data/models/behavior_event_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

/// پیاده‌سازی SQLite صف eventها؛ فقط داده محلی را مدیریت می‌کند و هیچ درخواست شبکه‌ای نمی‌فرستد.
@LazySingleton(as: BehaviorLocalDataSource)
class BehaviorLocalDataSourceImpl implements BehaviorLocalDataSource {
  BehaviorLocalDataSourceImpl(this._behaviorDatabase);

  final BehaviorDatabase _behaviorDatabase;

  @override
  Future<void> insert(BehaviorEventDto event) async {
    final Database database = _behaviorDatabase.database;
    await database.insert(
      BehaviorDatabase.eventsTable,
      event.toLocalMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<List<BehaviorEventDto>> getUserHistory(String userId) async {
    final Database database = _behaviorDatabase.database;
    final List<Map<String, Object?>> rows = await database.query(
      BehaviorDatabase.eventsTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'event_timestamp ASC, event_id ASC',
    );
    return rows.map(BehaviorEventDto.fromLocalMap).toList(growable: false);
  }

  @override
  Future<List<BehaviorEventDto>> getPending({required String userId, required int limit}) async {
    final Database database = _behaviorDatabase.database;
    final List<Map<String, Object?>> rows = await database.query(
      BehaviorDatabase.eventsTable,
      where: 'sync_status = ? AND user_id = ?',
      whereArgs: ['pending', userId],
      orderBy: 'created_at ASC, event_id ASC',
      limit: limit,
    );
    return rows.map(BehaviorEventDto.fromLocalMap).toList(growable: false);
  }

  @override
  Future<void> markSynced(Set<String> eventIds, DateTime syncedAt) async {
    if (eventIds.isEmpty) return;
    final Database database = _behaviorDatabase.database;
    await database.transaction((transaction) async {
      for (final String eventId in eventIds) {
        await transaction.update(
          BehaviorDatabase.eventsTable,
          {
            'sync_status': 'synced',
            'synced_at': syncedAt.toUtc().toIso8601String(),
            'last_sync_attempt_at': syncedAt.toUtc().toIso8601String(),
            'last_sync_error': null,
          },
          where: 'event_id = ? AND sync_status = ?',
          whereArgs: [eventId, 'pending'],
        );
      }
    });
  }

  @override
  Future<void> markSyncFailed(Set<String> eventIds, String error, DateTime attemptedAt) async {
    if (eventIds.isEmpty) return;
    final Database database = _behaviorDatabase.database;
    final String boundedError = error.length <= 1000 ? error : error.substring(0, 1000);
    await database.transaction((transaction) async {
      for (final String eventId in eventIds) {
        await transaction.rawUpdate(
          '''
          UPDATE ${BehaviorDatabase.eventsTable}
          SET sync_attempt_count = sync_attempt_count + 1,
              last_sync_attempt_at = ?,
              last_sync_error = ?
          WHERE event_id = ? AND sync_status = 'pending'
          ''',
          [attemptedAt.toUtc().toIso8601String(), boundedError, eventId],
        );
      }
    });
  }

  @override
  Future<int> pendingCount() async {
    final Database database = _behaviorDatabase.database;
    final List<Map<String, Object?>> result = await database.rawQuery(
      "SELECT COUNT(*) AS count FROM ${BehaviorDatabase.eventsTable} WHERE sync_status = 'pending'",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<void> attributePendingAnonymousEvents({required String anonymousId, required String userId}) async {
    final Database database = _behaviorDatabase.database;
    await database.update(
      BehaviorDatabase.eventsTable,
      {'user_id': userId},
      where: 'anonymous_id = ? AND is_authenticated = 0 AND sync_status = ?',
      whereArgs: [anonymousId, 'pending'],
    );
  }

  @override
  Future<int> deleteAllEvents() async {
    final Database database = _behaviorDatabase.database;
    return database.delete(BehaviorDatabase.eventsTable);
  }
}
