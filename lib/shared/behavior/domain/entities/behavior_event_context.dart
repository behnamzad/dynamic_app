/// اطلاعات زمینه‌ای اجرا مانند پلتفرم، زبان و آزمایش؛ ثبت‌کننده آن را به همه رویدادها اضافه می‌کند.
class BehaviorEventContext {
  const BehaviorEventContext({
    required this.platform,
    this.locale,
    this.isOnline,
    this.timeZoneOffsetMinutes,
    this.experimentId,
    this.cohortId,
  });

  final String platform;
  final String? locale;
  final bool? isOnline;
  final int? timeZoneOffsetMinutes;
  final String? experimentId;
  final String? cohortId;

  Map<String, dynamic> toJson() => {
    'platform': platform,
    if (locale != null) 'locale': locale,
    if (isOnline != null) 'is_online': isOnline,
    if (timeZoneOffsetMinutes != null)
      'time_zone_offset_minutes': timeZoneOffsetMinutes,
    if (experimentId != null) 'experiment_id': experimentId,
    if (cohortId != null) 'cohort_id': cohortId,
  };

  factory BehaviorEventContext.fromJson(Map<String, dynamic> json) {
    return BehaviorEventContext(
      platform: json['platform']?.toString() ?? 'unknown',
      locale: json['locale']?.toString(),
      isOnline: json['is_online'] as bool?,
      timeZoneOffsetMinutes: (json['time_zone_offset_minutes'] as num?)
          ?.toInt(),
      experimentId: json['experiment_id']?.toString(),
      cohortId: json['cohort_id']?.toString(),
    );
  }
}
