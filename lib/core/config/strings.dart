import 'package:dynamic_app/di/injection_container.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Strings {
  String get dynamicApp => 'dynamicApp';

  String get hour => 'ساعت';

  String get rial => 'ریال';

  String get toman => 'تومان';

  String get themeModeSystem => 'مطابق با دستگاه';

  String get themeModeLight => 'روشن';

  String get no => 'نه';

  String get yes => 'بله';

  String get tryAgain => 'تلاش مجدد';

  String get errorFetchInformation => 'خطا در دریافت اطلاعات';

  String get pleaseWait => 'در حال بررسی اطلاعات';

  String get themeModeDark => 'تاریک';

  String get retryMessage => 'مجدد تلاش نمایید یا زمان دیگری امتحان کنید';

  String get fetchingData => 'در حال دریافت اطلاعات';
}

/// ss = String s
Strings ss = inject<Strings>();
