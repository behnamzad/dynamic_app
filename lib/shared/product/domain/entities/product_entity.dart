import 'package:dynamic_app/shared/product/domain/entities/brand_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_specification_entity.dart';

export 'package:dynamic_app/shared/product/domain/entities/product_specification_entity.dart';

class ProductEntity {
  final int id;
  final int categoryId;

  // Basic Info
  final String titleFa;
  final String? titleEn;
  final String categoryTitle;
  // brand
  final BrandEntity brand;



  // Images
  final List<String> images;
  final int selectedImageIndex;

  // Rating
  final double rate;
  final int rateCount;
  final int commentCount;
  final int questionCount;

  // Price
  final int price;
  final int? originalPrice;
  final int? discountPercent;

  // Seller
  final SellerEntity? seller;

  // Inventory & Status
  final bool available;
  final int? remainedCount;

  // Variants
  final List<ProductColorEntity> colors;
  final ProductColorEntity? selectedColor;

  final List<ProductStorageEntity> storages;
  final ProductStorageEntity? selectedStorage;

  // Services
  final VariantEntity? mainVariant;
  final List<VariantEntity> variants;
  final InsuranceEntity? insurance;

  // Content
  final List<BreadcrumbEntity> breadcrumbs;
  final List<ProductFeatureEntity> features;
  final List<ProductSpecificationEntity> specifications;

  // Review
  final ProductReviewEntity? review;

  // Media
  final List<ProductVideoEntity> videos;

  // Comments & Questions
  final List<ProductCommentEntity> comments;
  final List<ProductQuestionEntity> questions;

  const ProductEntity({
    required this.id,
    required this.categoryId,
    required this.titleFa,
    this.titleEn,
    required this.categoryTitle,
    required this.brand,
    required this.images,
    this.selectedImageIndex = 0,
    required this.rate,
    required this.rateCount,
    required this.commentCount,
    required this.questionCount,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.seller,
    required this.available,
    this.remainedCount,
    required this.colors,
    this.selectedColor,
    required this.storages,
    this.selectedStorage,
    required this.variants,
    this.mainVariant,
    this.insurance,
    required this.breadcrumbs,
    required this.features,
    required this.specifications,
    this.review,
    required this.videos,
    required this.comments,
    required this.questions,
  });


}

// ====================== Entity های کمکی ======================


class SellerEntity {
  final String name;
  final double satisfactionPercent;
  final String? performance;

  const SellerEntity({required this.name, required this.satisfactionPercent, this.performance});
}

class ProductColorEntity {
  final String id;
  final String title;
  final String hexColor;
  final bool available;

  const ProductColorEntity({required this.id, required this.title, required this.hexColor, this.available = true});
}

class ProductStorageEntity {
  final String id;
  final String title;

  const ProductStorageEntity({required this.id, required this.title});
}

class VariantEntity {
  final int id;
  final double? rank;
  final double? rate;

  // Status & Availability
  final bool available;
  final int orderLimit;
  final int minOrderLimit;
  final int? remainedCount;
  final int? leadTime;

  // Price
  final int price;
  final int? originalPrice;
  final int? discountPercent;

  // Color & Theme
  final ProductColorEntity color;
  final List<ProductThemeEntity> themes;

  // Seller
  final SellerEntity seller;

  // Services
  final DigiplusEntity? digiplus;
  final InsuranceEntity? insurance;

  // Badges
  final List<VariantBadgeEntity>? badges;

  // Statistics
  final VariantStatisticsEntity? statistics;

  const VariantEntity({
    required this.id,
    this.rank,
    this.rate,
    required this.available,
    required this.orderLimit,
    required this.minOrderLimit,
    this.remainedCount,
    this.leadTime,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    required this.color,
    required this.themes,
    required this.seller,
    this.digiplus,
    this.insurance,
    this.badges,
    this.statistics,
  });
}

// ====================== Entity های مرتبط با Variant ======================

class ProductThemeEntity {
  final String title;
  final String type;
  final bool isMain;

  const ProductThemeEntity({required this.title, required this.type, this.isMain = false});
}

class VariantBadgeEntity {
  final String text;
  final String textColor;
  final String? icon;

  const VariantBadgeEntity({required this.text, required this.textColor, this.icon});
}

class VariantStatisticsEntity {
  final int totalCount;
  final double totalRate;
  final int totallySatisfiedCount;
  final double totallySatisfiedRate;

  const VariantStatisticsEntity({
    required this.totalCount,
    required this.totalRate,
    required this.totallySatisfiedCount,
    required this.totallySatisfiedRate,
  });
}

class DigiplusEntity {
  final List<String> services;
  final bool isJetEligible;
  final String? fastShippingText;

  const DigiplusEntity({required this.services, required this.isJetEligible, this.fastShippingText});
}

class InsuranceEntity {
  final String title;
  final int price;
  final bool selected;

  const InsuranceEntity({required this.title, required this.price, this.selected = false});
}

class BreadcrumbEntity {
  final int id;
  final String title;

  const BreadcrumbEntity({required this.id, required this.title});
}

class ProductFeatureEntity {
  final String title;
  final String value;

  const ProductFeatureEntity({required this.title, required this.value});
}

class ProductReviewEntity {
  final String description;
  final String? shortReview;

  const ProductReviewEntity({required this.description, this.shortReview});
}

class ProductVideoEntity {
  final String url;
  final String thumbnail;

  const ProductVideoEntity({required this.url, required this.thumbnail});
}

class ProductCommentEntity {
  final String id;
  final String userName;
  final double rate;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isBuyer;

  final List<String> pros;
  final List<String> cons;

  final int likeCount;
  final int dislikeCount;

  const ProductCommentEntity({
    required this.id,
    required this.userName,
    required this.rate,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isBuyer=false,
    this.pros = const [],
    this.cons = const [],
    this.likeCount = 0,
    this.dislikeCount = 0,
  });
}

class ProductQuestionEntity {
  final String id;
  final String userName;
  final String question;
  final DateTime createdAt;

  final List<ProductAnswerEntity> answers;

  const ProductQuestionEntity({
    required this.id,
    required this.userName,
    required this.question,
    required this.createdAt,
    this.answers = const [],
  });
}

class ProductAnswerEntity {
  final String id;
  final String userName;
  final String answer;
  final DateTime createdAt;

  const ProductAnswerEntity({required this.id, required this.userName, required this.answer, required this.createdAt});
}
