import 'package:dynamic_app/shared/address/domain/entities/address_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_in_cart_entity.dart';
import 'package:dynamic_app/shared/user/domain/entities/user_entity.dart';

class MockData {
  List<ProductEntity> products() {
    List<ProductEntity> list = [];
    for (int i = 0; i < 25; i++) {
      list.add(
        const ProductEntity(
          id: 20481188,
          titleFa:
              'گوشی موبایل اپل مدل iPhone 17 Pro Max ZAA تک سیم کارت + eSim ظرفیت 256 گیگابایت و رم 12 گیگابایت - نات اکتیو',
          titleEn:
              'Apple iPhone 17 Pro Max ZAA Single SIM + eSim Storage 256GB And RAM 12GB Mobile Phone - Not Activated',
          categoryTitle: 'گوشی موبایل',
          brandName: 'اپل',

          // Images
          images: [
            'https://dkstatics-public.digikala.com/digikala-products/d530b29693494d25b87bcadcee007922b6393275_1758351222.jpg?x-oss-process=image/resize,m_lfit,h_800,w_800/quality,q_60',
            'https://dkstatics-public.digikala.com/digikala-products/aaebc826ed87800939e145cd74ed3290e0fbdcb8_1758351222.jpg?x-oss-process=image/resize,m_lfit,h_800,w_800/quality,q_60',
            'https://dkstatics-public.digikala.com/digikala-products/3e26debbf8583510216755cab50884ca641daddd_1758351223.jpg?x-oss-process=image/resize,m_lfit,h_800,w_800/quality,q_60',
            // ... بقیه عکس‌ها
          ],
          selectedImageIndex: 0,

          // Rating
          rate: 91.93,
          rateCount: 471,
          commentCount: 0,
          // چون در JSON بخش comments نبود
          questionCount: 0,
          // چون بخش questions نبود

          // Price
          price: 3659990000,
          originalPrice: 3659990000,
          discountPercent: null,

          // Seller (از default_variant_id)
          seller: SellerEntity(
            name: 'دیجی‌کالا',
            satisfactionPercent: 100, // 5 ستاره → 100٪
            performance: 'عالی',
          ),

          // Inventory
          available: true,
          remainedCount: 1,

          // Colors
          colors: [
            ProductColorEntity(id: '17', title: 'نارنجی', hexColor: '#FFA501'),
            ProductColorEntity(id: '42', title: '42', hexColor: '#000000'),
            ProductColorEntity(id: '12', title: '12', hexColor: '#000000'),
          ],
          selectedColor: ProductColorEntity(id: '17', title: 'نارنجی', hexColor: '#FFA501'),

          // Storages (در JSON نبود)
          storages: [],
          selectedStorage: null,

          // Main Variant
          mainVariant: VariantEntity(
            id: 73071289,
            rank: 207.768,
            rate: 91.8,
            available: true,
            orderLimit: 1,
            minOrderLimit: 1,
            remainedCount: 1,
            leadTime: null,
            price: 3659990000,
            originalPrice: 3659990000,
            discountPercent: null,
            color: ProductColorEntity(id: '17', title: 'نارنجی', hexColor: '#FFA501'),
            themes: [ProductThemeEntity(title: 'نارنجی', type: 'colored', isMain: true)],
            seller: SellerEntity(name: 'دیجی‌کالا', satisfactionPercent: 100, performance: 'عالی'),
            digiplus: DigiplusEntity(
              services: [
                '۴ ارسال رایگان دیجیکالا',
                '۲ ارسال سوپرمارکت',
                '۴ ارسال رایگان ۴۵ دقیقه‌ای',
                'پشتیبانی اختصاصی',
                'ارسال سریع و رایگان دیجی‌کالا (فقط تهران و کرج)',
              ],
              isJetEligible: true,
              fastShippingText: 'ارسال سریع دیجی‌کالا',
            ),
            insurance: InsuranceEntity(title: 'digitalInsurance', price: 60390000, selected: false),
            badges: [
              VariantBadgeEntity(
                text: 'تنها 1 عدد در انبار باقی مانده',
                textColor: '#d32f2f',
                icon:
                    'https://dkstatics-public.digikala.com/digikala-static/54419b9303246cde131fcb5b251b86f2ab4aeb71_1716833765.svg',
              ),
            ],
            statistics: VariantStatisticsEntity(
              totalCount: 64,
              totalRate: 91.8,
              totallySatisfiedCount: 49,
              totallySatisfiedRate: 76.56,
            ),
          ),

          // All Variants
          variants: [
            // Variant اول (همان mainVariant)
            // Variant دوم (73084509)
            // اگر بخواهی، می‌سازم
          ],

          // Insurance (از mainVariant)
          insurance: InsuranceEntity(title: 'digitalInsurance', price: 60390000, selected: false),

          // Breadcrumbs
          breadcrumbs: [],

          // Features & Specs (در JSON نبود)
          features: [],
          specifications: [],

          // Review (در JSON نبود)
          review: null,

          // Videos
          videos: [],

          // Comments
          comments: [],

          // Questions
          questions: [],

          // Related
          relatedProducts: [],
        ),
      );
    }
    return list;
  }

  List<AddressEntity> addressList() {
    List<AddressEntity> list = [];

    list.add(
      const AddressEntity(province: 'لرستان', city: 'بروجرد', exactAddress: 'خیابان تختی خیابان زرپرور کوچه شوق پلاک3'),
    );

    list.add(
      const AddressEntity(
        province: 'تهران',
        city: 'تهران',
        exactAddress: 'خیابان جمهوری خیابان سعدی کوچه احمدی پلاک18',
      ),
    );

    return list;
  }

  List<ProductInCartEntity> productInCartList() =>
      products().map((e) => ProductInCartEntity(productEntity: e, selectedCount: e.id)).toList();

  UserEntity user() =>
      const UserEntity(id: 0, email: 'test@gmail.com', firstName: 'بهنام', lastName: 'زادپور', imgPath: '');
}
