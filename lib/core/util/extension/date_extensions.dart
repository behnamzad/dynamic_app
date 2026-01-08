import 'package:shamsi_date/shamsi_date.dart';

extension JalaliExtension on Jalali? {
  bool get isToday {
    final Jalali now = Jalali.now();

    return this?.distanceFrom(now) == 0;
  }

  bool get isYesterday {
    final Jalali yesterday = Jalali.now().addDays(-1);

    return this?.distanceFrom(yesterday) == 0;
  }

  bool get isTheDayBeforeYesterday {
    final Jalali theDayBeforeYesterday = Jalali.now().addDays(-2);

    return this?.distanceFrom(theDayBeforeYesterday) == 0;
  }
}
