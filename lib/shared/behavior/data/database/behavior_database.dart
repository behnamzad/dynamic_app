import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

/// مالک اتصال SQLite و migrationها؛ data source محلی از connection آماده‌ی آن استفاده می‌کند.
@lazySingleton
class BehaviorDatabase {
  static const databaseName = 'behavior_events.db';
  static const databaseVersion = 1;
  static const eventsTable = 'behavior_events';

  Database? _database;
  Future<void>? _initializationFuture;

  /// اتصال بازشده را به منبع داده می‌دهد و پیش از آماده‌سازی اجازه استفاده نمی‌دهد.
  Database get database {
    final Database? value = _database;
    if (value == null || !value.isOpen) {
      throw StateError('Behavior database is not initialized');
    }
    return value;
  }

  /// یک‌بار در شروع برنامه فراخوانی می‌شود تا فایل دیتابیس و schema آماده شوند.
  Future<void> initialize() {
    final Database? existing = _database;
    if (existing != null && existing.isOpen) {
      return Future.value();
    }
    return _initializationFuture ??= _open().whenComplete(
      () => _initializationFuture = null,
    );
  }

  Future<void> _open() async {
    final String databasesPath = await getDatabasesPath();
    _database = await openDatabase(
      path.join(databasesPath, databaseName),
      version: databaseVersion,
      onConfigure: (Database database) =>
          database.execute('PRAGMA journal_mode = WAL'),
      onCreate: _createSchema,
      onUpgrade: _upgradeSchema,
    );
  }

  @disposeMethod
  /// هنگام dispose شدن DI، اتصال SQLite را به‌صورت کنترل‌شده می‌بندد.
  Future<void> close() async {
    final Database? database = _database;
    _database = null;
    await database?.close();
  }

  Future<void> _createSchema(Database database, int version) async {
    await database.execute('''
      CREATE TABLE $eventsTable (
        event_id TEXT PRIMARY KEY NOT NULL,
        user_id TEXT NOT NULL,
        anonymous_id TEXT NOT NULL,
        session_id TEXT NOT NULL,
        event_type TEXT NOT NULL,
        event_timestamp TEXT NOT NULL,
        client_generated_at TEXT NOT NULL,
        app_version TEXT NOT NULL,
        schema_version INTEGER NOT NULL,
        is_authenticated INTEGER NOT NULL CHECK (is_authenticated IN (0, 1)),
        product_id TEXT,
        product_name TEXT,
        category_id TEXT,
        category_name TEXT,
        brand_id TEXT,
        brand_name TEXT,
        source_screen TEXT,
        destination_screen TEXT,
        referrer_screen TEXT,
        duration_ms INTEGER CHECK (duration_ms IS NULL OR duration_ms >= 0),
        position INTEGER CHECK (position IS NULL OR position >= 0),
        event_status TEXT,
        subject_snapshot_json TEXT NOT NULL DEFAULT '{}',
        payload_json TEXT NOT NULL DEFAULT '{}',
        context_json TEXT NOT NULL DEFAULT '{}',
        sync_status TEXT NOT NULL DEFAULT 'pending' CHECK (sync_status IN ('pending', 'synced')),
        sync_attempt_count INTEGER NOT NULL DEFAULT 0,
        last_sync_attempt_at TEXT,
        last_sync_error TEXT,
        synced_at TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    await database.execute(
      'CREATE INDEX idx_behavior_events_pending ON $eventsTable(sync_status, created_at)',
    );
    await database.execute(
      'CREATE INDEX idx_behavior_events_user_time ON $eventsTable(user_id, event_timestamp)',
    );
    await database.execute(
      'CREATE INDEX idx_behavior_events_session_time ON $eventsTable(session_id, event_timestamp)',
    );
    await database.execute(
      'CREATE INDEX idx_behavior_events_type_time ON $eventsTable(event_type, event_timestamp)',
    );
    await database.execute(
      'CREATE INDEX idx_behavior_events_product_time ON $eventsTable(product_id, event_timestamp)',
    );
    await database.execute(
      'CREATE INDEX idx_behavior_events_category_time ON $eventsTable(category_id, event_timestamp)',
    );
  }

  Future<void> _upgradeSchema(
    Database database,
    int oldVersion,
    int newVersion,
  ) async {
    // مهاجرت‌های آینده افزایشی و نسخه‌بندی‌شده‌اند و معنای رویدادهای خام را بازنویسی نمی‌کنند.
  }
}
