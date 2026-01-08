import 'package:dynamic_app/core/util/string_helper.dart';
import 'package:injectable/injectable.dart';

@singleton
@injectable
class CurrencyManager {
  static var currencyToman = 'IRT';
  static var currencyRial = 'IRR';
  static var currencyUSD = 'USD';

  CurrencyManager();

 String getCurrencyUnit() {
    return  currencyToman /*: currencyRial*/;
  }

  getCurrencyCurrencyUnitTitle() {
    return StringHelper.getCurrencyString(getCurrencyUnit());
  }

  currencyFormat(int? price, {String? currentCurrency}) {
    if ((price != null && price < 10) && (currentCurrency == currencyToman || getCurrencyUnit() == currencyToman)) {
      return price.toString();
    }
    return StringHelper.currencyFormat(price, currentCurrency: currentCurrency ?? getCurrencyUnit());
  }

  currencyFormatUsd(int? price) {
    return StringHelper.currencyFormat(price, currentCurrency: currencyUSD);
  }

  currencyFormatWithCurrencyUnit(int? price, {String? currentCurrency}) {
    return StringHelper.currencyFormatWithCurrencyUnit(price, currentCurrency: currentCurrency ?? getCurrencyUnit());
  }


}
