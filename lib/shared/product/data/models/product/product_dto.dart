// Manual DTOs. No Freezed or generated serialization code is required.

import 'package:dynamic_app/core/config/strings.dart';

T? _asObject<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is Map && value.isNotEmpty) {
    return parser(Map<String, dynamic>.from(value));
  }
  return null;
}

List<T> _asList<T>(Object? value, T Function(Object? value) parser) {
  if (value is! List) return <T>[];
  return value.map(parser).toList();
}

Map<String, T> _asMap<T>(Object? value, T Function(Object? value) parser) {
  if (value is! Map) return <String, T>{};
  return value.map((key, item) => MapEntry(key.toString(), parser(item)));
}

int _asInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String _asString(Object? value) => value?.toString() ?? '';

bool _asBool(Object? value) {
  if (value is bool) return value;
  return value == 1 || value?.toString().toLowerCase() == 'true';
}

DateTime _asDateTime(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);

T? _enumFromJson<T>(List<T> values, Object? value, Map<T, String> mapping) {
  for (final item in values) {
    if (mapping[item] == value || item.toString().split('.').last == value) {
      return item;
    }
  }
  return null;
}

enum MainBadgeType { isIncredible, isPromotion }

enum SubBadgeType { isFastShipping, isShipByDigikala, isShipBySeller, isStock }

enum Status { marketable, outOfStock }

enum Service { freeShipping, dedicatedSupport, fast45, supermarket, fastTehran }

enum Nature { color }

enum DeliveryDay { otherDays, today, tomorrow }

const Map<MainBadgeType, String> _mainBadgeTypeJson = <MainBadgeType, String>{
  MainBadgeType.isIncredible: 'is_incredible',
  MainBadgeType.isPromotion: 'is_promotion',
};

// ignore: unused_element
const Map<SubBadgeType, String> _subBadgeTypeJson = <SubBadgeType, String>{
  SubBadgeType.isFastShipping: 'is_fast_shipping',
  SubBadgeType.isShipByDigikala: 'is_ship_by_digikala',
  SubBadgeType.isShipBySeller: 'is_ship_by_seller',
  SubBadgeType.isStock: 'is_stock',
};

const Map<Status, String> _statusJson = <Status, String>{
  Status.marketable: 'marketable',
  Status.outOfStock: 'out_of_stock',
};

final Map<Service, String> _serviceJson = <Service, String>{
  Service.freeShipping: ss.freeDigikalaShipping,
  Service.dedicatedSupport: ss.dedicatedSupport,
  Service.fast45: ss.freeFortyFiveMinuteShipping,
  Service.supermarket: ss.supermarketShipping,
  Service.fastTehran: ss.fastTehranShipping,
};

const Map<Nature, String> _natureJson = <Nature, String>{Nature.color: 'color'};

const Map<DeliveryDay, String> _deliveryDayJson = <DeliveryDay, String>{
  DeliveryDay.otherDays: 'other_days',
  DeliveryDay.today: 'today',
  DeliveryDay.tomorrow: 'tomorrow',
};

class ProductDto {
  final int id;
  final int categoryId;
  final String titleFa;
  final String titleEn;
  final Brand brand;
  final Status status;
  final Images images;
  final int defaultVariantId;
  final int secondDefaultVariantId;
  final Parameters parameters;
  final String productType;
  final ProductProperties properties;
  final ProductPrice price;
  final List<Media> media;
  final Digiplus digiplus;
  final ProductBadge productBadge;
  final String? categoryTitle;
  final ProductRating? rating;
  final List<SubBadge> subBadges;
  final List<MainBadge> mainBadges;
  final List<Variant> variants;
  final VariantsImages? variantsImages;
  final String? galleryVariant;
  final List<ColorElement> colors;
  final bool hasPriceChart;
  final List<Theme> mainThemes;
  final Review? review;
  final List<dynamic> prosAndCons;
  final List<Breadcrumb> breadcrumb;
  final List<Video> videos;
  final Comments? comments;
  final Questions? questions;
  final Meta? meta;
  final String? showType;
  final StCmpTacker? stCmpTacker;
  final int? warehouseStock;
  final List<String> platforms;
  final Variant? defaultVariant;
  final String? testTitleFa;

