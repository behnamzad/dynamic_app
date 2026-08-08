/// نمای غیرقیمتی محصول، دسته و برند در لحظه تعامل؛ ثبت‌کننده ذخیره و پایتون برای ساخت ویژگی مصرف می‌کند.
class BehaviorProductSnapshot {
  const BehaviorProductSnapshot({
    this.productId,
    this.productName,
    this.categoryId,
    this.categoryName,
    this.categoryHierarchy = const [],
    this.brandId,
    this.brandName,
    this.productTitle,
    this.productTags = const [],
    this.aggregateRating,
    this.aggregateRatingCount,
    this.behavioralPopularity,
    this.selectedVariantId,
    this.selectedVariantName,
  });

  final String? productId;
  final String? productName;
  final String? categoryId;
  final String? categoryName;
  final List<String> categoryHierarchy;
  final String? brandId;
  final String? brandName;
  final String? productTitle;
  final List<String> productTags;
  final double? aggregateRating;
  final int? aggregateRatingCount;
  final double? behavioralPopularity;
  final String? selectedVariantId;
  final String? selectedVariantName;

  Map<String, dynamic> toJson() => {
    if (productId != null) 'product_id': productId,
    if (productName != null) 'product_name': productName,
    if (categoryId != null) 'category_id': categoryId,
    if (categoryName != null) 'category_name': categoryName,
    if (categoryHierarchy.isNotEmpty) 'category_hierarchy': categoryHierarchy,
    if (brandId != null) 'brand_id': brandId,
    if (brandName != null) 'brand_name': brandName,
    if (productTitle != null) 'product_title': productTitle,
    if (productTags.isNotEmpty) 'product_tags': productTags,
    if (aggregateRating != null) 'aggregate_rating': aggregateRating,
    if (aggregateRatingCount != null) 'aggregate_rating_count': aggregateRatingCount,
    if (behavioralPopularity != null) 'behavioral_popularity': behavioralPopularity,
    if (selectedVariantId != null) 'selected_variant_id': selectedVariantId,
    if (selectedVariantName != null) 'selected_variant_name': selectedVariantName,
  };

  factory BehaviorProductSnapshot.fromJson(Map<String, dynamic> json) {
    return BehaviorProductSnapshot(
      productId: json['product_id']?.toString(),
      productName: json['product_name']?.toString(),
      categoryId: json['category_id']?.toString(),
      categoryName: json['category_name']?.toString(),
      categoryHierarchy: _stringList(json['category_hierarchy']),
      brandId: json['brand_id']?.toString(),
      brandName: json['brand_name']?.toString(),
      productTitle: json['product_title']?.toString(),
      productTags: _stringList(json['product_tags']),
      aggregateRating: _double(json['aggregate_rating']),
      aggregateRatingCount: _int(json['aggregate_rating_count']),
      behavioralPopularity: _double(json['behavioral_popularity']),
      selectedVariantId: json['selected_variant_id']?.toString(),
      selectedVariantName: json['selected_variant_name']?.toString(),
    );
  }

  static List<String> _stringList(dynamic value) =>
      value is List ? value.map((dynamic item) => item.toString()).toList(growable: false) : const [];

  static int? _int(dynamic value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');

  static double? _double(dynamic value) => value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '');
}
