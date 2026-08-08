import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

/// ویژگی‌های محصول با این نگاشت، نمای غیرقیمتی زمان تعامل را می‌سازند.
extension ProductBehaviorSnapshotMapper on ProductEntity {
  BehaviorProductSnapshot toBehaviorSnapshot() {
    final List<String> variantNames = <String>[
      if (selectedColor?.title.isNotEmpty == true) selectedColor!.title,
      if (selectedStorage?.title.isNotEmpty == true) selectedStorage!.title,
    ];
    return BehaviorProductSnapshot(
      productId: id.toString(),
      productName: titleFa,
      productTitle: titleFa,
      categoryId: categoryId.toString(),
      categoryName: categoryTitle,
      categoryHierarchy: breadcrumbs
          .map((BreadcrumbEntity item) => '${item.id}:${item.title}')
          .toList(growable: false),
      brandId: brand.id.toString(),
      brandName: brand.titleFa,
      aggregateRating: rate,
      aggregateRatingCount: rateCount,
      selectedVariantId: mainVariant?.id.toString(),
      selectedVariantName: variantNames.isEmpty
          ? null
          : variantNames.join(' / '),
    );
  }
}

/// صفحات دسته‌بندی با این mapper شناسه و نام دسته را داخل event ثبت می‌کنند.
extension CategoryBehaviorSnapshotMapper on CategoryEntity {
  BehaviorProductSnapshot toBehaviorSnapshot() {
    return BehaviorProductSnapshot(
      categoryId: id.toString(),
      categoryName: name,
      categoryHierarchy: [name],
    );
  }
}
