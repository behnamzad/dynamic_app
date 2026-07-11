import 'package:dynamic_app/shared/product/data/models/product/product_dto.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

extension ProductMapperX on ProductDto {
  ProductEntity toEntity() {
    final Variant? mainVariant = _selectMainVariant();

    return ProductEntity(
      id: id,
      titleFa: titleFa,
      titleEn: titleEn,
      categoryTitle: categoryTitle ?? '',
      brandName: brand.titleFa,

      // Images
      images: [images.main, ...?images.imageList],
      selectedImageIndex: 0,

      // Rating
      rate: (rating?.rate.toDouble() ?? 0) / 20,
      rateCount: rating?.count ?? 0,
      commentCount: comments?.count ?? 0,
      questionCount: questions?.count ?? 0,

      // Price
      price: price.sellingPrice,
      originalPrice: price.rrpPrice,
      discountPercent: price.discountPercent,

      // Seller
      seller: mapSeller(mainVariant?.seller),

      // Inventory
      available: status == Status.marketable,
      remainedCount: price.marketableStock,

      // Colors
      colors: _mapColors(),
      selectedColor: _mapSelectedColor(mainVariant),

      // Storages (در JSON وجود ندارد → خالی)
      storages: [],
      selectedStorage: null,

      // Variants
      mainVariant: mapVariant(mainVariant),
      variants: _mapVariants(),

      // Insurance
      insurance: _mapInsurance(mainVariant),

      // Content
      breadcrumbs: breadcrumb.map(mapBreadcrumb).toList(),
      features: [],
      // در JSON وجود ندارد
      specifications: _mapSpecifications(),
      // در JSON وجود ندارد

      // Review
      review: review != null ? mapReview(review!) : null,

      // Media
      videos: videos.map(mapVideo).toList(),

      // Comments
      comments: _mapComments(comments),

      // Questions
      questions: _mapQuestions(questions),

      // Related
      relatedProducts: [],
    );
  }

  // ====================== Helper Methods ======================

  Variant? _selectMainVariant() {
    if (status != Status.marketable) {
      return null;
    }

    if (variants.isEmpty) {
      return defaultVariant;
    }

    return variants.firstWhere((Variant variant) => variant.id == defaultVariantId, orElse: () => variants.first);
  }

  List<VariantEntity> _mapVariants() {
    if (status != Status.marketable) {
      return <VariantEntity>[];
    }

    return variants.map(mapVariant).whereType<VariantEntity>().toList();
  }

  InsuranceEntity? _mapInsurance(Variant? variant) {
    final Insurance? insurance = variant?.insurance;
    return insurance != null ? mapInsurance(insurance) : null;
  }

  List<ProductSpecificationEntity> _mapSpecifications() {
    final List<Attribute> attributes = review?.attributes ?? <Attribute>[];

    if (attributes.isEmpty) {
      return <ProductSpecificationEntity>[];
    }

    return <ProductSpecificationEntity>[
      ProductSpecificationEntity(
        groupTitle: 'مشخصات',
        items: attributes.map((Attribute attribute) {
          return ProductSpecificationItemEntity(title: attribute.title, values: attribute.values);
        }).toList(),
      ),
    ];
  }

  SellerEntity? mapSeller(Seller? seller) {
    return seller != null
        ? SellerEntity(
            name: seller.titleFa,
            satisfactionPercent: seller.stars * 20, // تبدیل 5 ستاره → 100٪
            performance: seller.grade.label,
          )
        : null;
  }

  List<ProductColorEntity> _mapColors() {
    return colors.map((c) {
      return ProductColorEntity(id: c.id.toString(), title: c.title, hexColor: c.hexCode, available: true);
    }).toList();
  }

  ProductColorEntity? _mapSelectedColor(Variant? variant) {
    return variant != null
        ? ProductColorEntity(
            id: variant.color.id.toString(),
            title: variant.color.titleFa,
            hexColor: variant.color.hexCode ?? '#000',
          )
        : null;
  }

