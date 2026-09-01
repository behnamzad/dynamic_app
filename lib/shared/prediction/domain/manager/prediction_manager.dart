import 'package:dynamic_app/shared/prediction/domain/entities/prediction_model_info.dart';
import 'package:dynamic_app/shared/prediction/domain/entities/product_prediction.dart';
import 'package:dynamic_app/shared/prediction/domain/repository/prediction_repository.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:injectable/injectable.dart';

/// رابط ساده‌ای که UI در مرحله بعد فقط متدهای آن را صدا می‌زند.
@lazySingleton
class PredictionManager {
  const PredictionManager(this._repository);

  final PredictionRepository _repository;

  /// احتمال خرید محصول را بین صفر و یک برمی‌گرداند.
  Future<double> purchaseProbability(
    ProductEntity product, {
    int displayPosition = 0,
  }) async {
    final ProductPrediction prediction = await _repository.predictPurchase(
      product,
      displayPosition: displayPosition,
    );
    return prediction.purchaseProbability;
  }

  /// نتیجه کامل شامل درصد، threshold و نسخه مدل را می‌دهد.
  Future<ProductPrediction> purchasePrediction(
    ProductEntity product, {
    int displayPosition = 0,
  }) {
    return _repository.predictPurchase(
      product,
      displayPosition: displayPosition,
    );
  }

  /// فقط ارتباط عمومی محصولات را می‌خواند و مدل را اجرا نمی‌کند.
  Future<List<String>> relatedProductIds(
    ProductEntity product, {
    int limit = 12,
  }) {
    return _repository.getRelatedProductIds(product, limit: limit);
  }

  /// محصولات مرتبط را با مدل امتیاز می‌دهد و برای کاربر فعلی مرتب می‌کند.
  Future<List<ProductPrediction>> personalizedRelatedProducts(
    ProductEntity product, {
    int limit = 12,
  }) {
    return _repository.getPersonalizedRelatedProducts(product, limit: limit);
  }

  /// نسخه ساده متد بالا برای جاهایی که فقط ID لازم دارند.
  Future<List<String>> personalizedProductIds(
    ProductEntity product, {
    int limit = 12,
  }) async {
    final List<ProductPrediction> predictions =
        await personalizedRelatedProducts(product, limit: limit);
    return predictions
        .map((ProductPrediction prediction) => prediction.productId)
        .toList(growable: false);
  }

  /// هر لیست محصول دلخواه را بر اساس احتمال خرید مرتب می‌کند.
  Future<List<ProductPrediction>> rankProducts(List<ProductEntity> products) {
    return _repository.rankProducts(products);
  }

  Future<PredictionModelInfo> modelInfo() => _repository.getModelInfo();
}
