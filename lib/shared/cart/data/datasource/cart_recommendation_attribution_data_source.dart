import 'dart:convert';

import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_recommendation_attribution_store.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// attributionهای کوچک سبد را محلی نگه می‌دارد تا با refresh یا شروع دوباره اپ از بین نروند.
@LazySingleton(as: CartRecommendationAttributionStore)
class CartRecommendationAttributionDataSource implements CartRecommendationAttributionStore {
  CartRecommendationAttributionDataSource(this._preferences);

  static const String _keyPrefix = 'cart_recommendation_attributions_v1_';

  final SharedPreferences _preferences;

  @override
  Future<Map<int, RecommendationAttribution>> read(String cartId) async {
    if (cartId.trim().isEmpty) return const <int, RecommendationAttribution>{};
    final String? encoded = _preferences.getString(_key(cartId));
    if (encoded == null || encoded.isEmpty) return const <int, RecommendationAttribution>{};

    try {
      final dynamic decoded = jsonDecode(encoded);
      if (decoded is! Map) return const <int, RecommendationAttribution>{};
      final Map<int, RecommendationAttribution> result = <int, RecommendationAttribution>{};
      for (final MapEntry<dynamic, dynamic> entry in decoded.entries) {
        final int? productId = int.tryParse(entry.key.toString());
        if (productId == null || entry.value is! Map) continue;
        final RecommendationAttribution attribution = RecommendationAttribution.fromJson(
          Map<String, dynamic>.from(entry.value as Map),
        );
        if (attribution.isValid) result[productId] = attribution;
      }
      return Map<int, RecommendationAttribution>.unmodifiable(result);
    } catch (_) {
      return const <int, RecommendationAttribution>{};
    }
  }

  @override
  Future<void> save({
    required String cartId,
    required int productId,
    required RecommendationAttribution attribution,
  }) async {
    if (cartId.trim().isEmpty || !attribution.isValid) return;
    final Map<int, RecommendationAttribution> current = Map<int, RecommendationAttribution>.of(await read(cartId));
    current[productId] = attribution;
    await _write(cartId, current);
  }

  @override
  Future<void> remove({required String cartId, required int productId}) async {
    if (cartId.trim().isEmpty) return;
    final Map<int, RecommendationAttribution> current = Map<int, RecommendationAttribution>.of(await read(cartId));
    if (current.remove(productId) == null) return;
    await _write(cartId, current);
  }

  @override
  Future<void> clear(String cartId) async {
    if (cartId.trim().isEmpty) return;
    await _preferences.remove(_key(cartId));
  }

  Future<void> _write(String cartId, Map<int, RecommendationAttribution> values) async {
    if (values.isEmpty) {
      await clear(cartId);
      return;
    }
    await _preferences.setString(
      _key(cartId),
      jsonEncode(<String, dynamic>{
        for (final MapEntry<int, RecommendationAttribution> entry in values.entries)
          entry.key.toString(): entry.value.toJson(),
      }),
    );
  }

  String _key(String cartId) => '$_keyPrefix$cartId';
}
