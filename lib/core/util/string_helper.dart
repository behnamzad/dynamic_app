import 'package:dynamic_app/core/config/strings.dart';
import 'package:intl/intl.dart';

import 'currency_manager.dart';

const currencyToman = "IRT";
const currencyRial = "IRR";
const leftToRightCharacter = "\u200E";

class StringHelper {
  static String addCommaSeparator(int? price) {
    if (price == null) return '';
    return NumberFormat("#,###", "en_US").format(price);
  }

  static String getCurrencyString(String currency) {
    if (currency == currencyToman) return ss.toman;
    if (currency == currencyRial) return ss.rial;
    return currency;
  }

  static String currencyFormat(int? price, {String? currentCurrency}) {
    if (price == null) return '';
    currentCurrency ??= CurrencyManager().getCurrencyUnit();

    return NumberFormat("#,###.#", "en_US").format(currentCurrency == currencyToman ? price ~/ 10 : price);
  }

  //5000000 ==>
  //5 میلیون ریال
  //500 هزار تومان
  static String transferThousandAndMillionToLetter(int? price, {String? currentCurrency}) {
    if (price == null || price == 0) return '';
    currentCurrency ??= CurrencyManager().getCurrencyUnit();
    int _price;
    int _priceLength;
    String _priceString;
    String currencyString = getCurrencyString(currentCurrency);
    if (price.toString().length == 4 && currentCurrency == currencyToman) {
      return "${price.toString().substring(0, price.toString().length - 3)} صد $currencyString";
    } else {
      _price = currentCurrency == currencyToman ? price ~/ 10 : price;
      _priceString = _price.toString();
      _priceLength = _priceString.length;
      if (_priceLength >= 4 && _priceLength <= 6) {
        return "${_priceString.substring(0, _priceLength - 3)} هزار $currencyString";
      } else if (_priceLength >= 7 && _priceLength <= 9) {
        return "${_priceString.substring(0, _priceLength - 6)} میلیون $currencyString";
      } else if (_priceLength > 7) {
        return "${_priceString.substring(0, _priceLength - 9)} میلیارد $currencyString";
      } else {
        return "تعریف نشده!";
      }
    }
  }

  static String currencyFormatWithCurrencyUnit(int? price, {required String? currentCurrency}) {
    if (price == null) return '';
    currentCurrency ??= currencyRial;
    return "${NumberFormat("#,###.#", "en_US").format(currentCurrency == currencyToman ? price ~/ 10 : price)} ${StringHelper.getCurrencyString(currentCurrency)}";
  }

  static int? getValueInCurrentCurrency(String? price, {String? currentCurrency}) {
    if (price == null) return null;
    currentCurrency ??= CurrencyManager().getCurrencyUnit();
    int? value = int.tryParse(price);
    if (value == null) return null;
    int valueInCurrentCurrency = currentCurrency == currencyToman ? value ~/ 10 : value;
    return valueInCurrentCurrency;
  }

  static isEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  static isNotEmpty(String? str) {
    return str != null && str.isNotEmpty;
  }

  static bool isShebaValid(String sheba) {
    if (sheba.length == 26) sheba = sheba.substring(2);
    if (RegExp("\\d+").hasMatch(sheba)) {
      sheba = 'IR $sheba';
      sheba = sheba.substring(4, sheba.length) + sheba.substring(0, 4);
      sheba = sheba.replaceAll("I", '18');
      sheba = sheba.replaceAll("R", "27");
      BigInt bi = BigInt.parse(sheba);
      if (bi % BigInt.from(97) != BigInt.from(1)) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static String getFormattedCardNumber(String cardNumber) {
    return cardNumber.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)}  ").trim();
  }

  static String getFormattedCardNumberForView(String cardNumber) {
    return '$leftToRightCharacter${getFormattedCardNumber(cardNumber)}';
  }

  static String getCurrency(String currency) {
    return currency == currencyToman ? ss.toman : ss.rial;
  }

  static String getShebaId(String sheba) {
    int start = sheba.contains("IR") ? 4 : 2;
    return sheba.substring(start, start + 3); //A1 A2 A3
  }

  static String removeIRFromSheba(String? sheba) {
    if (sheba == null) {
      return "";
    }

    if (!sheba.contains("IR")) {
      return sheba;
    }
    return sheba.substring(2);
  }
}

extension StringUtil on String {
  String toPersianCharacters() {
    String str = this;

    str = str.replaceAll("ك", "ک");
    str = str.replaceAll("دِ", "د");
    str = str.replaceAll("بِ", "ب");
    str = str.replaceAll("زِ", "ز");
    str = str.replaceAll("ذِ", "ذ");
    str = str.replaceAll("شِ", "ش");
    str = str.replaceAll("سِ", "س");
    str = str.replaceAll("ى", "ی");
    str = str.replaceAll("ي", "ی");
    str = str.replaceAll("١", "۱");
    str = str.replaceAll("٢", "۲");
    str = str.replaceAll("٣", "۳");
    str = str.replaceAll("٤", "۴");
    str = str.replaceAll("٥", "۵");
    str = str.replaceAll("٦", "۶");
    str = str.replaceAll("٧", "۷");
    str = str.replaceAll("٨", "۸");
    str = str.replaceAll("٩", "۹");
    str = str.replaceAll("٠", "۰");

    return str;
  }
}
