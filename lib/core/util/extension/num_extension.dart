import 'dart:math';

import 'package:intl/intl.dart' as intl;

extension NumberExt on num {
  double toRadian() {
    return this * (pi / 180);
  }

  String commaSeparate() {
    final f = intl.NumberFormat('###,###,###,###');
    return f.format(this);
  }
}

extension IntExt on int {
  String convert2Rial() {
    return '${commaSeparate()}\u200cریال';
  }

  String convert2RialWithSpace() {
    return '${commaSeparate()} ریال ';
  }

  String second2Timer() {
    return '${(this ~/ 60).toString().padLeft(2, '0')}:${(this % 60).toInt().toString().padLeft(2, '0')}';
  }

  convert2Word() {
    return _convert(this);
  }

  convert2TomanWord() {
    return '${_convert(this ~/ 10).trim()}تومان ';
  }

  convert2Toman() {
    return '${commaSeparate()} تومان';
  }

  String convert2TomanNumber() {
    String strAnd = ' و ';
    var n = this ~/ 10;

    var million = (n ~/ 1000000);
    var thousand = (n % 1000000 ~/ 1000);
    var hundred = (n % 1000000 % 1000 ~/ 100);

    var millionDisplay = million > 0 ? '$million میلیون' : '';
    var thousandDisplay = thousand > 0 ? '$thousand هزار' : '';
    var hundredDisplay = hundred > 0 ? '$hundred صد' : '';
    var s = millionDisplay +
        (millionDisplay.isNotEmpty ? strAnd : '') +
        thousandDisplay +
        (thousandDisplay.isNotEmpty ? strAnd : '') +
        hundredDisplay +
        (hundredDisplay.isNotEmpty ? strAnd : '');
    return '${s.substring(0, s.length - 2)}تومان';
  }

  String toDurationString() {
    var years = (this ~/ 365);
    var months = (this % 365 ~/ 30);
    var days = (this % 365 % 30).floor();

    var yearsDisplay = years > 0 ? '$years ساله' : '';
    var monthsDisplay = months > 0 ? '$months ماه' : '';
    var daysDisplay = days > 0 ? '$months روز' : '';
    return yearsDisplay + monthsDisplay + daysDisplay;
  }

  String toYearMonthString() {
    if (this < 12) {
      return '$this ماهه';
    } else {
      final years = this ~/ 12;
      final months = this % 12;

      if (months == 0) {
        return '$years ساله';
      } else {
        return '$years سال و $months ماهه';
      }
    }
  }

  String _convert(int i) {
    String strAnd = ' و ';

    if (i < 20) return _units[i];
    if (i < 100) {
      return _decimals[i ~/ 10] + ((i % 10 > 0) ? strAnd + _convert(i % 10) : '');
    }
    if (i < 1000) {
      return _hundreds[(i ~/ 100)] + ((i % 100 > 0) ? strAnd + _convert(i % 100) : '');
    }
    if (i < 1000000) {
      return _convert(i ~/ 1000) + _stepsString(_steps[0]) + ((i % 1000 > 0) ? strAnd + _convert(i % 1000) : '');
    }
    if (i < 1000000000) {
      return _convert(i ~/ 1000000) +
          _stepsString(_steps[1]) +
          ((i % 1000000 > 0) ? strAnd + _convert(i % 1000000) : '');
    }
    return _convert(i ~/ 1000000000) +
        _stepsString(_steps[2]) +
        ((i % 1000000000 > 0) ? strAnd + _convert(i % 1000000000) : '');
  }

  _stepsString(String step) {
    return ' $step ';
  }
}

const _units = [
  'صفر',
  'یک',
  'دو',
  'سه',
  'چهار',
  'پنج',
  'شش',
  'هفت',
  'هشت',
  'نه',
  'ده',
  'یازده',
  'دوازده',
  'سیزده',
  'چهارده',
  'پانزده',
  'شانزده',
  'هفده',
  'هجده',
  'نوزده',
];

const _decimals = ['', '', 'بیست', 'سی', 'چهل', 'پنجاه', 'شصت', 'هفتاد', 'هشتاد', 'نود'];

const _hundreds = ['', 'یکصد', 'دویست', 'سیصد', 'چهارصد', 'پانصد', 'ششصد', 'هفتصد', 'هشتصد', 'نهصد'];

const _steps = [
  'هزار',
  'میلیون',
  'میلیارد',
  'تریلیون',
  'کادریلیون',
  'کوینتریلیون',
  'سکستریلیون',
  'سپتریلیون',
  'اکتریلیون',
  'نونیلیون',
  'دسیلیون',
];

extension NumDurationExtensions on num {
  Duration get microseconds => Duration(microseconds: round());

  Duration get ms => (this * 1000).microseconds;

  Duration get milliseconds => (this * 1000).microseconds;

  Duration get seconds => (this * 1000 * 1000).microseconds;

  Duration get minutes => (this * 1000 * 1000 * 60).microseconds;

  Duration get hours => (this * 1000 * 1000 * 60 * 60).microseconds;

  Duration get days => (this * 1000 * 1000 * 60 * 60 * 24).microseconds;
}
