import 'package:dynamic_app/core/util/currency_manager.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:shamsi_date/shamsi_date.dart';

extension StringExt on String? {
  String replaceFarsiNumberCharacters() {
    String output = this ?? '';
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(farsi[i], english[i]);
    }

    return output;
  }

  String? removeDotZero() {
    double fractionValue = double.tryParse(this ?? '') ?? 0;
    int rounded = fractionValue.round();

    if (fractionValue == rounded) {
      return this?.contains('.') == true ? this?.replaceAll(RegExp(r'([.]*0|[.]*00|[.]*000)(?!.*\d)'), '') : this;
    } else {
      return this;
    }
  }

  String toMobilePhoneNumberFormat() {
    final value = this ?? '';
    if (value.startsWith('+98')) {
      return value.replaceRange(0, 3, '0');
    }
    return value;
  }

  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  bool get isNotNullOrBlank => !isNullOrBlank;

  String cryptoOverflowText() {
    String start = this?.substring(0, 7) ?? '';
    String end = this?.substring((this ?? '').length - 7) ?? '';

    return '$start...$end';
  }

  String toEnglishNumbers() {
    String str = this ?? '';
    str = str.replaceAll('١', '1');
    str = str.replaceAll('٢', '2');
    str = str.replaceAll('٣', '3');
    str = str.replaceAll('٤', '4');
    str = str.replaceAll('٥', '5');
    str = str.replaceAll('٦', '6');
    str = str.replaceAll('٧', '7');
    str = str.replaceAll('٨', '8');
    str = str.replaceAll('٩', '9');
    str = str.replaceAll('٠', '0');
    str = str.replaceAll('۱', '1');
    str = str.replaceAll('۲', '2');
    str = str.replaceAll('۳', '3');
    str = str.replaceAll('۴', '4');
    str = str.replaceAll('۵', '5');
    str = str.replaceAll('۶', '6');
    str = str.replaceAll('۷', '7');
    str = str.replaceAll('۸', '8');
    str = str.replaceAll('۹', '9');
    str = str.replaceAll('۰', '0');
    return str;
  }

  String toNumberWithStar() {
    String str = this ?? '';
    str = this!.replaceRange(4, 8, '****');
    return str;
  }

  bool isPersianCharacter() {
    RegExp persianLanguage = RegExp(r'^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F\u06A9\u06AF\u06BE]+');
    return persianLanguage.hasMatch(this!);
  }

  String get toFulCurrencyFormat {
    if (isNullOrBlank) return '';

    // just number
    final cleanedValue = this!.replaceAll(RegExp(r'\D'), '');

    final parsedValue = int.tryParse(cleanedValue) ?? 0;
    return isNullOrBlank
        ? ''
        : '${inject<CurrencyManager>().currencyFormat(parsedValue)} ${inject<CurrencyManager>().getCurrencyCurrencyUnitTitle()}';
  }

  bool get isNullOrZeroOrEmpty => isNullOrBlank || this == '0';

  bool get isNotNullOrZeroOrEmpty => !isNullOrZeroOrEmpty;

  bool get isNumeric {
    if (this != null && this!.isEmpty) return false;
    return int.tryParse(this!) != null || double.tryParse(this!) != null;
  }
}

extension DateExt on Jalali {
  String dateTimeString() {
    return "$year/$month/$day - ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  String yearMonth() {
    return "${year.toString().substring(2)}/${month.toString().padLeft(2, '0')}";
  }

  String yearMonthDay() {
    return "${year.toString()}/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}";
  }
}
