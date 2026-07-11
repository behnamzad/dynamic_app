import 'package:dynamic_app/shared/product/data/models/product/product_dto.dart';

class SearchResponse {
  final int status;
  final Data result;

  const SearchResponse({required this.status, required this.result});

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
    status: _int(json['status']),
    result: _object(json['result'], Data.fromJson) ?? Data.fromJson(const {}),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'result': result.toJson(),
  };
}

class Data {
  final Filters filters;
  final List<String> relatedSearchWords;
  final Meta meta;
  final int searchPhase;
  final Advertisement advertisement;
  final List<ProductDto> products;

  const Data({
    required this.filters,
    required this.relatedSearchWords,
    required this.meta,
    required this.searchPhase,
    required this.advertisement,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    filters:
        _object(json['filters'], Filters.fromJson) ??
        Filters.fromJson(const {}),
    relatedSearchWords: _list(
      json['related_search_words'],
      (item) => _string(item),
    ),
    meta: _object(json['meta'], Meta.fromJson) ?? Meta.fromJson(const {}),
    searchPhase: _int(json['search_phase']),
    advertisement:
        _object(json['advertisement'], Advertisement.fromJson) ??
        Advertisement.fromJson(const {}),
    products: _list(
      json['products'],
      (item) =>
          _object(item, ProductDto.fromJson) ?? ProductDto.fromJson(const {}),
    ),
  );

  Map<String, dynamic> toJson() => {
    'filters': filters.toJson(),
    'related_search_words': relatedSearchWords.map((item) => item).toList(),
    'meta': meta.toJson(),
    'search_phase': searchPhase,
    'advertisement': advertisement.toJson(),
    'products': products.map((item) => item.toJson()).toList(),
  };
}

class Advertisement {
  final SponsoredBrands sponsoredBrands;

  const Advertisement({required this.sponsoredBrands});

  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
    sponsoredBrands:
        _object(json['sponsored_brands'], SponsoredBrands.fromJson) ??
        SponsoredBrands.fromJson(const {}),
  );

  Map<String, dynamic> toJson() => {
    'sponsored_brands': sponsoredBrands.toJson(),
  };
}

class SponsoredBrands {
  final BrandElement brand;
  final List<ProductDto> products;
  final int campaignId;

  const SponsoredBrands({
    required this.brand,
    required this.products,
    required this.campaignId,
  });

  factory SponsoredBrands.fromJson(Map<String, dynamic> json) =>
      SponsoredBrands(
        brand:
            _object(json['brand'], BrandElement.fromJson) ??
            BrandElement.fromJson(const {}),
        products: _list(
          json['products'],
          (item) =>
              _object(item, ProductDto.fromJson) ??
              ProductDto.fromJson(const {}),
        ),
        campaignId: _int(json['campaign_id']),
      );

  Map<String, dynamic> toJson() => {
    'brand': brand.toJson(),
    'products': products.map((item) => item.toJson()).toList(),
    'campaign_id': campaignId,
  };
}

class BrandElement {
  final int id;
  final String titleFa;
  final String? titleEn;
  final String? image;
  final String? hexCode;

  const BrandElement({
    required this.id,
    required this.titleFa,
    this.titleEn,
    this.image,
    this.hexCode,
  });

  factory BrandElement.fromJson(Map<String, dynamic> json) => BrandElement(
    id: _int(json['id']),
    titleFa: _string(json['title_fa']),
    titleEn: (json['title_en'] == null ? null : _string(json['title_en'])),
    image: (json['image'] == null ? null : _string(json['image'])),
    hexCode: (json['hex_code'] == null ? null : _string(json['hex_code'])),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
    'image': image,
    'hex_code': hexCode,
  };
}

class Filters {
  final FilterTypeDto categories;
  final FilterTypeDto brands;
  final FiltersPrice price;
  final ColorPalettes colorPalettes;
  final SellerTypes sellerTypes;
  final Attributes attributes;
  final HasReadyToShipment hasReadyToShipment;
  final HasJetShipmentBySellerOrDigikalaClass hasJetShipmentBySellerOrDigikala;
  final HasJetShipmentBySellerOrDigikalaClass onlyFresh;
  final HasShipBySeller hasShipBySeller;

