/// وضعیت محلی ارسال event؛ SQLite و sync coordinator از آن استفاده می‌کنند.
enum BehaviorSyncStatus {
  pending('pending'),
  synced('synced');

  const BehaviorSyncStatus(this.wireName);

  final String wireName;

  static BehaviorSyncStatus fromWireName(String value) {
    return values.firstWhere(
      (BehaviorSyncStatus status) => status.wireName == value,
      orElse: () => BehaviorSyncStatus.pending,
    );
  }
}
