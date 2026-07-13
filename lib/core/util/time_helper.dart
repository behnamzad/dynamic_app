import 'package:dynamic_app/core/config/strings.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'extension/date_extensions.dart';

enum DateStatus { fullDate, dayMonthName, monthName }

enum TimeShowType {
  shortDate,
  mounthName,
  shortDateTimeWithWeekday,
  timeWithDay,
  timeWithDayWithHour,
  hour,
  namedTimeWithHour,
  namedTime,
  dayWithMonthName,
  dayMonthNameYear,
  dayMonthNameYearTime,
  shortDateWithTime,
}

class TimeHelper {
  static int getRemainingDays(int expireTimestamp) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final differenceInMilliseconds = expireTimestamp - now;
    final remainingDays = (differenceInMilliseconds / (1000 * 60 * 60 * 24)).floor();
    return remainingDays < 0 ? 0 : remainingDays;
  }

  static int getPastDays(int timestamp) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final differenceInMilliseconds = now - timestamp;
    final pastDays = (differenceInMilliseconds / (1000 * 60 * 60 * 24)).floor();
    return pastDays;
  }

  static int getTimeDifferenceFromNowInSecond(int timestamp) {
    final int timeDifferenceInMilliseconds = DateTime.now().millisecondsSinceEpoch - timestamp;
    final int timeDifferenceInSecond = timeDifferenceInMilliseconds ~/ 1000;
    return timeDifferenceInSecond;
  }

  static int getSecondFromMs(int timestampMs) {
    final int seconds = timestampMs ~/ 1000;
    return seconds;
  }

  static int getMsFromSecond(int timestampS) {
    final int ms = timestampS * 1000;
    return ms;
  }

  String getShamsiDateTimeFromISO8601(DateTime dateTime) {
    // final dateTime = DateTime.parse(receiptDateTime ?? '');
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
    Jalali jalaliDate = Jalali.fromDateTime(date);
    // final formatter = jalaliDate.formatter;
    CustomJalaliFormatter formatter = CustomJalaliFormatter(jalaliDate);
    // String clock = receiptDateTime.split('T')[1].split('.')[0];
    // String jalaliClock = "${clock.split(":")[0]}:${clock.split(":")[1]}";
    String jalaliClock = '${dateTime.hour}:${dateTime.minute}';
    return '${formatter.wN} ${formatter.d} ${formatter.mN} ${formatter.yyyy}  $jalaliClock';
  }

  String getShamsiDateTimeISO8601String(String dateTimeStr, {bool showHour = true}) {
    if (dateTimeStr == '') return '';
    final dateTime = DateTime.parse(dateTimeStr);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
    Jalali jalaliDate = Jalali.fromDateTime(date);
    CustomJalaliFormatter formatter = CustomJalaliFormatter(jalaliDate);
    String clock = dateTimeStr.split('T')[1].split('.')[0];
    String jalaliClock = "${clock.split(":")[0]}:${clock.split(":")[1]}";
    if (showHour) {
      return '${formatter.wN} ${formatter.d} ${formatter.mN} ${formatter.yyyy} ، $jalaliClock';
    } else {
      return '${formatter.wN} ${formatter.d} ${formatter.mN}';
    }
  }

  String parsAnyDateToFarsiJalali(dynamic date, TimeShowType timeType, {bool checkTodayYesterday = false}) {
    DateTime dateTime;
    Jalali? jalaliDateTime;
    try {
      switch (date.runtimeType) {
        case int:
          int dataTimeMillisecond = date;
          dateTime = DateTime.fromMillisecondsSinceEpoch(dataTimeMillisecond);
          jalaliDateTime = Jalali.fromDateTime(DateTime.fromMillisecondsSinceEpoch(dataTimeMillisecond));
          break;
        case DateTime:
          dateTime = date;
          jalaliDateTime = Jalali.fromDateTime(dateTime);
          break;
        case Jalali:
          dateTime = date.toDateTime();
          jalaliDateTime = date;
          break;
        case String:
          dateTime = DateTime.parse(date);
          jalaliDateTime = Jalali.fromDateTime(dateTime);
          break;
        default:
          return '';
      }
    } catch (e) {
      return '';
    }

    if (checkTodayYesterday && jalaliDateTime != null) {
      DateTime now = DateTime.now();

      Jalali today = Jalali.fromDateTime(now);

      Jalali yesterday = today.addDays(-1);

      if (jalaliDateTime.year == today.year && jalaliDateTime.month == today.month && jalaliDateTime.day == today.day) {
        return ss.today;
      } else if (jalaliDateTime.year == yesterday.year &&
          jalaliDateTime.month == yesterday.month &&
          jalaliDateTime.day == yesterday.day) {
        return ss.yesterday;
      }
    }

    CustomJalaliFormatter formatter = CustomJalaliFormatter(jalaliDateTime!);
    String dateString = '${formatter.wN} ${formatter.yyyy}/${formatter.mm}/${formatter.dd}';

    switch (timeType) {
      case TimeShowType.shortDate:
        dateString = '${formatter.yyyy}/${formatter.mm}/${formatter.dd}';
        break;
      case TimeShowType.shortDateTimeWithWeekday:
        dateString = '${formatter.wN} ${formatter.yyyy}/${formatter.mm}/${formatter.d}';
        dateString = dateString.replaceAll(' شنبه', '‌شنبه');
        break;
      case TimeShowType.mounthName:
        var monthFromInput = formatter.mm;
        var curMonth = getCurrentMM();
        dateString = int.parse(monthFromInput) == int.parse(curMonth) ? 'ماه جاری' : formatter.mN;
        break;
      case TimeShowType.timeWithDay:
        bool isEqual = compareDateEquality(dateTime, DateTime.now());
        dateString = isEqual
            ? 'امروز ${formatter.hh}:${formatter.minuteMM}'
            : compareDateWithOneDayDifference(dateTime, DateTime.now())
            ? 'دیروز ${formatter.hh}:${formatter.minuteMM}'
            : '${formatter.yyyy}/${formatter.mm}/${formatter.dd}';
        break;
      case TimeShowType.timeWithDayWithHour:
        dateString = '$dateString ، ${formatter.hh}:${formatter.minuteMM}';
        break;

      case TimeShowType.hour:
        dateString = '${formatter.hh}:${formatter.minuteMM}';
        break;

      case TimeShowType.dayMonthNameYear:
        dateString = '${formatter.d} ${formatter.mN} ${formatter.yyyy}';
        break;

      case TimeShowType.dayMonthNameYearTime:
        dateString = '${formatter.d} ${formatter.mN} ${formatter.yyyy} - ${formatter.hh}:${formatter.minuteMM} ';
        break;

      case TimeShowType.shortDateWithTime:
        dateString = '${formatter.yyyy}/${formatter.mm}/${formatter.dd} - ${formatter.hh}:${formatter.minuteMM} ';
        break;

      case TimeShowType.namedTimeWithHour:
        dateString =
            '${formatter.wN} ${formatter.d} ${formatter.mN} ${formatter.yyyy} ، ${formatter.hh}:${formatter.minuteMM}';
        break;
      case TimeShowType.namedTime:
        dateString = '${formatter.wN} ${formatter.d} ${formatter.mN} ${formatter.yyyy}';
        break;
      case TimeShowType.dayWithMonthName:
        dateString = '${formatter.d} ${formatter.mN}';
        break;
    }
    return dateString;
  }

  Jalali? anyDateTypeToJalali(dynamic date) {
    try {
      if (date is int) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(date);

        return Jalali.fromDateTime(dateTime);
      }

      if (date is DateTime) {
        return Jalali.fromDateTime(date);
      }

      if (date is Jalali) {
        return date;
      }

      if (date is String) {
        final dateTime = DateTime.parse(date);
        return Jalali.fromDateTime(dateTime);
      }

      return Jalali.now();
    } catch (e) {
      return null;
    }
  }

  bool isToday(DateTime dateTime) {
    Jalali? jalaliDate = anyDateTypeToJalali(dateTime);
    if (jalaliDate != null) {
      return jalaliDate.isToday;
    }
    return false;
  }

  bool isYesterday(DateTime dateTime) {
    Jalali? jalaliDate = anyDateTypeToJalali(dateTime);
    if (jalaliDate != null) {
      return jalaliDate.isYesterday;
    }
    return false;
  }

  static String getCurrentMM() {
    var currentMs = DateTime.now().millisecondsSinceEpoch;
    final currentDateTime = DateTime.fromMicrosecondsSinceEpoch(currentMs * 1000);
    Jalali currentDate = Jalali.fromDateTime(currentDateTime);
    final currnetFormatter = currentDate.formatter;
    return currnetFormatter.mm;
  }

  static bool compareDateEquality(DateTime date, DateTime anotherDate) {
    return date.year == anotherDate.year && date.month == anotherDate.month && date.day == anotherDate.day;
  }

  static bool compareDateWithOneDayDifference(DateTime date, DateTime anotherDate) {
    return date.year == anotherDate.year && date.month == anotherDate.month && date.day == anotherDate.day - 1;
  }

  String getDate({required int specificDate, required DateStatus dateStatus}) {
    final dateTime = DateTime.fromMicrosecondsSinceEpoch(specificDate * 1000);
    Jalali date = Jalali.fromDateTime(dateTime);
    String dateString = '';
    if (dateStatus != DateStatus.monthName && date.dayOfYear == Jalali.now().dayOfYear) {
      dateString = 'امروز';
    } else if (dateStatus != DateStatus.monthName && date == Jalali.now().addDays(1)) {
      dateString = 'فردا';
    } else {
      final formatter = date.formatter;
      if (dateStatus == DateStatus.fullDate) {
        dateString = '${formatter.yyyy}/${formatter.mm}/${formatter.dd}';
      } else if (dateStatus == DateStatus.monthName) {
        dateString = formatter.mN;
      } else if (dateStatus == DateStatus.dayMonthName) {
        dateString = '${formatter.d} ${formatter.mN}';
      }
    }
    return dateString;
  }
}

