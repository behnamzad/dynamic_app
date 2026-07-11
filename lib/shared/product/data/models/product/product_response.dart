import 'package:dynamic_app/shared/product/data/models/product/product_dto.dart';

class ProductResponse {
  final int status;
  final ProductResult result;

  const ProductResponse({required this.status, required this.result});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      status: _asInt(json['status']),
      result: _asObject(json['result'], ProductResult.fromJson) ?? ProductResult.fromJson(const <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'status': status, 'result': result.toJson()};
}

class ProductResult {
  final ProductDto product;
  final BigdataTrackerData? bigdataTrackerData;

  const ProductResult({required this.product, this.bigdataTrackerData});

  factory ProductResult.fromJson(Map<String, dynamic> json) {
    return ProductResult(
      product: _asObject(json['product'], ProductDto.fromJson) ?? ProductDto.fromJson(const <String, dynamic>{}),
      bigdataTrackerData: _asObject(json['bigdata_tracker_data'], BigdataTrackerData.fromJson),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'product': product.toJson(),
    'bigdata_tracker_data': bigdataTrackerData?.toJson(),
  };
}

class BigdataTrackerData {
  final String pageName;
  final PageInfo pageInfo;

  const BigdataTrackerData({required this.pageName, required this.pageInfo});

  factory BigdataTrackerData.fromJson(Map<String, dynamic> json) {
    return BigdataTrackerData(
      pageName: _asString(json['page_name']),
      pageInfo: _asObject(json['page_info'], PageInfo.fromJson) ?? const PageInfo(productId: 0),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'page_name': pageName, 'page_info': pageInfo.toJson()};
}

class PageInfo {
  final int productId;

  const PageInfo({required this.productId});

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(productId: _asInt(json['product_id']));
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'product_id': productId};
}

T? _asObject<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is Map && value.isNotEmpty) {
    return parser(Map<String, dynamic>.from(value));
  }
  return null;
}

int _asInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _asString(Object? value) => value?.toString() ?? '';