  const Filters({
    required this.categories,
    required this.brands,
    required this.price,
    required this.colorPalettes,
    required this.sellerTypes,
    required this.attributes,
    required this.hasReadyToShipment,
    required this.hasJetShipmentBySellerOrDigikala,
    required this.onlyFresh,
    required this.hasShipBySeller,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    categories:
        _object(json['categories'], FilterTypeDto.fromJson) ??
        FilterTypeDto.fromJson(const {}),
    brands:
        _object(json['brands'], FilterTypeDto.fromJson) ??
        FilterTypeDto.fromJson(const {}),
    price:
        _object(json['price'], FiltersPrice.fromJson) ??
        FiltersPrice.fromJson(const {}),
    colorPalettes:
        _object(json['color_palettes'], ColorPalettes.fromJson) ??
        ColorPalettes.fromJson(const {}),
    sellerTypes:
        _object(json['seller_types'], SellerTypes.fromJson) ??
        SellerTypes.fromJson(const {}),
    attributes:
        _object(json['attributes'], Attributes.fromJson) ??
        Attributes.fromJson(const {}),
    hasReadyToShipment:
        _object(json['has_ready_to_shipment'], HasReadyToShipment.fromJson) ??
        HasReadyToShipment.fromJson(const {}),
    hasJetShipmentBySellerOrDigikala:
        _object(
          json['has_jet_shipment_by_seller_or_digikala'],
          HasJetShipmentBySellerOrDigikalaClass.fromJson,
        ) ??
        HasJetShipmentBySellerOrDigikalaClass.fromJson(const {}),
    onlyFresh:
        _object(
          json['only_fresh'],
          HasJetShipmentBySellerOrDigikalaClass.fromJson,
        ) ??
        HasJetShipmentBySellerOrDigikalaClass.fromJson(const {}),
    hasShipBySeller:
        _object(json['has_ship_by_seller'], HasShipBySeller.fromJson) ??
        HasShipBySeller.fromJson(const {}),
  );

  Map<String, dynamic> toJson() => {
    'categories': categories.toJson(),
    'brands': brands.toJson(),
    'price': price.toJson(),
    'color_palettes': colorPalettes.toJson(),
    'seller_types': sellerTypes.toJson(),
    'attributes': attributes.toJson(),
    'has_ready_to_shipment': hasReadyToShipment.toJson(),
    'has_jet_shipment_by_seller_or_digikala': hasJetShipmentBySellerOrDigikala
        .toJson(),
    'only_fresh': onlyFresh.toJson(),
    'has_ship_by_seller': hasShipBySeller.toJson(),
  };
}

class FilterTypeDto {
  final String title;
  final List<FilterTypeOptions> options;
  final String type;

  const FilterTypeDto({
    required this.title,
    required this.options,
    required this.type,
  });

  factory FilterTypeDto.fromJson(Map<String, dynamic> json) => FilterTypeDto(
    title: _string(json['title']),
    options: _list(
      json['options'],
      (item) =>
          _object(item, FilterTypeOptions.fromJson) ??
          FilterTypeOptions.fromJson(const {}),
    ),
    type: _string(json['type']),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'options': options.map((item) => item.toJson()).toList(),
    'type': type,
  };
}

class FilterTypeOptions {
  final int id;
  final String titleFa;
  final String? titleEn;
  final String? hexCode;
  final String? image;

  const FilterTypeOptions({
    required this.id,
    required this.titleFa,
    this.titleEn,
    this.hexCode,
    this.image,
  });

  factory FilterTypeOptions.fromJson(Map<String, dynamic> json) =>
      FilterTypeOptions(
        id: _int(json['id']),
        titleFa: _string(json['title_fa']),
        titleEn: (json['title_en'] == null ? null : _string(json['title_en'])),
        hexCode: (json['hex_code'] == null ? null : _string(json['hex_code'])),
        image: (json['image'] == null ? null : _string(json['image'])),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
    'hex_code': hexCode,
    'image': image,
  };
}

class FiltersPrice {
  final String title;
  final Options options;
  final String type;

