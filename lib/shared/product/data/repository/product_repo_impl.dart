import 'package:dynamic_app/infrastructure/network/model/api_response.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/product_repo.dart';
import '../datasource/product_date_source.dart';

@Injectable(as: ProductRepo)
class ProductRepoImpl implements ProductRepo {
  final ProductDateSource _dateSource;

  ProductRepoImpl(this._dateSource);

  @override
  Future<ApiResponse> add() {
    return _dateSource.add();
  }
}
