import 'package:dynamic_app/infrastructure/network/model/api_response.dart';

abstract class ProductDateSource {
  Future<ApiResponse> add();
}
