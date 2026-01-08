// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

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
      final args = data.argsAs<HomePageRouteArgs>(
          orElse: () => const HomePageRouteArgs());
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
/// [PageOne]
class PageOneRoute extends PageRouteInfo<void> {
  const PageOneRoute({List<PageRouteInfo>? children})
      : super(
          PageOneRoute.name,
          initialChildren: children,
        );

  static const String name = 'PageOneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PageOne();
    },
  );
}

/// generated route for
/// [PageTwo]
class PageTwoRoute extends PageRouteInfo<void> {
  const PageTwoRoute({List<PageRouteInfo>? children})
      : super(
          PageTwoRoute.name,
          initialChildren: children,
        );

  static const String name = 'PageTwoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PageTwo();
    },
  );
}

/// generated route for
/// [ParentPage]
class ParentPageRoute extends PageRouteInfo<void> {
  const ParentPageRoute({List<PageRouteInfo>? children})
      : super(
          ParentPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'ParentPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ParentPage());
    },
  );
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
