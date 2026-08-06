import 'package:dynamic_app/shared/product/data/models/brand/brand_dto.dart';
import 'package:dynamic_app/shared/product/data/models/product/product_dto.dart';

class SearchResponse {
  final int status;
  final SearchResponseResult result;

  const SearchResponse({required this.status, required this.result});

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      SearchResponse(status: _int(json['status']), result: SearchResponseResult.fromJson(_map(json['result'])));

  Map<String, dynamic> toJson() => {'status': status, 'result': result.toJson()};
}

class SearchResponseResult {
  final List<BrandDto> brands;
  final List<ProductDto> products;

  const SearchResponseResult({required this.brands, required this.products});

  factory SearchResponseResult.fromJson(Map<String, dynamic> json) {
    final filters = _map(json['filters']);
    final brandsFilter = _map(filters['brands']);

    return SearchResponseResult(
      brands: _list(brandsFilter['options'], BrandDto.fromJson),
      products: _list(json['products'], ProductDto.fromJson),
    );
  }

  Map<String, dynamic> toJson() => {
    'filters': {
      'brands': {'options': brands.map((brand) => brand.toJson()).toList()},
    },
    'products': products.map((product) => product.toJson()).toList(),
  };
}

Map<String, dynamic> _map(Object? value) => value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is! List) return <T>[];
  return value.whereType<Map>().map((item) => parser(Map<String, dynamic>.from(item))).toList(growable: false);
}

int _int(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
