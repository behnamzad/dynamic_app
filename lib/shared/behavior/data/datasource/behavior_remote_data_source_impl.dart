import 'package:dynamic_app/shared/behavior/data/models/behavior_event_dto.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/repository/behavior_event_uploader.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// خطای قابل‌شناسایی sync؛ coordinator آن را ثبت می‌کند و eventها را pending نگه می‌دارد.
class BehaviorSyncException implements Exception {
  const BehaviorSyncException(this.message);

  final String message;

  @override
  String toString() => 'BehaviorSyncException: $message';
}

/// بسته‌های درانتظار را بدون تکرار می‌فرستد و پس از موفقیت، همه شناسه‌های همان بسته را تأیید می‌کند.
@LazySingleton(as: BehaviorEventUploader)
class BehaviorRemoteDataSourceImpl implements BehaviorEventUploader {
  BehaviorRemoteDataSourceImpl(this._supabaseClient);

  static const tableName = 'behavior_events';

  final SupabaseClient _supabaseClient;

  @override
  Future<Set<String>> upload(List<BehaviorEvent> events) async {
    if (events.isEmpty) {
      return const {};
    }
    final String? authenticatedUserId = _supabaseClient.auth.currentUser?.id;
    if (authenticatedUserId == null) {
      throw const BehaviorSyncException('An authenticated Supabase user is required for behavior sync');
    }
    if (events.any((BehaviorEvent event) => event.userId != authenticatedUserId)) {
      throw const BehaviorSyncException('A behavior batch contains events not attributable to the current user');
    }

    final List<Map<String, dynamic>> payload = events
        .map((BehaviorEvent event) => BehaviorEventDto(event: event).toRemoteMap())
        .toList(growable: false);
    await _supabaseClient.from(tableName).upsert(payload, onConflict: 'event_id', ignoreDuplicates: true);
    return events.map((BehaviorEvent event) => event.eventId).toSet();
  }
}