  VariantEntity? mapVariant(Variant? v) {
    return v != null
        ? VariantEntity(
            id: v.id,
            rank: v.rank,
            rate: v.rate,
            available: v.status == Status.marketable,
            orderLimit: v.orderLimit,
            minOrderLimit: v.minOrderLimit,
            remainedCount: v.price.marketableStock,
            leadTime: v.leadTime,
            price: v.price.sellingPrice,
            originalPrice: v.price.rrpPrice,
            discountPercent: v.price.discountPercent,
            color: ProductColorEntity(
              id: v.color.id.toString(),
              title: v.color.titleFa,
              hexColor: v.color.hexCode ?? '#000',
            ),
            themes: v.themes.map(mapTheme).toList(),
            seller: mapSeller(v.seller)!,
            digiplus: mapDigiplus(v.digiplus),
            insurance: v.insurance != null ? mapInsurance(v.insurance!) : null,
            badges: v.variantBadges?.map(mapVariantBadge).toList(),
            statistics: v.statistics != null ? mapStatistics(v.statistics!) : null,
          )
        : null;
  }

  InsuranceEntity mapInsurance(Insurance ins) {
    return InsuranceEntity(title: ins.title, price: ins.totalPremium, selected: false);
  }

  BreadcrumbEntity mapBreadcrumb(Breadcrumb b) {
    return BreadcrumbEntity(id: b.id, title: b.titleFa);
  }

  ProductReviewEntity mapReview(Review r) {
    return ProductReviewEntity(description: r.description, shortReview: null);
  }

  ProductVideoEntity mapVideo(Video v) {
    return ProductVideoEntity(url: v.url, thumbnail: v.cover);
  }

  List<ProductCommentEntity> _mapComments(Comments? c) {
    if (c == null) return [];

    return c.latestComments.map((lc) {
      return ProductCommentEntity(
        id: lc.id.toString(),
        userName: lc.userName,
        rate: lc.rate.toDouble(),
        title: '',
        body: lc.body,
        createdAt: lc.createdAt,
        pros: [],
        cons: [],
        likeCount: lc.reactions.likes,
        dislikeCount: lc.reactions.dislikes,
      );
    }).toList();
  }

  List<ProductQuestionEntity> _mapQuestions(Questions? q) {
    if (q == null) return [];

    return q.latestQuestions.map((lq) {
      return ProductQuestionEntity(
        id: lq.text.hashCode.toString(),
        userName: lq.sender,
        question: lq.text,
        createdAt: DateTime.tryParse(lq.createdAt) ?? DateTime.now(),
        answers: lq.lastAnswer != null
            ? [
                ProductAnswerEntity(
                  id: lq.lastAnswer!.id.toString(),
                  userName: lq.lastAnswer!.sender,
                  answer: lq.lastAnswer!.text,
                  createdAt: DateTime.now(),
                ),
              ]
            : [],
      );
    }).toList();
  }

  DigiplusEntity mapDigiplus(Digiplus d) {
    return DigiplusEntity(
      services: d.services.map((s) => s.name).toList(),
      isJetEligible: d.isJetEligible ?? false,
      fastShippingText: d.fastShippingText?.toString(),
    );
  }

  VariantBadgeEntity mapVariantBadge(VariantBadge b) {
    return VariantBadgeEntity(text: b.payload.text, textColor: b.payload.textColor, icon: b.payload.svgIcon);
  }

  VariantStatisticsEntity mapStatistics(Statistics s) {
    return VariantStatisticsEntity(
      totalCount: s.totalCount,
      totalRate: s.totalRate,
      totallySatisfiedCount: s.totallySatisfied?.rateCount ?? 0,
      totallySatisfiedRate: s.totallySatisfied?.rate ?? 0,
    );
  }

  ProductThemeEntity mapTheme(Theme t) {
    return ProductThemeEntity(title: t.value.title, type: t.type, isMain: t.isMain);
  }
}
