import 'package:dynamic_app/shared/prediction/domain/entities/prediction_model_info.dart';
import 'package:dynamic_app/shared/prediction/domain/entities/product_prediction.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

/// قرارداد قابل‌تعویض prediction؛ Manager فقط این رابط را می‌شناسد.
abstract interface class PredictionRepository {
  Future<ProductPrediction> predictPurchase(
    ProductEntity product, {
    int displayPosition = 0,
  });

  Future<List<String>> getRelatedProductIds(
    ProductEntity product, {
    int limit = 12,
  });

  Future<List<ProductPrediction>> getPersonalizedRelatedProducts(
    ProductEntity product, {
    int limit = 12,
  });

  Future<List<ProductPrediction>> rankProducts(List<ProductEntity> products);

  Future<PredictionModelInfo> getModelInfo();
}
