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

  String get seeMore => 'مشاهده بیشتر';

  String get reviewCount => 'دیدگاه';

  String get description => 'توضیحات';

  String get addToCart => 'افزودن به سبد خرید';

  String get home => 'خانه';

  String get search => 'جستجو';

  String get cart => 'سبد خرید';

  String get addressAndDeliveryTime => 'آدرس و زمان ارسال';

  String get totalCartAmount => 'جمع سبد خرید';

  String get payableAmount => 'مبلغ قابل پرداخت';

  String get setting => 'تنظیمات';

  String get personal => 'شخصی';

  String get checkOut => 'بررسی و ادامه';

  String get continueToByProcess => 'ادامه فرایند خرید';

  String get paymentAndSet => 'پرداخت و ثبت';

  String get sendFromOneDay => 'ارسال از 1 روزکاری دیگر';

  String get product => 'کالا';

  String get sentTo => 'ارسال به';

  String get addAddress => 'افزودن آدرس';

  String get orderSummery => 'سفارش شما';

  String get discount => 'تخفیف';

  String get amount => 'مبلغ';

  String get totalAmount => 'مبلغ کل';

  String get copied => 'کپی شد';

  String get username => 'نام کاربری';

  String get password => 'رمز ورود';

  String get usernameAndPasswordInputError => 'نام کاربری و رمز را به صورت کامل وارد نمایید';

  String get usernameInputError => 'نام کاربری را وارد نمایید';

  String get passwordInputEmptyError => ' رمز را وارد نمایید';

  String get login => 'ورود';

  String get register => 'ثبت نام';

  String get version => 'نسخه';

  String get storeName => 'هوشاپ';

  String get endOfStrings => 'endOfStrings';
}

/// ss = String s
Strings ss = inject<Strings>();
