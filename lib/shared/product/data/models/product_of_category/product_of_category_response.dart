import 'package:dynamic_app/shared/product/data/models/product/product_dto.dart';

class ProductOfCategoryResponse {
  final int status;
  final List<ProductOfCategoryResult> result;

  const ProductOfCategoryResponse({required this.status, required this.result});

  factory ProductOfCategoryResponse.fromJson(Map<String, dynamic> json) =>
      ProductOfCategoryResponse(
        status: _int(json['status']),
        result: _list(json['result'], ProductOfCategoryResult.fromJson),
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'result': result.map((value) => value.toJson()).toList(),
  };
}

class ProductOfCategoryResult {
  final String type;
  final Data data;
  final String name;

  const ProductOfCategoryResult({
    required this.type,
    required this.data,
    required this.name,
  });

  factory ProductOfCategoryResult.fromJson(Map<String, dynamic> json) =>
      ProductOfCategoryResult(
        type: _string(json['type']),
        data: _object(json['data'], Data.fromJson) ?? Data.fromJson(const {}),
        name: _string(json['name']),
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'data': data.toJson(),
    'name': name,
  };
}

class Data {
  final int? parentId;
  final String? color;
  final String? title;
  final List<BrandElement>? brands;
  final List<ProductDto>? products;
  final Url? url;

  const Data({
    this.parentId,
    this.color,
    this.title,
    this.brands,
    this.products,
    this.url,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    parentId: json['parent_id'] == null ? null : _int(json['parent_id']),
    color: json['color']?.toString(),
    title: json['title']?.toString(),
    brands: json['brands'] == null
        ? null
        : _list(json['brands'], BrandElement.fromJson),
    products: json['products'] == null
        ? null
        : _list(json['products'], ProductDto.fromJson),
    url: _object(json['url'], Url.fromJson),
  );

  Map<String, dynamic> toJson() => {
    'parent_id': parentId,
    'color': color,
    'title': title,
    'brands': brands?.map((value) => value.toJson()).toList(),
    'products': products?.map((value) => value.toJson()).toList(),
    'url': url?.toJson(),
  };
}

class BrandElement {
  final int id;
  final String titleFa;
  final String titleEn;
  final String image;

  const BrandElement({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    required this.image,
  });

  factory BrandElement.fromJson(Map<String, dynamic> json) => BrandElement(
    id: _int(json['id']),
    titleFa: _string(json['title_fa']),
    titleEn: _string(json['title_en']),
    image: _string(json['image']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
    'image': image,
  };
}

class Url {
  final String url;
  final String page;
  final Params params;
  final Queries queries;

  const Url({
    required this.url,
    required this.page,
    required this.params,
    required this.queries,
  });

  factory Url.fromJson(Map<String, dynamic> json) => Url(
    url: _string(json['url']),
    page: _string(json['page']),
    params:
        _object(json['params'], Params.fromJson) ?? const Params(categoryId: 0),
    queries:
        _object(json['queries'], Queries.fromJson) ?? const Queries(sort: 0),
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'page': page,
    'params': params.toJson(),
    'queries': queries.toJson(),
  };
}

class Params {
  final int categoryId;
  const Params({required this.categoryId});
  factory Params.fromJson(Map<String, dynamic> json) =>
      Params(categoryId: _int(json['category_id']));
  Map<String, dynamic> toJson() => {'category_id': categoryId};
}

class Queries {
  final int sort;
  const Queries({required this.sort});
  factory Queries.fromJson(Map<String, dynamic> json) =>
      Queries(sort: _int(json['sort']));
  Map<String, dynamic> toJson() => {'sort': sort};
}

T? _object<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is Map && value.isNotEmpty) {
    return parser(Map<String, dynamic>.from(value));
  }
  return null;
}

List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is! List) return [];
  return value
      .whereType<Map>()
      .map((item) => parser(Map<String, dynamic>.from(item)))
      .toList();
}

int _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
String _string(Object? value) => value?.toString() ?? '';
