import 'dart:convert';

import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_context.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_sync_status.dart';

/// شکل ذخیره‌سازی event؛ mapper مشترک میان entity دامنه، ردیف SQLite و payload ارسالی Supabase است.
class BehaviorEventDto {
  const BehaviorEventDto({
    required this.event,
    this.syncStatus = BehaviorSyncStatus.pending,
    this.syncAttemptCount = 0,
    this.lastSyncAttemptAt,
    this.lastSyncError,
    this.syncedAt,
  });

  final BehaviorEvent event;
  final BehaviorSyncStatus syncStatus;
  final int syncAttemptCount;
  final DateTime? lastSyncAttemptAt;
  final String? lastSyncError;
  final DateTime? syncedAt;

  /// ردیف مناسب SQLite را همراه وضعیت sync و JSONهای نسخه‌پذیر می‌سازد.
  Map<String, Object?> toLocalMap() {
    final BehaviorProductSnapshot subject = event.subject;
    return {
      'event_id': event.eventId,
      'user_id': event.userId,
      'anonymous_id': event.anonymousId,
      'session_id': event.sessionId,
      'event_type': event.type.wireName,
      'event_timestamp': event.eventTimestamp.toUtc().toIso8601String(),
      'client_generated_at': event.clientGeneratedAt.toUtc().toIso8601String(),
      'app_version': event.appVersion,
      'schema_version': event.schemaVersion,
      'is_authenticated': event.isAuthenticated ? 1 : 0,
      'product_id': subject.productId,
      'product_name': subject.productName,
      'category_id': subject.categoryId,
      'category_name': subject.categoryName,
      'brand_id': subject.brandId,
      'brand_name': subject.brandName,
      'source_screen': event.sourceScreen,
      'destination_screen': event.destinationScreen,
      'referrer_screen': event.referrerScreen,
      'duration_ms': event.durationMs,
      'position': event.position,
      'event_status': event.status,
      'subject_snapshot_json': jsonEncode(subject.toJson()),
      'payload_json': jsonEncode(event.payload.toJson()),
      'context_json': jsonEncode(event.context.toJson()),
      'sync_status': syncStatus.wireName,
      'sync_attempt_count': syncAttemptCount,
      'last_sync_attempt_at': lastSyncAttemptAt?.toUtc().toIso8601String(),
      'last_sync_error': lastSyncError,
      'synced_at': syncedAt?.toUtc().toIso8601String(),
      'created_at': event.clientGeneratedAt.toUtc().toIso8601String(),
    };
  }

  /// ردیف خام قابل‌تحلیل را برای جدول behavior_events در Supabase می‌سازد.
  Map<String, dynamic> toRemoteMap() {
    final BehaviorProductSnapshot subject = event.subject;
    return _removeNullValues({
      'event_id': event.eventId,
      'user_id': event.userId,
      'anonymous_id': event.anonymousId,
      'session_id': event.sessionId,
      'event_type': event.type.wireName,
      'event_timestamp': event.eventTimestamp.toUtc().toIso8601String(),
      'client_generated_at': event.clientGeneratedAt.toUtc().toIso8601String(),
      'app_version': event.appVersion,
      'schema_version': event.schemaVersion,
      'is_authenticated': event.isAuthenticated,
      'product_id': subject.productId,
      'product_name': subject.productName,
      'category_id': subject.categoryId,
      'category_name': subject.categoryName,
      'brand_id': subject.brandId,
      'brand_name': subject.brandName,
      'source_screen': event.sourceScreen,
      'destination_screen': event.destinationScreen,
      'referrer_screen': event.referrerScreen,
      'duration_ms': event.durationMs,
      'position': event.position,
      'event_status': event.status,
      'subject_snapshot': subject.toJson(),
      'payload': event.payload.toJson(),
      'context': event.context.toJson(),
    });
  }

  int get serializedRemoteBytes => utf8.encode(jsonEncode(toRemoteMap())).length;

  factory BehaviorEventDto.fromLocalMap(Map<String, Object?> map) {
    final Map<String, dynamic> subjectJson = _jsonMap(map['subject_snapshot_json']);
    final Map<String, dynamic> payloadJson = _jsonMap(map['payload_json']);
    final Map<String, dynamic> contextJson = _jsonMap(map['context_json']);
    return BehaviorEventDto(
      event: BehaviorEvent(
        eventId: map['event_id']!.toString(),
        userId: map['user_id']!.toString(),
        anonymousId: map['anonymous_id']!.toString(),
        sessionId: map['session_id']!.toString(),
        type: BehaviorEventType.fromWireName(map['event_type']!.toString()),
        eventTimestamp: DateTime.parse(map['event_timestamp']!.toString()).toUtc(),
        clientGeneratedAt: DateTime.parse(map['client_generated_at']!.toString()).toUtc(),
        appVersion: map['app_version']!.toString(),
        schemaVersion: (map['schema_version'] as num).toInt(),
        isAuthenticated: (map['is_authenticated'] as num).toInt() == 1,
        subject: BehaviorProductSnapshot.fromJson(subjectJson),
        payload: MapBehaviorPayload(payloadJson),
        context: BehaviorEventContext.fromJson(contextJson),
        sourceScreen: map['source_screen']?.toString(),
        destinationScreen: map['destination_screen']?.toString(),
        referrerScreen: map['referrer_screen']?.toString(),
        durationMs: (map['duration_ms'] as num?)?.toInt(),
        position: (map['position'] as num?)?.toInt(),
        status: map['event_status']?.toString(),
      ),
      syncStatus: BehaviorSyncStatus.fromWireName(map['sync_status']!.toString()),
      syncAttemptCount: (map['sync_attempt_count'] as num?)?.toInt() ?? 0,
      lastSyncAttemptAt: _date(map['last_sync_attempt_at']),
      lastSyncError: map['last_sync_error']?.toString(),
      syncedAt: _date(map['synced_at']),
    );
  }

  static Map<String, dynamic> _jsonMap(Object? value) {
    if (value == null || value.toString().isEmpty) {
      return {};
    }
    final dynamic decoded = jsonDecode(value.toString());
    return decoded is Map ? Map<String, dynamic>.from(decoded) : {};
  }

  static DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString())?.toUtc();

  /// فیلدهای بدون مقدار را پیش از ارسال حذف می‌کند تا payload شبکه فقط داده واقعی داشته باشد.
  static Map<String, dynamic> _removeNullValues(Map<String, dynamic> source) {
    final Map<String, dynamic> result = <String, dynamic>{};
    for (final MapEntry<String, dynamic> entry in source.entries) {
      final dynamic value = entry.value;
      if (value == null) continue;
      if (value is Map) {
        result[entry.key] = _removeNullValues(Map<String, dynamic>.from(value));
      } else if (value is List) {
        result[entry.key] = value
            .where((dynamic item) => item != null)
            .map((dynamic item) => item is Map ? _removeNullValues(Map<String, dynamic>.from(item)) : item)
            .toList(growable: false);
      } else {
        result[entry.key] = value;
      }
    }
    return result;
  }
}
