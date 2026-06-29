// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CartPage]
class CartPageRoute extends PageRouteInfo<void> {
  const CartPageRoute({List<PageRouteInfo>? children})
      : super(
          CartPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const CartPage());
    },
  );
}

/// generated route for
/// [CheckOutPage]
class CheckOutPageRoute extends PageRouteInfo<void> {
  const CheckOutPageRoute({List<PageRouteInfo>? children})
      : super(
          CheckOutPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'CheckOutPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const CheckOutPage());
    },
  );
}

/// generated route for
/// [HomePage]
class HomePageRoute extends PageRouteInfo<HomePageRouteArgs> {
  HomePageRoute({
    Key? key,
    int id = 3,
    List<PageRouteInfo>? children,
  }) : super(
          HomePageRoute.name,
          args: HomePageRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomePageRouteArgs>(orElse: () => const HomePageRouteArgs());
      return WrappedRoute(
          child: HomePage(
        key: args.key,
        id: args.id,
      ));
    },
  );
}

class HomePageRouteArgs {
  const HomePageRouteArgs({
    this.key,
    this.id = 3,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'HomePageRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [HomeShopPage]
class HomeShopPageRoute extends PageRouteInfo<void> {
  const HomeShopPageRoute({List<PageRouteInfo>? children})
      : super(
          HomeShopPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeShopPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const HomeShopPage());
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginPageRoute extends PageRouteInfo<LoginPageRouteArgs> {
  LoginPageRoute({
    Key? key,
    required ProductEntity product,
    List<PageRouteInfo>? children,
  }) : super(
          LoginPageRoute.name,
          args: LoginPageRouteArgs(
            key: key,
            product: product,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginPageRouteArgs>();
      return WrappedRoute(
          child: LoginPage(
        key: args.key,
        product: args.product,
      ));
    },
  );
}

class LoginPageRouteArgs {
  const LoginPageRouteArgs({
    this.key,
    required this.product,
  });

  final Key? key;

  final ProductEntity product;

  @override
  String toString() {
    return 'LoginPageRouteArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [ProductInfoPage]
class ProductInfoPageRoute extends PageRouteInfo<ProductInfoPageRouteArgs> {
  ProductInfoPageRoute({
    Key? key,
    required ProductEntity product,
    List<PageRouteInfo>? children,
  }) : super(
          ProductInfoPageRoute.name,
          args: ProductInfoPageRouteArgs(
            key: key,
            product: product,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductInfoPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductInfoPageRouteArgs>();
      return WrappedRoute(
          child: ProductInfoPage(
        key: args.key,
        product: args.product,
      ));
    },
  );
}

class ProductInfoPageRouteArgs {
  const ProductInfoPageRouteArgs({
    this.key,
    required this.product,
  });

  final Key? key;

  final ProductEntity product;

  @override
  String toString() {
    return 'ProductInfoPageRouteArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [ProductListPage]
class ProductListPageRoute extends PageRouteInfo<ProductListPageRouteArgs> {
  ProductListPageRoute({
    Key? key,
    required List<ProductEntity> products,
    List<PageRouteInfo>? children,
  }) : super(
          ProductListPageRoute.name,
          args: ProductListPageRouteArgs(
            key: key,
            products: products,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductListPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductListPageRouteArgs>();
      return WrappedRoute(
          child: ProductListPage(
        key: args.key,
        products: args.products,
      ));
    },
  );
}

class ProductListPageRouteArgs {
  const ProductListPageRouteArgs({
    this.key,
    required this.products,
  });

  final Key? key;

  final List<ProductEntity> products;

  @override
  String toString() {
    return 'ProductListPageRouteArgs{key: $key, products: $products}';
  }
}

/// generated route for
/// [SplashPage]
class SplashPageRoute extends PageRouteInfo<void> {
  const SplashPageRoute({List<PageRouteInfo>? children})
      : super(
          SplashPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const SplashPage());
    },
  );
}

/// generated route for
/// [Tab1Screen]
class Tab1ScreenRoute extends PageRouteInfo<void> {
  const Tab1ScreenRoute({List<PageRouteInfo>? children})
      : super(
          Tab1ScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'Tab1ScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const Tab1Screen();
    },
  );
}

/// generated route for
/// [Tab2Screen]
class Tab2ScreenRoute extends PageRouteInfo<void> {
  const Tab2ScreenRoute({List<PageRouteInfo>? children})
      : super(
          Tab2ScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'Tab2ScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const Tab2Screen();
    },
  );
}

/// generated route for
/// [Tab3Screen]
class Tab3ScreenRoute extends PageRouteInfo<void> {
  const Tab3ScreenRoute({List<PageRouteInfo>? children})
      : super(
          Tab3ScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'Tab3ScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const Tab3Screen();
    },
  );
}

/// generated route for
/// [Tab4Screen]
class Tab4ScreenRoute extends PageRouteInfo<void> {
  const Tab4ScreenRoute({List<PageRouteInfo>? children})
      : super(
          Tab4ScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'Tab4ScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const Tab4Screen();
    },
  );
}