  const FiltersPrice({
    required this.title,
    required this.options,
    required this.type,
  });

  factory FiltersPrice.fromJson(Map<String, dynamic> json) => FiltersPrice(
    title: _string(json['title']),
    options:
        _object(json['options'], Options.fromJson) ??
        Options.fromJson(const {}),
    type: _string(json['type']),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'options': options.toJson(),
    'type': type,
  };
}

class Options {
  final int min;
  final int max;

  const Options({required this.min, required this.max});

  factory Options.fromJson(Map<String, dynamic> json) =>
      Options(min: _int(json['min']), max: _int(json['max']));

  Map<String, dynamic> toJson() => {'min': min, 'max': max};
}

class ColorPalettes {
  final String title;
  final List<ColorPalettesOption> options;
  final String type;

  const ColorPalettes({
    required this.title,
    required this.options,
    required this.type,
  });

  factory ColorPalettes.fromJson(Map<String, dynamic> json) => ColorPalettes(
    title: _string(json['title']),
    options: _list(
      json['options'],
      (item) =>
          _object(item, ColorPalettesOption.fromJson) ??
          ColorPalettesOption.fromJson(const {}),
    ),
    type: _string(json['type']),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'options': options.map((item) => item.toJson()).toList(),
    'type': type,
  };
}

class ColorPalettesOption {
  final int id;
  final String titleFa;
  final String titleEn;
  final String code;
  final String imageUrl;
  final String description;

  const ColorPalettesOption({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    required this.code,
    required this.imageUrl,
    required this.description,
  });

  factory ColorPalettesOption.fromJson(Map<String, dynamic> json) =>
      ColorPalettesOption(
        id: _int(json['id']),
        titleFa: _string(json['title_fa']),
        titleEn: _string(json['title_en']),
        code: _string(json['code']),
        imageUrl: _string(json['image_url']),
        description: _string(json['description']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
    'code': code,
    'image_url': imageUrl,
    'description': description,
  };
}

class Attributes {
  final String title;
  final List<AttributesOption> options;
  final String type;

  const Attributes({
    required this.title,
    required this.options,
    required this.type,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    title: _string(json['title']),
    options: _list(
      json['options'],
      (item) =>
          _object(item, AttributesOption.fromJson) ??
          AttributesOption.fromJson(const {}),
    ),
    type: _string(json['type']),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'options': options.map((item) => item.toJson()).toList(),
    'type': type,
  };
}

class AttributesOption {
  final String title;
  final List<BrandElement> options;
  final String type;
  final int id;

  const AttributesOption({
    required this.title,
    required this.options,
    required this.type,
    required this.id,
  });

  factory AttributesOption.fromJson(Map<String, dynamic> json) =>
      AttributesOption(
        title: _string(json['title']),
        options: _list(
          json['options'],
          (item) =>
              _object(item, BrandElement.fromJson) ??
              BrandElement.fromJson(const {}),
        ),
        type: _string(json['type']),
        id: _int(json['id']),
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'options': options.map((item) => item.toJson()).toList(),
    'type': type,
    'id': id,
  };
}

class HasReadyToShipment {
  final String title;
  final List<HasReadyToShipmentOption> options;
  final String type;

  const HasReadyToShipment({
    required this.title,
    required this.options,
    required this.type,
  });

  factory HasReadyToShipment.fromJson(Map<String, dynamic> json) =>
      HasReadyToShipment(
        title: _string(json['title']),
        options: _list(
          json['options'],
          (item) =>
              _object(item, HasReadyToShipmentOption.fromJson) ??
              HasReadyToShipmentOption.fromJson(const {}),
        ),
        type: _string(json['type']),
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'options': options.map((item) => item.toJson()).toList(),
    'type': type,
  };
}

class HasReadyToShipmentOption {
  final String titleFa;
  final String titleEn;

  const HasReadyToShipmentOption({
    required this.titleFa,
    required this.titleEn,
  });

  factory HasReadyToShipmentOption.fromJson(Map<String, dynamic> json) =>
      HasReadyToShipmentOption(
        titleFa: _string(json['title_fa']),
        titleEn: _string(json['title_en']),
      );