///===============for Custom weekday name============
class CustomJalaliFormatter extends JalaliFormatter {
  const CustomJalaliFormatter(Jalali date) : super(date);

  String get hh {
    final String h = date.hour.toString();
    return h.length == 1 ? '0$h' : h;
  }

  String get minuteMM {
    final String m = date.minute.toString();
    return m.length == 1 ? '0$m' : m;
  }

  @override
  String get wN {
    String originalWeekDay = super.wN;

    if (originalWeekDay == 'دو شنبه' || originalWeekDay == 'چهار شنبه') {
      return originalWeekDay.replaceAll(' ', '');
    } else if (originalWeekDay == 'یک شنبه') {
      originalWeekDay = 'یک‌شنبه';
    } else if (originalWeekDay == 'سه شنبه') {
      originalWeekDay = 'سه‌شنبه';
    } else if (originalWeekDay == 'پنج شنبه') {
      originalWeekDay = 'پنج‌شنبه';
    }
    return originalWeekDay;
  }

  int _dateToComparable(String? jalaliDateString) {
    if (jalaliDateString == null || jalaliDateString.isEmpty) return 0;

    try {
      // اگه فرمت "yyyy/mm/dd - HH:mm" باشه، فقط بخش تاریخ رو جدا می‌کنیم
      final datePart = jalaliDateString.contains('-') ? jalaliDateString.split('-')[0].trim() : jalaliDateString.trim();

      final parts = datePart.split('/');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      return year * 10000 + month * 100 + day; //sample return 14030802
    } catch (e) {
      return 0;
    }
  }
}
