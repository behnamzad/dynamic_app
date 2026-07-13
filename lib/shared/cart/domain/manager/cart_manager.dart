import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartManager extends ChangeNotifier {
  CartEntity _cart = const CartEntity.empty();

  CartEntity get cart => _cart;

  List<CartProductEntity> get products => List.unmodifiable(_cart.products);

  int get totalQuantity => _cart.products.fold(0, (total, product) => total + product.quantity);

  bool containsProduct(int productId) => _cart.products.any((product) => product.productId == productId);

  CartProductEntity? findProduct(int productId) {
    for (final product in _cart.products) {
      if (product.productId == productId) {
        return product;
      }
    }
    return null;
  }

  // HomeShopBloc بعد از دریافت موفق Result، کل سبد را در حافظه مشترک اپ قرار می‌دهد.
  void setCart(CartEntity cart) {
    _cart = cart;
    notifyListeners();
  }

  // ProductInfoBloc فقط بعد از Success شدن درخواست سرور این متد را اجرا می‌کند.
  void addOrUpdateProduct(CartProductEntity product) {
    final products = [..._cart.products];
    final index = products.indexWhere((item) => item.productId == product.productId);
    if (index == -1) {
      products.add(product);
    } else {
      products[index] = product;
    }
    _cart = _cart.copyWith(products: List.unmodifiable(products));
    notifyListeners();
  }

  void removeProduct(int productId) {
    _cart = _cart.copyWith(
      products: List.unmodifiable(_cart.products.where((product) => product.productId != productId)),
    );
    notifyListeners();
  }

  void clear() {
    _cart = const CartEntity.empty();
    notifyListeners();
  }
}
