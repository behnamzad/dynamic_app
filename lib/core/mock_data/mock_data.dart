import 'package:dynamic_app/data_provider/address/domain/entities/address_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/data_provider/product/domain/entities/product_in_cart_entity.dart';
import 'package:dynamic_app/data_provider/user/domain/entities/user_entity.dart';

class MockData {
  List<ProductEntity> products() {
    List<ProductEntity> list = [];
    for (int i = 0; i < 25; i++) {
      list.add(ProductEntity(
          id: i,
          name: 'گوشی اپل iPhone 16 Pro Max ZAA رجیستر‌شده دو سیم‌کارت 256 گیگابایت با رم 8 گیگابایت',
          reviewCount: 60,
          rate: '4.9',
          amount: '260000000',
          description:
              'آیفون 16 پرو مکس، جدیدترین شاهکار اپل، با طراحی شیک، دوربین‌های بی‌نظیر و عملکردی فوق‌العاده، استانداردهای جدیدی را برای گوشی‌های هوشمند تعریف می‌کند. نمایشگر 6.9 اینچی Super Retina XDR OLED با وضوح بالا و نرخ نوسازی 120 هرتز، تجربه بصری کم‌نظیری را ارائه می‌دهد و بدنه‌ مقاوم از جنس شیشه و تیتانیوم، زیبایی و دوام را در کنار هم به ارمغان می‌آورد. چیپست قدرتمند A18 Bionic با فناوری 3 نانومتری، به کاربران امکان می‌دهد تا بازی‌ها و اپلیکیشن‌های سنگین را به راحتی اجرا کنند. دوربین‌های 48، 12 و 48 مگاپیکسلی این گوشی، به ویژه دوربین تله‌فوتو با زوم 5 برابری اپتیکال، تصاویری خیره‌کننده و ویدیوهایی با کیفیت سینمایی ثبت می‌کنند. باتری 4685 میلی‌آمپر ساعتی با پشتیبانی از شارژ سریع هم به صورت باسیم و هم به صورت بی‌سیم، طول عمر بالایی داشته و شارژدهی بسیار خوبی دارد. همچنین، با iOS 18، تجربه کاربری بهینه‌تر و امنیت بیشتری خواهید داشت. اگر به دنبال بهترین عملکرد و عکاسی حرفه‌ای در یک گوشی هوشمند هستید، آیفون 16 پرو مکس ترکیبی بی‌نظیر از تکنولوژی پیشرفته و طراحی لوکس است که تمام انتظارات شما را برآورده می‌کند. همانطور که می‌دانید گوشی‌های آیفون با پارت نامبرهای مختلفی از جمله CH، ZAA، LLA ،ZPAو ... در بازار وجود دارند. پارت نامبر ZAA مربوط به کشور سنگاپور است. این پارت نامبر هیچ محدودیت نرم افزاری‌ای ندارد و با پشتیبانی از دو سیم‌کارت فیزیکی به صورت همزمان، پارت نامبر بسیار مناسبی است. گفتنی‌ست که این گوشی، مانند تمامی گوشی‌های عرضه‌شده در دیجی‌کالا، به صورت قانونی و تجاری وارد کشور شده و با رجیستر رسمی، کارت گارانتی معتبر و کد فعال‌سازی به شما تحویل داده می‌شود',
          imageUrl: i.isEven
              ? 'https://dkstatics-public.digikala.com/digikala-products/48daaebd4cb7706cce21ce8b5e485d6fdafa6bd1_1736598863.jpg?x-oss-process=image/resize,m_lfit,h_800,w_800/format,webp/quality,q_90'
              : 'https://dkstatics-public.digikala.com/digikala-products/1bb1a43cf9c30ad04558549da1c829130530064e_1753632099.jpg?x-oss-process=image/resize,m_lfit,h_800,w_800/format,webp/quality,q_90'));
    }
    return list;
  }

  List<AddressEntity> addressList() {
    List<AddressEntity> list = [];

    list.add(const AddressEntity(
        province: 'لرستان', city: 'بروجرد', exactAddress: 'خیابان تختی خیابان زرپرور کوچه شوق پلاک3'));

    list.add(const AddressEntity(
        province: 'تهران', city: 'تهران', exactAddress: 'خیابان جمهوری خیابان سعدی کوچه احمدی پلاک18'));

    return list;
  }

  List<ProductInCartEntity> productInCartList() =>
      products().map((e) => ProductInCartEntity(productEntity: e, selectedCount: e.id)).toList();

  UserEntity user() =>
      const UserEntity(id: 0, email: 'test@gmail.com', firstName: 'بهنام', lastName: 'زادپور', imgPath: '');
}
