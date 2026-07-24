import 'package:dynamic_app/shared/cart/domain/entities/cart_entity.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartManager extends ChangeNotifier {
  CartEntity _cart = const CartEntity.empty();
  bool _isCartLoaded = false;

  CartEntity get cart => _cart;

  bool get hasCart => _cart.id.isNotEmpty;

  bool get isCartLoaded => _isCartLoaded;

  List<CartProductEntity> get products => List.unmodifiable(_cart.products);

  bool get isEmptyCart => _cart.products.isEmpty;

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

  void setCart(CartEntity cart) {
    _cart = cart;
    _isCartLoaded = true;
    notifyListeners();
  }

  void setCartId(String cartId) {
    if (cartId.isEmpty || cartId == _cart.id) {
      return;
    }

    _cart = CartEntity(id: cartId, products: const []);
    _isCartLoaded = false;
    notifyListeners();
  }

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
    _isCartLoaded = false;
    notifyListeners();
  }
}
