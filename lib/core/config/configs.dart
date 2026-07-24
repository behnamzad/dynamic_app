import 'package:dynamic_app/di/injection_container.dart';
import 'package:dynamic_app/flavors.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Configs {
  static const List<CategoryEntity> defaultCategories = [
    CategoryEntity(
      id: 11,
      name: 'موبایل',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/5af568b4909435c6a215ad5e728e902db234b673_1736597759.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
    CategoryEntity(
      id: 5966,
      name: 'کالای دیجیتال',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/1ca8e3bccef6df1365b980416e24c15c8f96dd1a_1754244178.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
    CategoryEntity(
      id: 5967,
      name: 'خانه و آشپزخانه',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/301b461a3aadf28262f1d7e7f0f57e7e6bbed1eb_1700650415.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
    CategoryEntity(
      id: 5968,
      name: 'آرایشی بهداشتی',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/4f9e4d4972d7878c553096e7456e2ee1d1da4bed_1754245493.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
    CategoryEntity(
      id: 10688,
      name: 'خودرو و موتورسیکلت',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/3fe3186f389fc2d02c948b6fad9900c8ebd37cfd_1675754986.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
    CategoryEntity(
      id: 8450,
      name: 'ابزارآلات و تجهیزات',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/b075b01443d47176a5c0164d0d8d05f06a874399_1754249047.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
    CategoryEntity(
      id: 8,
      name: 'کتاب و هنر',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/f6be636dfd43299545884515c9007c73fac9c6cf_1685210449.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
    CategoryEntity(
      id: 6124,
      name: 'ورزش و سفر',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/3ce5c403bb6f72aa967bf79850a1100321695995_1672465445.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
    CategoryEntity(
      id: 8895,
      name: 'سوپر مارکت آنلاین',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/43f283f01eb2da7b5c64b028d0b7658d352d71bb_1730896615.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
    CategoryEntity(
      id: 6741,
      name: 'اسباب بازی، کودک و نوزاد',
      imageUrl:
          'https://dkstatics-public.digikala.com/digikala-products/91307c19429c7b5bbec2249d1353af2c018a7427_1702724910.jpg?x-oss-process=image/resize,m_lfit,h_350,w_350/quality,q_60',
    ),
  ];

  bool get isActiveOtpDialogInPayment => F.isGooglePlay ? true : false;

  bool get isActiveOtpDialogInResetUserPass => F.isGooglePlay ? true : false;

  bool get isActiveOtpDialogInAppActivation => F.isGooglePlay ? true : false;

  bool get isActiveOtpDialogInWithdrawWallet => F.isGooglePlay ? true : false;

  String get oneApiToken => '747841:6a47ecc14dfd6';

  List<String> get homeImageSliderPath => [
    'assets/images/banner_1.png',
    'assets/images/banner_2.png',
    'assets/images/banner_3.png',
  ];
}

/// cs = Config s
Configs cs = inject<Configs>();