  Map<String, dynamic> toJson() => {'title_fa': titleFa, 'title_en': titleEn};
}

class HasShipBySeller {
  final String title;
  final String icon;
  final String iconColor;
  final List<HasReadyToShipmentOption> options;
  final String type;
  final String description;

  const HasShipBySeller({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.options,
    required this.type,
    required this.description,
  });

  factory HasShipBySeller.fromJson(Map<String, dynamic> json) =>
      HasShipBySeller(
        title: _string(json['title']),
        icon: _string(json['icon']),
        iconColor: _string(json['icon_color']),
        options: _list(
          json['options'],
          (item) =>
              _object(item, HasReadyToShipmentOption.fromJson) ??
              HasReadyToShipmentOption.fromJson(const {}),
        ),
        type: _string(json['type']),
        description: _string(json['description']),
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'icon': icon,
    'icon_color': iconColor,
    'options': options.map((item) => item.toJson()).toList(),
    'type': type,
    'description': description,
  };
}

class HasJetShipmentBySellerOrDigikalaClass {
  final String title;
  final String icon;
  final String iconColor;
  final List<DigiplusOption>? options;
  final String type;

  const HasJetShipmentBySellerOrDigikalaClass({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.options,
    required this.type,
  });

  factory HasJetShipmentBySellerOrDigikalaClass.fromJson(
    Map<String, dynamic> json,
  ) => HasJetShipmentBySellerOrDigikalaClass(
    title: _string(json['title']),
    icon: _string(json['icon']),
    iconColor: _string(json['icon_color']),
    options: (json['options'] == null
        ? null
        : _list(
            json['options'],
            (item) =>
                _object(item, DigiplusOption.fromJson) ??
                DigiplusOption.fromJson(const {}),
          )),
    type: _string(json['type']),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'icon': icon,
    'icon_color': iconColor,
    'options': options?.map((item) => item.toJson()).toList(),
    'type': type,
  };
}

class DigiplusOption {
  final String? id;
  final String titleFa;
  final String titleEn;
  final String? icon;
  final String? iconColor;

  const DigiplusOption({
    this.id,
    required this.titleFa,
    required this.titleEn,
    this.icon,
    this.iconColor,
  });

  factory DigiplusOption.fromJson(Map<String, dynamic> json) => DigiplusOption(
    id: (json['id'] == null ? null : _string(json['id'])),
    titleFa: _string(json['title_fa']),
    titleEn: _string(json['title_en']),
    icon: (json['icon'] == null ? null : _string(json['icon'])),
    iconColor: (json['icon_color'] == null
        ? null
        : _string(json['icon_color'])),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
    'icon': icon,
    'icon_color': iconColor,
  };
}

class SellerTypes {
  final String title;
  final List<SellerTypesOption> options;
  final String type;

  const SellerTypes({
    required this.title,
    required this.options,
    required this.type,
  });

  factory SellerTypes.fromJson(Map<String, dynamic> json) => SellerTypes(
    title: _string(json['title']),
    options: _list(
      json['options'],
      (item) =>
          _object(item, SellerTypesOption.fromJson) ??
          SellerTypesOption.fromJson(const {}),
    ),
    type: _string(json['type']),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'options': options.map((item) => item.toJson()).toList(),
    'type': type,
  };
}

class SellerTypesOption {
  final String id;
  final String titleFa;
  final String titleEn;

  const SellerTypesOption({
    required this.id,
    required this.titleFa,
    required this.titleEn,
  });

  factory SellerTypesOption.fromJson(Map<String, dynamic> json) =>
      SellerTypesOption(
        id: _string(json['id']),
        titleFa: _string(json['title_fa']),
        titleEn: _string(json['title_en']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
  };
}

T? _object<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is Map && value.isNotEmpty) {
    return parser(Map<String, dynamic>.from(value));
  }
  return null;
}

List<T> _list<T>(Object? value, T Function(Object? value) parser) =>
    value is List ? value.map(parser).toList() : <T>[];
int _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
String _string(Object? value) => value?.toString() ?? '';
