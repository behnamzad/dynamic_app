import 'package:dynamic_app/di/injection_container.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Strings {
  String get generalError => 'خطا!';

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

  String get question => 'پرسش و پاسخ';

  String get review => 'دیدگاه';

  String rateCount(int count) => 'امتیاز $count خریدار';

  String commentCount(int count) => '$count دیدگاه';

  String questionCount(int count) => '$count پرسش';

  String satisfaction(int percent, String performance) =>
      '$percent٪ رضایت | $performance';

  String buyersOpinionCount(int count) => '(بر اساس نظر $count خریدار)';

  String get description => 'توضیحات';

  String get addToCart => 'افزودن به سبد خرید';

  String get removeFromCart => 'حذف از سبد خرید';

  String get productAddedToCart => 'محصول به سبد خرید اضافه شد.';

  String get productRemovedFromCart => 'محصول از سبد خرید حذف شد.';

  String get cartOperationError => 'عملیات سبد خرید انجام نشد. دوباره تلاش کن.';

  String get cartFetchError => 'دریافت سبد خرید انجام نشد.';

  String get userNotLoggedIn => 'کاربر وارد حساب نشده است.';

  String get home => 'خانه';

  String get search => 'جستجو';

  String get searchHint => 'جستجوی محصول یا برند';

  String get searchStartMessage => 'نام محصول یا برند موردنظر را جستجو کنید';

  String get searchEmptyMessage => 'نتیجه‌ای برای این جستجو پیدا نشد';

  String get brands => 'برندها';

  String get cart => 'سبد خرید';

  String get addressAndDeliveryTime => 'آدرس و زمان ارسال';

  String get totalCartAmount => 'جمع سبد خرید';

  String get payableAmount => 'مبلغ قابل پرداخت';

  String get setting => 'تنظیمات';

  String get contactUs => 'تماس با ما';

  String get shareApp => 'اشتراک‌گذاری اپ';

  String get help => 'راهنما';

  String get logout => 'خروج از حساب';

  String get exitDescription => 'آیا می‌خواهید از برنامه خارج شوید؟';

  String get personal => 'شخصی';

  String get checkOut => 'بررسی و ادامه';

  String get continueToByProcess => 'ادامه فرایند خرید';

  String get paymentAndSet => 'پرداخت و ثبت';

  String get sendFromOneDay => 'ارسال از 1 روزکاری دیگر';

  String get product => 'کالا';

  String productIdValue(int id) => 'شناسه محصول: $id';

  String categoryIdValue(int id) => 'شناسه دسته‌بندی: $id';

  String quantityValue(int quantity) => 'تعداد: $quantity';

  String cartProductsCount(int count) => '$count کالا';

  String get sentTo => 'ارسال به';

  String get addAddress => 'افزودن آدرس';

  String get deleteAddress => 'حذف آدرس';

  String get deleteAddressQuestion => 'این آدرس حذف شود؟';

  String get addressAdded => 'آدرس اضافه شد.';

  String get addressDeleted => 'آدرس حذف شد.';

  String get noAddress => 'آدرسی ثبت نشده است. یک آدرس اضافه کنید.';

  String get addressFieldsRequired => 'تمام بخش‌های آدرس را کامل کنید.';

  String get addressRequiredForOrder => 'برای ثبت سفارش یک آدرس انتخاب کنید.';

  String get province => 'استان';

  String get city => 'شهر';

  String get addressLine => 'ادامه آدرس';

  String get cancel => 'انصراف';

  String get saveAddress => 'ثبت آدرس';

  String get delete => 'حذف';

  String get orders => 'سفارش‌ها';

  String get noOrders => 'هنوز سفارشی ثبت نشده است.';

  String get paid => 'پرداخت‌شده';

  String get unpaid => 'پرداخت‌نشده';

  String get orderStatusProcessing => 'در حال آماده‌سازی';

  String get orderStatusShipping => 'در حال ارسال';

  String get orderStatusDelivered => 'ارسال‌شده';

  String get orderStatusCancelled => 'لغوشده';

  String get finalOrderReview => 'بازبینی نهایی سفارش';

  String get orderPaymentSuccess => 'پرداخت انجام شد و سفارش ثبت گردید.';

  String get checkoutDeliveryWindow => 'شنبه یک فروردین - ۱۴ الی ۱۸';

  String provinceAndCity(String province, String city) => '$province، $city';

  String fullAddress(String province, String city, String addressLine) =>
      '$province، $city - $addressLine';

  String orderProductsCount(int count) => 'محصولات سفارش ($count کالا)';

  String get orderSummery => 'سفارش شما';

  String get discount => 'تخفیف';

  String get amount => 'مبلغ';

  String get totalAmount => 'مبلغ کل';

  String get copied => 'کپی شد';

  String get username => 'نام کاربری';

  String get email => 'ایمیل';

  String get age => 'سن';

  String get gender => 'جنسیت';

  String get male => 'آقا';

  String get female => 'خانم';

  String get unknown => 'نامشخص';

  String get password => 'رمز ورود';

  String get usernameAndPasswordInputError =>
      'نام کاربری و رمز را به صورت کامل وارد نمایید';

  String get usernameInputError => 'نام کاربری را وارد نمایید';

  String get passwordInputEmptyError => ' رمز را وارد نمایید';

  String get login => 'ورود';

  String get register => 'ثبت نام';

  String get doNotHaveAccount => 'حساب کاربری نداری؟';

  String get haveAccountLogin => 'حساب کاربری داری؟ ورود';

  String get version => 'نسخه';

  String get storeName => 'هوشاپ';

  String get profile => 'پروفایل';

  String get storeUser => 'کاربر فروشگاه';

  String get emailNotRegistered => 'ایمیل ثبت نشده';

  String get userInformation => 'اطلاعات کاربر';

  String get accountInformation => 'اطلاعات حساب کاربری';

  String get userId => 'شناسه کاربر';

  String get emailStatus => 'وضعیت ایمیل';

  String get verified => 'تأیید شده';

  String get notVerified => 'تأیید نشده';

  String get lastLogin => 'آخرین ورود';

  String get specifications => 'مشخصات';

  String get color => 'رنگ';

  String get seller => 'فروشنده';

  String get userReviews => 'دیدگاه کاربران';

  String get buyersReviewsSummary => 'خلاصه دیدگاه‌های خریداران';

  String get unavailable => 'ناموجود';

  String get productCategory => 'دسته‌بندی محصولات';

  String get sampleDeliveryTime => 'شنبه یک فروردین، ساعت ۱۴ تا ۱۸';

  String get hello => 'سلام';

  String get productNotProvided =>
      'محصول یا شناسه محصول به صفحه ارسال نشده است.';

  String get loginSuccess => 'ورود با موفقیت انجام شد.';

  String get registerSuccess => 'ثبت‌نام با موفقیت انجام شد.';

  String get invalidLoginCredentials => 'ایمیل یا رمز عبور اشتباه است.';

  String get weakPassword => 'رمز عبور باید حداقل ۶ کاراکتر باشد.';

  String get emailAlreadyRegistered => 'این ایمیل قبلاً ثبت شده است.';

  String get usernameAlreadyTaken => 'این نام کاربری قبلاً استفاده شده است.';

  String get emptyRequiredInputs => 'اطلاعات لازم را کامل وارد کن.';

  String get emptyLoginInputs => 'ایمیل و رمز عبور را وارد کن.';

  String get emptyRegisterInputs =>
      'ایمیل، نام کاربری، رمز عبور، سن و جنسیت را کامل وارد کن.';

  String get emptyGender => 'جنسیت را انتخاب کن.';

  String get invalidAge => 'سن را به‌صورت عدد معتبر وارد کن.';

  String get invalidEmail => 'فرمت ایمیل معتبر نیست.';

  String get networkError => 'اتصال اینترنت را بررسی کن و دوباره تلاش کن.';

  String get authServerUnavailable => 'سرویس ورود موقتاً در دسترس نیست.';

  String get unknownError => 'خطای نامشخصی رخ داد. دوباره تلاش کن.';

  String get internetConnectionError => 'خطا در اتصال به اینترنت';

  String get serverConnectionError => 'خطا در اتصال به سرور';

  String get paymentTimeoutError =>
      'خطا در انجام تراکنش! لطفاً قبل از تکرار تراکنش، موجودی حساب خود را بررسی کنید.';

  String get timeoutError => 'پاسخی در زمان مناسب از سمت سرور دریافت نشد';

  String get connectionClosedError => 'ارتباط با سرور قطع شد.';

  String get smartStore => 'فروشگاه هوشمند';

  String get undefined => 'تعریف نشده!';

  String get hundred => 'صد';

  String get thousand => 'هزار';

  String get million => 'میلیون';

  String get billion => 'میلیارد';

  String get and => ' و ';

  String rialAmount(String value) => '$value ریال';

  String tomanAmount(String value) => '$value تومان';

  String hundredAmount(String value, String currency) =>
      '$value $hundred $currency';

  String thousandAmount(String value, String currency) =>
      '$value $thousand $currency';

  String millionAmount(String value, String currency) =>
      '$value $million $currency';

  String billionAmount(String value, String currency) =>
      '$value $billion $currency';

  String yearsOld(num value) => '$value ساله';

  String months(num value) => '$value ماه';

  String monthsOld(num value) => '$value ماهه';

  String days(num value) => '$value روز';

  String yearsAndMonths(num years, num months) => '$years سال و $months ماهه';

  List<String> get persianNumberUnits => const [
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

  List<String> get persianNumberTens => const [
    '',
    '',
    'بیست',
    'سی',
    'چهل',
    'پنجاه',
    'شصت',
    'هفتاد',
    'هشتاد',
    'نود',
  ];

  List<String> get persianNumberHundreds => const [
    '',
    'یکصد',
    'دویست',
    'سیصد',
    'چهارصد',
    'پانصد',
    'ششصد',
    'هفتصد',
    'هشتصد',
    'نهصد',
  ];

  List<String> get persianNumberSteps => const [
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

  String get freeDigikalaShipping => '۴ ارسال رایگان دیجیکالا';

  String get dedicatedSupport => 'پشتیبانی اختصاصی';

  String get freeFortyFiveMinuteShipping => '۴ ارسال رایگان ۴۵ دقیقه‌ای';

  String get supermarketShipping => '۲ ارسال سوپرمارکت';

  String get fastTehranShipping =>
      'ارسال سریع و رایگان دیجی‌کالا (فقط تهران و کرج)';

  String get fastDigikalaShipping => 'ارسال سریع دیجی‌کالا';

  String get onlyOneItemLeft => 'تنها ۱ عدد در انبار باقی مانده';

  String get excellent => 'عالی';

  String get orange => 'نارنجی';

  String get digikala => 'دیجی‌کالا';

  String get sampleProductTitle =>
      'گوشی موبایل اپل مدل iPhone 17 Pro Max ZAA تک سیم کارت + eSim ظرفیت 256 گیگابایت و رم 12 گیگابایت - نات اکتیو';

  String get mobilePhone => 'گوشی موبایل';

  String get apple => 'اپل';

  String get lorestan => 'لرستان';

  String get borujerd => 'بروجرد';

  String get sampleBorujerdAddress =>
      'خیابان تختی، خیابان زرپرور، کوچه شوق، پلاک ۳';

  String get tehran => 'تهران';

  String get sampleTehranAddress =>
      'خیابان جمهوری، خیابان سعدی، کوچه احمدی، پلاک ۱۸';

  String get sampleFirstName => 'بهنام';

  String get sampleLastName => 'زادپور';

  String get previousStep => 'بازگشت';

  String get confirmAndContinue => 'تایید و ادامه';

  String get copy => 'کپی';

  String get gotIt => 'فهمیدم';

  String get year => 'سال';

  String get month => 'ماه';

  String get thisMonth => 'ماه جاری';

  String get day => 'روز';

  String get submit => 'تایید';

  String jalaliMonthName(int month) {
    switch (month) {
      case 1:
        return 'فروردین';
      case 2:
        return 'اردیبهشت';
      case 3:
        return 'خرداد';
      case 4:
        return 'تیر';
      case 5:
        return 'مرداد';
      case 6:
        return 'شهریور';
      case 7:
        return 'مهر';
      case 8:
        return 'آبان';
      case 9:
        return 'آذر';
      case 10:
        return 'دی';
      case 11:
        return 'بهمن';
      case 12:
        return 'اسفند';
      default:
        return '$this';
    }
  }

  String gregorianMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '$this';
    }
  }

  String get buyer => 'خریدار';

  String get today => 'امروز';

  String get tomorrow => 'فردا';

  String get yesterday => 'دیروز';

  String get emptyCart => 'سبد خرید شما خالی است';

  String get endOfStrings => 'endOfStrings';
}

/// ss = String s
Strings ss = inject<Strings>();
