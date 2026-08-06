import 'package:dynamic_app/shared/product/data/models/brand/brand_dto.dart';
import 'package:dynamic_app/shared/product/data/models/product/product_dto.dart';

class ProductByBrandResponse {
  final int status;
  final ProductByBrandResult result;

  const ProductByBrandResponse({required this.status, required this.result});

  factory ProductByBrandResponse.fromJson(Map<String, dynamic> json) =>
      ProductByBrandResponse(
        status: _int(json['status']),
        result: ProductByBrandResult.fromJson(_map(json['result'])),
      );
}

class ProductByBrandResult {
  final BrandDto brand;
  final List<ProductDto> products;

  const ProductByBrandResult({required this.brand, required this.products});

  factory ProductByBrandResult.fromJson(Map<String, dynamic> json) =>
      ProductByBrandResult(
        brand: BrandDto.fromJson(_map(json['brand'])),
        products: _list(json['products'], ProductDto.fromJson),
      );
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is! List) return <T>[];
  return value
      .whereType<Map>()
      .map((item) => parser(Map<String, dynamic>.from(item)))
      .toList(growable: false);
}

int _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