  const ProductDto({
    required this.id,
    required this.categoryId,
    required this.titleFa,
    required this.titleEn,
    required this.brand,
    required this.status,
    required this.images,
    required this.defaultVariantId,
    required this.secondDefaultVariantId,
    required this.parameters,
    required this.productType,
    required this.properties,
    required this.price,
    required this.media,
    required this.digiplus,
    required this.productBadge,
    this.categoryTitle,
    this.rating,
    this.subBadges = const [],
    this.mainBadges = const [],
    this.variants = const [],
    this.variantsImages,
    this.galleryVariant,
    this.colors = const [],
    this.hasPriceChart = false,
    this.mainThemes = const [],
    this.review,
    this.prosAndCons = const [],
    this.breadcrumb = const [],
    this.videos = const [],
    this.comments,
    this.questions,
    this.meta,
    this.showType,
    this.stCmpTacker,
    this.warehouseStock,
    this.platforms = const [],
    this.defaultVariant,
    this.testTitleFa,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) => ProductDto(
    id: _asInt(json['id']),
    categoryId: _asInt(json['category_id']),
    titleFa: _asString(json['title_fa']),
    titleEn: _asString(json['title_en']),
    brand: _asObject(json['brand'], Brand.fromJson) ?? Brand.fromJson(const <String, dynamic>{}),
    status: _enumFromJson(Status.values, json['status'], _statusJson) ?? Status.values.first,
    images: _asObject(json['images'], Images.fromJson) ?? Images.fromJson(const <String, dynamic>{}),
    defaultVariantId: _asInt(json['default_variant_id']),
    secondDefaultVariantId: _asInt(json['second_default_variant_id']),
    parameters: _asObject(json['parameters'], Parameters.fromJson) ?? Parameters.fromJson(const <String, dynamic>{}),
    productType: _asString(json['product_type']),
    properties:
    _asObject(json['properties'], ProductProperties.fromJson) ??
        ProductProperties.fromJson(const <String, dynamic>{}),
    price: _asObject(json['price'], ProductPrice.fromJson) ?? ProductPrice.fromJson(const <String, dynamic>{}),
    media: _asList(
      json['media'],
          (value) => _asObject(value, Media.fromJson) ?? Media.fromJson(const <String, dynamic>{}),
    ),
    digiplus: _asObject(json['digiplus'], Digiplus.fromJson) ?? Digiplus.fromJson(const <String, dynamic>{}),
    productBadge:
    _asObject(json['product_badge'], ProductBadge.fromJson) ?? ProductBadge.fromJson(const <String, dynamic>{}),
    categoryTitle: (json['category_title'] == null ? null : _asString(json['category_title'])),
    rating: _asObject(json['rating'], ProductRating.fromJson),
    subBadges: _asList(
      json['sub_badges'],
          (value) => _asObject(value, SubBadge.fromJson) ?? SubBadge.fromJson(const <String, dynamic>{}),
    ),
    mainBadges: _asList(
      json['main_badges'],
          (value) => _asObject(value, MainBadge.fromJson) ?? MainBadge.fromJson(const <String, dynamic>{}),
    ),
    variants: _asList(
      json['variants'],
          (value) => _asObject(value, Variant.fromJson) ?? Variant.fromJson(const <String, dynamic>{}),
    ),
    variantsImages: _asObject(json['variants_images'], VariantsImages.fromJson),
    galleryVariant: (json['gallery_variant'] == null ? null : _asString(json['gallery_variant'])),
    colors: _asList(
      json['colors'],
          (value) => _asObject(value, ColorElement.fromJson) ?? ColorElement.fromJson(const <String, dynamic>{}),
    ),
    hasPriceChart: _asBool(json['has_price_chart']),
    mainThemes: _asList(
      json['main_themes'],
          (value) => _asObject(value, Theme.fromJson) ?? Theme.fromJson(const <String, dynamic>{}),
    ),
    review: _asObject(json['review'], Review.fromJson),
    prosAndCons: _asList(json['pros_and_cons'], (value) => value),
    breadcrumb: _asList(
      json['breadcrumb'],
          (value) => _asObject(value, Breadcrumb.fromJson) ?? Breadcrumb.fromJson(const <String, dynamic>{}),
    ),
    videos: _asList(
      json['videos'],
          (value) => _asObject(value, Video.fromJson) ?? Video.fromJson(const <String, dynamic>{}),
    ),
    comments: _asObject(json['comments'], Comments.fromJson),
    questions: _asObject(json['questions'], Questions.fromJson),
    meta: _asObject(json['meta'], Meta.fromJson),
    showType: (json['show_type'] == null ? null : _asString(json['show_type'])),
    stCmpTacker: _asObject(json['st_cmp_tacker'], StCmpTacker.fromJson),
    warehouseStock: (json['warehouse_stock'] == null ? null : _asInt(json['warehouse_stock'])),
    platforms: _asList(json['platforms'], (value) => _asString(value)),
    defaultVariant: _asObject(json['default_variant'], Variant.fromJson),
    testTitleFa: (json['test_title_fa'] == null ? null : _asString(json['test_title_fa'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'category_id': categoryId,
    'title_fa': titleFa,
    'title_en': titleEn,
    'brand': brand.toJson(),
    'status': _statusJson[status],
    'images': images.toJson(),
    'default_variant_id': defaultVariantId,
    'second_default_variant_id': secondDefaultVariantId,
    'parameters': parameters.toJson(),
    'product_type': productType,
    'properties': properties.toJson(),
    'price': price.toJson(),
    'media': media.map((value) => value.toJson()).toList(),
    'digiplus': digiplus.toJson(),
    'product_badge': productBadge.toJson(),
    'category_title': categoryTitle,
    'rating': rating?.toJson(),
    'sub_badges': subBadges.map((value) => value.toJson()).toList(),
    'main_badges': mainBadges.map((value) => value.toJson()).toList(),
    'variants': variants.map((value) => value.toJson()).toList(),
    'variants_images': variantsImages?.toJson(),
    'gallery_variant': galleryVariant,
    'colors': colors.map((value) => value.toJson()).toList(),
    'has_price_chart': hasPriceChart,
    'main_themes': mainThemes.map((value) => value.toJson()).toList(),
    'review': review?.toJson(),
    'pros_and_cons': prosAndCons.map((value) => value).toList(),
    'breadcrumb': breadcrumb.map((value) => value.toJson()).toList(),
    'videos': videos.map((value) => value.toJson()).toList(),
    'comments': comments?.toJson(),
    'questions': questions?.toJson(),
    'meta': meta?.toJson(),
    'show_type': showType,
    'st_cmp_tacker': stCmpTacker?.toJson(),
    'warehouse_stock': warehouseStock,
    'platforms': platforms.map((value) => value).toList(),
    'default_variant': defaultVariant?.toJson(),
    'test_title_fa': testTitleFa,
  };
}

class Brand {
  final int id;
  final String titleFa;
  final String? titleEn;
  final String? hexCode;
  final String? image;

  const Brand({required this.id, required this.titleFa, this.titleEn, this.hexCode, this.image});

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: _asInt(json['id']),
    titleFa: _asString(json['title_fa']),
    titleEn: (json['title_en'] == null ? null : _asString(json['title_en'])),
    hexCode: (json['hex_code'] == null ? null : _asString(json['hex_code'])),
    image: (json['image'] == null ? null : _asString(json['image'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
    'hex_code': hexCode,
    'image': image,
  };
}

class ProductRating {
  final int rate;
  final int count;
  final Map<String, double> percentages;

  const ProductRating({required this.rate, required this.count, required this.percentages});

  factory ProductRating.fromJson(Map<String, dynamic> json) => ProductRating(
    rate: _asInt(json['rate']),
    count: _asInt(json['count']),
    percentages: _asMap(json['percentages'], (value) => _asDouble(value)),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'rate': rate, 'count': count, 'percentages': percentages};
}

class Parameters {
  final List<int> colorIds;

  const Parameters({required this.colorIds});

  factory Parameters.fromJson(Map<String, dynamic> json) =>
      Parameters(colorIds: _asList(json['color_ids'], (value) => _asInt(value)));

  Map<String, dynamic> toJson() => <String, dynamic>{'color_ids': colorIds.map((value) => value).toList()};
}

class ProductProperties {
  final bool? isReadyToShip;
  final int minPriceInLastMonth;
  final String? warehouseLabel;
  final bool? hasBestPrice;
  final bool? isShipBySeller;

  const ProductProperties({
    this.isReadyToShip,
    required this.minPriceInLastMonth,
    this.warehouseLabel,
    this.hasBestPrice,
    this.isShipBySeller,
  });

  factory ProductProperties.fromJson(Map<String, dynamic> json) => ProductProperties(
    isReadyToShip: (json['is_ready_to_ship'] == null ? null : _asBool(json['is_ready_to_ship'])),
    minPriceInLastMonth: _asInt(json['min_price_in_last_month']),
    warehouseLabel: (json['warehouse_label'] == null ? null : _asString(json['warehouse_label'])),
    hasBestPrice: (json['has_best_price'] == null ? null : _asBool(json['has_best_price'])),
    isShipBySeller: (json['is_ship_by_seller'] == null ? null : _asBool(json['is_ship_by_seller'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'is_ready_to_ship': isReadyToShip,
    'min_price_in_last_month': minPriceInLastMonth,
    'warehouse_label': warehouseLabel,
    'has_best_price': hasBestPrice,
    'is_ship_by_seller': isShipBySeller,
  };
}

class ProductPrice {
  final int sellingPrice;
  final int rrpPrice;
  final int orderLimit;
  final int minOrderLimit;
  final int? marketableStock;
  final bool? isPromotion;
  final int? discountPercent;
  final bool? isIncredible;
  final String? timer;
  final int? soldPercentage;

  const ProductPrice({
    required this.sellingPrice,
    required this.rrpPrice,
    required this.orderLimit,
    required this.minOrderLimit,
    this.marketableStock,
    this.isPromotion,
    this.discountPercent,
    this.isIncredible,
    this.timer,
    this.soldPercentage,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
    sellingPrice: _asInt(json['selling_price']),
    rrpPrice: _asInt(json['rrp_price']),
    orderLimit: _asInt(json['order_limit']),
    minOrderLimit: _asInt(json['min_order_limit']),
    marketableStock: (json['marketable_stock'] == null ? null : _asInt(json['marketable_stock'])),
    isPromotion: (json['is_promotion'] == null ? null : _asBool(json['is_promotion'])),
    discountPercent: (json['discount_percent'] == null ? null : _asInt(json['discount_percent'])),
    isIncredible: (json['is_incredible'] == null ? null : _asBool(json['is_incredible'])),
    timer: (json['timer'] == null ? null : _asString(json['timer'])),
    soldPercentage: (json['sold_percentage'] == null ? null : _asInt(json['sold_percentage'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'selling_price': sellingPrice,
    'rrp_price': rrpPrice,
    'order_limit': orderLimit,
    'min_order_limit': minOrderLimit,
    'marketable_stock': marketableStock,
    'is_promotion': isPromotion,
    'discount_percent': discountPercent,
    'is_incredible': isIncredible,
    'timer': timer,
    'sold_percentage': soldPercentage,
  };
}

class ProductBadge {
  final String text;
  final String textColor;
  final String? icon;
  final String? iconColor;
  final String? image;

  const ProductBadge({required this.text, required this.textColor, this.icon, this.iconColor, this.image});

  factory ProductBadge.fromJson(Map<String, dynamic> json) => ProductBadge(
    text: _asString(json['text']),
    textColor: _asString(json['text_color']),
    icon: (json['icon'] == null ? null : _asString(json['icon'])),
    iconColor: (json['icon_color'] == null ? null : _asString(json['icon_color'])),
    image: (json['image'] == null ? null : _asString(json['image'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'text': text,
    'text_color': textColor,
    'icon': icon,
    'icon_color': iconColor,
    'image': image,
  };
}

class Images {
  final String main;
  final List<String>? imageList;

  const Images({required this.main, this.imageList});

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    main: _asString(json['main']),
    imageList: (json['image_list'] == null ? null : _asList(json['image_list'], (value) => _asString(value))),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'main': main,
    'image_list': imageList?.map((value) => value).toList(),
  };
}

class Media {
  final String src;
  final String type;

  const Media({required this.src, required this.type});

  factory Media.fromJson(Map<String, dynamic> json) =>
      Media(src: _asString(json['src']), type: _asString(json['type']));

  Map<String, dynamic> toJson() => <String, dynamic>{'src': src, 'type': type};
}

class VariantsImages {
  final Main main;
  final List<Main> list;

  const VariantsImages({required this.main, required this.list});

  factory VariantsImages.fromJson(Map<String, dynamic> json) => VariantsImages(
    main: _asObject(json['main'], Main.fromJson) ?? Main.fromJson(const <String, dynamic>{}),
    list: _asList(json['list'], (value) => _asObject(value, Main.fromJson) ?? Main.fromJson(const <String, dynamic>{})),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'main': main.toJson(),
    'list': list.map((value) => value.toJson()).toList(),
  };
}

class Main {
  final List<String> url;
  final List<String> webpUrl;

  const Main({required this.url, required this.webpUrl});

  factory Main.fromJson(Map<String, dynamic> json) => Main(
    url: _asList(json['url'], (value) => _asString(value)),
    webpUrl: _asList(json['webp_url'], (value) => _asString(value)),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'url': url.map((value) => value).toList(),
    'webp_url': webpUrl.map((value) => value).toList(),
  };
}

class Review {
  final String description;
  final List<Attribute> attributes;

  const Review({required this.description, required this.attributes});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    description: _asString(json['description']),
    attributes: _asList(
      json['attributes'],
          (value) => _asObject(value, Attribute.fromJson) ?? Attribute.fromJson(const <String, dynamic>{}),
    ),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'description': description,
    'attributes': attributes.map((value) => value.toJson()).toList(),
  };
}

class Attribute {
  final String title;
  final List<String> values;

  const Attribute({required this.title, required this.values});

  factory Attribute.fromJson(Map<String, dynamic> json) =>
      Attribute(title: _asString(json['title']), values: _asList(json['values'], (value) => _asString(value)));

  Map<String, dynamic> toJson() => <String, dynamic>{'title': title, 'values': values.map((value) => value).toList()};
}

class Breadcrumb {
  final int id;
  final String titleFa;
  final String titleEn;
  final String code;
  final String topProductImage;
  final int productsCount;
  final String? image;

  const Breadcrumb({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    required this.code,
    required this.topProductImage,
    required this.productsCount,
    this.image,
  });

  factory Breadcrumb.fromJson(Map<String, dynamic> json) => Breadcrumb(
    id: _asInt(json['id']),
    titleFa: _asString(json['title_fa']),
    titleEn: _asString(json['title_en']),
    code: _asString(json['code']),
    topProductImage: _asString(json['top_product_image']),
    productsCount: _asInt(json['products_count']),
    image: (json['image'] == null ? null : _asString(json['image'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
    'code': code,
    'top_product_image': topProductImage,
    'products_count': productsCount,
    'image': image,
  };
}

class Video {
  final int id;
  final String title;
  final String url;
  final String cover;

  const Video({required this.id, required this.title, required this.url, required this.cover});

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: _asInt(json['id']),
    title: _asString(json['title']),
    url: _asString(json['url']),
    cover: _asString(json['cover']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'title': title, 'url': url, 'cover': cover};
}

class Comments {
  final int count;
  final List<Comment> latestComments;
  final CommentsOverview commentsOverview;
  final List<Comment> topMediaComments;

  const Comments({
    required this.count,
    required this.latestComments,
    required this.commentsOverview,
    required this.topMediaComments,
  });

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
    count: _asInt(json['count']),
    latestComments: _asList(
      json['latest_comments'],
          (value) => _asObject(value, Comment.fromJson) ?? Comment.fromJson(const <String, dynamic>{}),
    ),
    commentsOverview:
    _asObject(json['comments_overview'], CommentsOverview.fromJson) ??
        CommentsOverview.fromJson(const <String, dynamic>{}),
    topMediaComments: _asList(
      json['top_media_comments'],
          (value) => _asObject(value, Comment.fromJson) ?? Comment.fromJson(const <String, dynamic>{}),
    ),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'count': count,
    'latest_comments': latestComments.map((value) => value.toJson()).toList(),
    'comments_overview': commentsOverview.toJson(),
    'top_media_comments': topMediaComments.map((value) => value.toJson()).toList(),
  };
}

class CommentsOverview {
  final int id;
  final String overview;
  final List<String> advantages;
  final List<String> disadvantages;

  const CommentsOverview({
    required this.id,
    required this.overview,
    required this.advantages,
    required this.disadvantages,
  });

  factory CommentsOverview.fromJson(Map<String, dynamic> json) => CommentsOverview(
    id: _asInt(json['id']),
    overview: _asString(json['overview']),
    advantages: _asList(json['advantages'], (value) => _asString(value)),
    disadvantages: _asList(json['disadvantages'], (value) => _asString(value)),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'overview': overview,
    'advantages': advantages.map((value) => value).toList(),
    'disadvantages': disadvantages.map((value) => value).toList(),
  };
}

class Comment {
  final int id;
  final String body;
  final int rate;
  final String user;
  final String userName;
  final Reactions reactions;
  final DateTime createdAt;
  final bool isBuyer;

  const Comment({
    required this.id,
    required this.body,
    this.rate = 0,
    required this.user,
    required this.userName,
    required this.reactions,
    required this.createdAt,
    required this.isBuyer,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: _asInt(json['id']),
    body: _asString(json['body']),
    rate: _asInt(json['rate']),
    user: _asString(json['user']),
    userName: _asString(json['user_name']),
    reactions: _asObject(json['reactions'], Reactions.fromJson) ?? Reactions.fromJson(const <String, dynamic>{}),
    createdAt: _asDateTime(json['created_at']),
    isBuyer: _asBool(json['is_buyer']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'body': body,
    'rate': rate,
    'user': user,
    'user_name': userName,
    'reactions': reactions.toJson(),
    'created_at': createdAt.toIso8601String(),
    'is_buyer': isBuyer,
  };
}

class Reactions {
  final int likes;
  final int dislikes;

  const Reactions({this.likes = 0, this.dislikes = 0});

  factory Reactions.fromJson(Map<String, dynamic> json) =>
      Reactions(likes: _asInt(json['likes']), dislikes: _asInt(json['dislikes']));

  Map<String, dynamic> toJson() => <String, dynamic>{'likes': likes, 'dislikes': dislikes};
}


class FileElement {
  final String id;
  final String url;
  final String thumbnailUrl;

  const FileElement({required this.id, required this.url, required this.thumbnailUrl});

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    id: _asString(json['id']),
    url: _asString(json['url']),
    thumbnailUrl: _asString(json['thumbnail_url']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'url': url, 'thumbnail_url': thumbnailUrl};
}


class Questions {
  final int count;
  final List<LatestQuestion> latestQuestions;

  const Questions({required this.count, required this.latestQuestions});

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
    count: _asInt(json['count']),
    latestQuestions: _asList(
      json['latest_questions'],
          (value) => _asObject(value, LatestQuestion.fromJson) ?? LatestQuestion.fromJson(const <String, dynamic>{}),
    ),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'count': count,
    'latest_questions': latestQuestions.map((value) => value.toJson()).toList(),
  };
}

class LatestQuestion {
  final String text;
  final String sender;
  final String createdAt;
  final LastAnswer? lastAnswer;

  const LatestQuestion({required this.text, required this.sender, required this.createdAt, this.lastAnswer});

  factory LatestQuestion.fromJson(Map<String, dynamic> json) => LatestQuestion(
    text: _asString(json['text']),
    sender: _asString(json['sender']),
    createdAt: _asString(json['created_at']),
    lastAnswer: _asObject(json['lastAnswer'], LastAnswer.fromJson),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'text': text,
    'sender': sender,
    'created_at': createdAt,
    'lastAnswer': lastAnswer?.toJson(),
  };
}

class LastAnswer {
  final int id;
  final String text;
  final String sender;

  const LastAnswer({required this.id, required this.text, required this.sender});

  factory LastAnswer.fromJson(Map<String, dynamic> json) =>
      LastAnswer(id: _asInt(json['id']), text: _asString(json['text']), sender: _asString(json['sender']));

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'text': text, 'sender': sender};
}

class Meta {
  final String shareUrl;
  final String priceChartUrl;

  const Meta({required this.shareUrl, required this.priceChartUrl});

  factory Meta.fromJson(Map<String, dynamic> json) =>
      Meta(shareUrl: _asString(json['share_url']), priceChartUrl: _asString(json['price_chart_url']));

  Map<String, dynamic> toJson() => <String, dynamic>{'share_url': shareUrl, 'price_chart_url': priceChartUrl};
}

class Variant {
  final int id;
  final double? rank;
  final double? rate;
  final Statistics? statistics;
  final Status status;
  final int orderLimit;
  final int minOrderLimit;
  final dynamic properties;
  final Digiplus digiplus;
  final Brand warranty;
  final List<Theme> themes;
  final Brand color;
  final Seller seller;
  final Digiclub digiclub;
  final Insurance? insurance;
  final ProductPrice price;
  final ShipmentMethods shipmentMethods;
  final List<VariantBadge>? variantBadges;
  final int? leadTime;

  const Variant({
    required this.id,
    this.rank,
    this.rate,
    this.statistics,
    required this.status,
    required this.orderLimit,
    required this.minOrderLimit,
    this.properties,
    required this.digiplus,
    required this.warranty,
    required this.themes,
    required this.color,
    required this.seller,
    required this.digiclub,
    this.insurance,
    required this.price,
    required this.shipmentMethods,
    this.variantBadges,
    this.leadTime,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: _asInt(json['id']),
    rank: (json['rank'] == null ? null : _asDouble(json['rank'])),
    rate: (json['rate'] == null ? null : _asDouble(json['rate'])),
    statistics: _asObject(json['statistics'], Statistics.fromJson),
    status: _enumFromJson(Status.values, json['status'], _statusJson) ?? Status.values.first,
    orderLimit: _asInt(json['order_limit']),
    minOrderLimit: _asInt(json['min_order_limit']),
    properties: json['properties'],
    digiplus: _asObject(json['digiplus'], Digiplus.fromJson) ?? Digiplus.fromJson(const <String, dynamic>{}),
    warranty: _asObject(json['warranty'], Brand.fromJson) ?? Brand.fromJson(const <String, dynamic>{}),
    themes: _asList(
      json['themes'],
          (value) => _asObject(value, Theme.fromJson) ?? Theme.fromJson(const <String, dynamic>{}),
    ),
    color: _asObject(json['color'], Brand.fromJson) ?? Brand.fromJson(const <String, dynamic>{}),
    seller: _asObject(json['seller'], Seller.fromJson) ?? Seller.fromJson(const <String, dynamic>{}),
    digiclub: _asObject(json['digiclub'], Digiclub.fromJson) ?? Digiclub.fromJson(const <String, dynamic>{}),
    insurance: _asObject(json['insurance'], Insurance.fromJson),
    price: _asObject(json['price'], ProductPrice.fromJson) ?? ProductPrice.fromJson(const <String, dynamic>{}),
    shipmentMethods:
    _asObject(json['shipment_methods'], ShipmentMethods.fromJson) ??
        ShipmentMethods.fromJson(const <String, dynamic>{}),
    variantBadges: (json['variant_badges'] == null
        ? null
        : _asList(
      json['variant_badges'],
          (value) => _asObject(value, VariantBadge.fromJson) ?? VariantBadge.fromJson(const <String, dynamic>{}),
    )),
    leadTime: (json['lead_time'] == null ? null : _asInt(json['lead_time'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'rank': rank,
    'rate': rate,
    'statistics': statistics?.toJson(),
    'status': _statusJson[status],
    'order_limit': orderLimit,
    'min_order_limit': minOrderLimit,
    'properties': properties,
    'digiplus': digiplus.toJson(),
    'warranty': warranty.toJson(),
    'themes': themes.map((value) => value.toJson()).toList(),
    'color': color.toJson(),
    'seller': seller.toJson(),
    'digiclub': digiclub.toJson(),
    'insurance': insurance?.toJson(),
    'price': price.toJson(),
    'shipment_methods': shipmentMethods.toJson(),
    'variant_badges': variantBadges?.map((value) => value.toJson()).toList(),
    'lead_time': leadTime,
  };
}

class Digiplus {
  final List<Service> services;
  final List<ServiceList> serviceList;
  final List<String>? servicesSummary;
  final bool? isJetEligible;
  final dynamic fastShippingText;

  const Digiplus({
    required this.services,
    required this.serviceList,
    this.servicesSummary,
    this.isJetEligible,
    this.fastShippingText,
  });

  factory Digiplus.fromJson(Map<String, dynamic> json) => Digiplus(
    services: _asList(
      json['services'],
          (value) => _enumFromJson(Service.values, value, _serviceJson) ?? Service.values.first,
    ),
    serviceList: _asList(
      json['service_list'],
          (value) => _asObject(value, ServiceList.fromJson) ?? ServiceList.fromJson(const <String, dynamic>{}),
    ),
    servicesSummary: (json['services_summary'] == null
        ? null
        : _asList(json['services_summary'], (value) => _asString(value))),
    isJetEligible: (json['is_jet_eligible'] == null ? null : _asBool(json['is_jet_eligible'])),
    fastShippingText: json['fast_shipping_text'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'services': services.map((value) => _serviceJson[value]).toList(),
    'service_list': serviceList.map((value) => value.toJson()).toList(),
    'services_summary': servicesSummary?.map((value) => value).toList(),
    'is_jet_eligible': isJetEligible,
    'fast_shipping_text': fastShippingText,
  };
}

class ServiceList {
  final Service title;

  const ServiceList({required this.title});

  factory ServiceList.fromJson(Map<String, dynamic> json) =>
      ServiceList(title: _enumFromJson(Service.values, json['title'], _serviceJson) ?? Service.values.first);

  Map<String, dynamic> toJson() => <String, dynamic>{'title': _serviceJson[title]};
}

class Theme {
  final Value value;
  final String label;
  final String type;
  final bool isMain;

  const Theme({required this.value, required this.label, required this.type, required this.isMain});

  factory Theme.fromJson(Map<String, dynamic> json) => Theme(
    value: _asObject(json['value'], Value.fromJson) ?? Value.fromJson(const <String, dynamic>{}),
    label: _asString(json['label']),
    type: _asString(json['type']),
    isMain: _asBool(json['is_main']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'value': value.toJson(),
    'label': label,
    'type': type,
    'is_main': isMain,
  };
}

class Value {
  final int variantId;
  final int id;
  final String title;
  final String code;
  final String hexCode;
  final String valueHexCode;
  final Nature nature;

  const Value({
    required this.variantId,
    required this.id,
    required this.title,
    required this.code,
    required this.hexCode,
    required this.valueHexCode,
    required this.nature,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    variantId: _asInt(json['variant_id']),
    id: _asInt(json['id']),
    title: _asString(json['title']),
    code: _asString(json['code']),
    hexCode: _asString(json['hexCode']),
    valueHexCode: _asString(json['hex_code']),
    nature: _enumFromJson(Nature.values, json['nature'], _natureJson) ?? Nature.values.first,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'variant_id': variantId,
    'id': id,
    'title': title,
    'code': code,
    'hexCode': hexCode,
    'hex_code': valueHexCode,
    'nature': _natureJson[nature],
  };
}

class Statistics {
  final SatisfactionStats? totallySatisfied;
  final SatisfactionStats? satisfied;
  final SatisfactionStats? neutral;
  final SatisfactionStats? dissatisfied;
  final SatisfactionStats? totallyDissatisfied;
  final int totalCount;
  final double totalRate;

  const Statistics({
    this.totallySatisfied,
    this.satisfied,
    this.neutral,
    this.dissatisfied,
    this.totallyDissatisfied,
    required this.totalCount,
    required this.totalRate,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    totallySatisfied: _asObject(json['totally_satisfied'], SatisfactionStats.fromJson),
    satisfied: _asObject(json['satisfied'], SatisfactionStats.fromJson),
    neutral: _asObject(json['neutral'], SatisfactionStats.fromJson),
    dissatisfied: _asObject(json['dissatisfied'], SatisfactionStats.fromJson),
    totallyDissatisfied: _asObject(json['totally_dissatisfied'], SatisfactionStats.fromJson),
    totalCount: _asInt(json['total_count']),
    totalRate: _asDouble(json['total_rate']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'totally_satisfied': totallySatisfied?.toJson(),
    'satisfied': satisfied?.toJson(),
    'neutral': neutral?.toJson(),
    'dissatisfied': dissatisfied?.toJson(),
    'totally_dissatisfied': totallyDissatisfied?.toJson(),
    'total_count': totalCount,
    'total_rate': totalRate,
  };
}

class SatisfactionStats {
  final int rateCount;
  final double rate;

  const SatisfactionStats({required this.rateCount, required this.rate});

  factory SatisfactionStats.fromJson(Map<String, dynamic> json) =>
      SatisfactionStats(rateCount: _asInt(json['rate_count']), rate: _asDouble(json['rate']));

  Map<String, dynamic> toJson() => <String, dynamic>{'rate_count': rateCount, 'rate': rate};
}

class Seller {
  final int id;
  final String titleFa;
  final String titleEn;
  final dynamic rating;
  final dynamic properties;
  final double stars;
  final Grade grade;

  const Seller({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    this.rating,
    this.properties,
    required this.stars,
    required this.grade,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    id: _asInt(json['id']),
    titleFa: _asString(json['title_fa']),
    titleEn: _asString(json['title_en']),
    rating: json['rating'],
    properties: json['properties'],
    stars: _asDouble(json['stars']),
    grade: _asObject(json['grade'], Grade.fromJson) ?? Grade.fromJson(const <String, dynamic>{}),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
    'rating': rating,
    'properties': properties,
    'stars': stars,
    'grade': grade.toJson(),
  };
}

class Grade {
  final String label;
  final String color;

  const Grade({required this.label, required this.color});

  factory Grade.fromJson(Map<String, dynamic> json) =>
      Grade(label: _asString(json['label']), color: _asString(json['color']));

  Map<String, dynamic> toJson() => <String, dynamic>{'label': label, 'color': color};
}

class Insurance {
  final String title;
  final String subtitle;
  final String description;
  final List<Cover> covers;
  final int basePremium;
  final int tax;
  final int totalPremium;
  final String termsAndConditions;
  final int beforeDiscount;
  final int discountPercent;

  const Insurance({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.covers,
    required this.basePremium,
    required this.tax,
    required this.totalPremium,
    required this.termsAndConditions,
    required this.beforeDiscount,
    required this.discountPercent,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
    title: _asString(json['title']),
    subtitle: _asString(json['subtitle']),
    description: _asString(json['description']),
    covers: _asList(
      json['covers'],
          (value) => _asObject(value, Cover.fromJson) ?? Cover.fromJson(const <String, dynamic>{}),
    ),
    basePremium: _asInt(json['base_premium']),
    tax: _asInt(json['tax']),
    totalPremium: _asInt(json['total_premium']),
    termsAndConditions: _asString(json['terms_and_conditions']),
    beforeDiscount: _asInt(json['before_discount']),
    discountPercent: _asInt(json['discount_percent']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'covers': covers.map((value) => value.toJson()).toList(),
    'base_premium': basePremium,
    'tax': tax,
    'total_premium': totalPremium,
    'terms_and_conditions': termsAndConditions,
    'before_discount': beforeDiscount,
    'discount_percent': discountPercent,
  };
}

class Cover {
  final String description;
  final int? maxUseCount;

  const Cover({required this.description, this.maxUseCount});

  factory Cover.fromJson(Map<String, dynamic> json) => Cover(
    description: _asString(json['description']),
    maxUseCount: (json['maxUseCount'] == null ? null : _asInt(json['maxUseCount'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'description': description, 'maxUseCount': maxUseCount};
}

class ShipmentMethods {
  final String description;
  final bool? hasLeadTime;
  final String icon;
  final String iconColor;
  final List<Provider> providers;

  const ShipmentMethods({
    required this.description,
    this.hasLeadTime,
    required this.icon,
    required this.iconColor,
    required this.providers,
  });

  factory ShipmentMethods.fromJson(Map<String, dynamic> json) => ShipmentMethods(
    description: _asString(json['description']),
    hasLeadTime: (json['has_lead_time'] == null ? null : _asBool(json['has_lead_time'])),
    icon: _asString(json['icon']),
    iconColor: _asString(json['icon_color']),
    providers: _asList(
      json['providers'],
          (value) => _asObject(value, Provider.fromJson) ?? Provider.fromJson(const <String, dynamic>{}),
    ),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'description': description,
    'has_lead_time': hasLeadTime,
    'icon': icon,
    'icon_color': iconColor,
    'providers': providers.map((value) => value.toJson()).toList(),
  };
}

class Provider {
  final String type;
  final String title;
  final String description;
  final LabelClass label;
  final ProviderPrice? price;
  final String shippingMode;
  final DeliveryDay deliveryDay;
  final String image;
  final String svgImage;
  final bool? hasLeadTime;

  const Provider({
    required this.type,
    required this.title,
    required this.description,
    required this.label,
    this.price,
    required this.shippingMode,
    required this.deliveryDay,
    required this.image,
    required this.svgImage,
    this.hasLeadTime,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    type: _asString(json['type']),
    title: _asString(json['title']),
    description: _asString(json['description']),
    label: _asObject(json['label'], LabelClass.fromJson) ?? LabelClass.fromJson(const <String, dynamic>{}),
    price: _asObject(json['price'], ProviderPrice.fromJson),
    shippingMode: _asString(json['shipping_mode']),
    deliveryDay: _enumFromJson(DeliveryDay.values, json['delivery_day'], _deliveryDayJson) ?? DeliveryDay.values.first,
    image: _asString(json['image']),
    svgImage: _asString(json['svg_image']),
    hasLeadTime: (json['has_lead_time'] == null ? null : _asBool(json['has_lead_time'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'title': title,
    'description': description,
    'label': label.toJson(),
    'price': price?.toJson(),
    'shipping_mode': shippingMode,
    'delivery_day': _deliveryDayJson[deliveryDay],
    'image': image,
    'svg_image': svgImage,
    'has_lead_time': hasLeadTime,
  };
}

class LabelClass {
  final String title;
  final String? description;

  const LabelClass({required this.title, this.description});

  factory LabelClass.fromJson(Map<String, dynamic> json) => LabelClass(
    title: _asString(json['title']),
    description: (json['description'] == null ? null : _asString(json['description'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'title': title, 'description': description};
}

class ProviderPrice {
  final String text;

  const ProviderPrice({required this.text});

  factory ProviderPrice.fromJson(Map<String, dynamic> json) => ProviderPrice(text: _asString(json['text']));

  Map<String, dynamic> toJson() => <String, dynamic>{'text': text};
}

class VariantBadge {
  final int id;
  final String type;
  final String slot;
  final Payload payload;

  const VariantBadge({required this.id, required this.type, required this.slot, required this.payload});

  factory VariantBadge.fromJson(Map<String, dynamic> json) => VariantBadge(
    id: _asInt(json['id']),
    type: _asString(json['type']),
    slot: _asString(json['slot']),
    payload: _asObject(json['payload'], Payload.fromJson) ?? Payload.fromJson(const <String, dynamic>{}),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'type': type, 'slot': slot, 'payload': payload.toJson()};
}

class Payload {
  final String text;
  final String textColor;
  final String svgIcon;

  const Payload({required this.text, required this.textColor, required this.svgIcon});

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    text: _asString(json['text']),
    textColor: _asString(json['text_color']),
    svgIcon: _asString(json['svg_icon']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'text': text, 'text_color': textColor, 'svg_icon': svgIcon};
}

class Digiclub {
  final int point;

  const Digiclub({required this.point});

  factory Digiclub.fromJson(Map<String, dynamic> json) => Digiclub(point: _asInt(json['point']));

  Map<String, dynamic> toJson() => <String, dynamic>{'point': point};
}

class ColorElement {
  final int id;
  final String title;
  final String hexCode;

  const ColorElement({required this.id, required this.title, required this.hexCode});

  factory ColorElement.fromJson(Map<String, dynamic> json) =>
      ColorElement(id: _asInt(json['id']), title: _asString(json['title']), hexCode: _asString(json['hex_code']));

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'title': title, 'hex_code': hexCode};
}

class StCmpTacker {
  final String neo;
  final String cx;
  final String dx;
  final String dataFx;
  final String zero;

  const StCmpTacker({required this.neo, required this.cx, required this.dx, required this.dataFx, required this.zero});

  factory StCmpTacker.fromJson(Map<String, dynamic> json) => StCmpTacker(
    neo: _asString(json['neo']),
    cx: _asString(json['cx']),
    dx: _asString(json['dx']),
    dataFx: _asString(json['data-fx']),
    zero: _asString(json['zero']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'neo': neo, 'cx': cx, 'dx': dx, 'data-fx': dataFx, 'zero': zero};
}

class SubBadge {
  final String title;
  final String type;

  const SubBadge({required this.title, required this.type});

  factory SubBadge.fromJson(Map<String, dynamic> json) =>
      SubBadge(title: _asString(json['title']), type: _asString(json['type']));

  Map<String, dynamic> toJson() => <String, dynamic>{'title': title, 'type': type};
}

class MainBadge {
  final String title;
  final MainBadgeType type;
  final String? image;

  const MainBadge({required this.title, required this.type, this.image});

  factory MainBadge.fromJson(Map<String, dynamic> json) => MainBadge(
    title: _asString(json['title']),
    type: _enumFromJson(MainBadgeType.values, json['type'], _mainBadgeTypeJson) ?? MainBadgeType.values.first,
    image: (json['image'] == null ? null : _asString(json['image'])),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'title': title, 'type': _mainBadgeTypeJson[type], 'image': image};
}
