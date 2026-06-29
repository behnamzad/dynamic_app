import 'package:dynamic_app/di/di_const.dart';
import 'package:dynamic_app/infrastructure/network/dio_caller.dart';
import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:injectable/injectable.dart';

import 'product_date_source.dart';

@Injectable(as: ProductDateSource)
class ProductDateSourceImpl implements ProductDateSource {
  final DioCaller dioCaller;

  ProductDateSourceImpl({@Named(DiConst.dioNamedProduct) required this.dioCaller});

  @override
  Future<ApiResponse> add() {
    return dioCaller.post('test', fromJson: () {});
  }
}
