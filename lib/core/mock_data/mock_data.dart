import 'package:dynamic_app/core/config/strings.dart';
import 'package:dynamic_app/shared/orders/domain/entities/address_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/brand_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

class MockData {
  List<ProductEntity> products() {
    List<ProductEntity> list = [];
    for (int i = 0; i < 25; i++) {
      list.add(
        ProductEntity(
          id: 20481188,
          categoryId: 18,
          titleFa: ss.sampleProductTitle,
          titleEn:
              'Apple iPhone 17 Pro Max ZAA Single SIM + eSim Storage 256GB And RAM 12GB Mobile Phone - Not Activated',
          categoryTitle: ss.mobilePhone,
          brand: const BrandEntity(id: 0, titleFa: '', titleEn: ''),

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
            name: ss.digikala,
            satisfactionPercent: 100, // 5 ستاره → 100٪
            performance: ss.excellent,
          ),

          // Inventory
          available: true,
          remainedCount: 1,

          // Colors
          colors: [
            ProductColorEntity(id: '17', title: ss.orange, hexColor: '#FFA501'),
            const ProductColorEntity(
              id: '42',
              title: '42',
              hexColor: '#000000',
            ),
            const ProductColorEntity(
              id: '12',
              title: '12',
              hexColor: '#000000',
            ),
          ],
          selectedColor: ProductColorEntity(
            id: '17',
            title: ss.orange,
            hexColor: '#FFA501',
          ),

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
            color: ProductColorEntity(
              id: '17',
              title: ss.orange,
              hexColor: '#FFA501',
            ),
            themes: [
              ProductThemeEntity(
                title: ss.orange,
                type: 'colored',
                isMain: true,
              ),
            ],
            seller: SellerEntity(
              name: ss.digikala,
              satisfactionPercent: 100,
              performance: ss.excellent,
            ),
            digiplus: DigiplusEntity(
              services: [
                ss.freeDigikalaShipping,
                ss.supermarketShipping,
                ss.freeFortyFiveMinuteShipping,
                ss.dedicatedSupport,
                ss.fastTehranShipping,
              ],
              isJetEligible: true,
              fastShippingText: ss.fastDigikalaShipping,
            ),
            insurance: const InsuranceEntity(
              title: 'digitalInsurance',
              price: 60390000,
              selected: false,
            ),
            badges: [
              VariantBadgeEntity(
                text: ss.onlyOneItemLeft,
                textColor: '#d32f2f',
                icon:
                    'https://dkstatics-public.digikala.com/digikala-static/54419b9303246cde131fcb5b251b86f2ab4aeb71_1716833765.svg',
              ),
            ],
            statistics: const VariantStatisticsEntity(
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
          insurance: const InsuranceEntity(
            title: 'digitalInsurance',
            price: 60390000,
            selected: false,
          ),

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
        ),
      );
    }
    return list;
  }

  List<AddressEntity> addressList() {
    List<AddressEntity> list = [];

    list.add(
      AddressEntity(
        id: 'mock-1',
        province: ss.lorestan,
        city: ss.borujerd,
        addressLine: ss.sampleBorujerdAddress,
      ),
    );

    list.add(
      AddressEntity(
        id: 'mock-2',
        province: ss.tehran,
        city: ss.tehran,
        addressLine: ss.sampleTehranAddress,
      ),
    );

    return list;
  }
}
