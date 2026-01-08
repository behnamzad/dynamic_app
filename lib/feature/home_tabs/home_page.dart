import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bloc/home_bloc.dart';
import 'package:flutter/scheduler.dart';

@RoutePage()
class HomePage extends StatefulWidget implements AutoRouteWrapper {
  final int id;

  const HomePage({super.key, this.id = 3});

  @override
  State<StatefulWidget> createState() => _HomePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => inject<HomeBloc>()..add(const HomeEvent.initial()), child: this);
  }
}

class _HomePageState extends BaseState<HomePage> {
  late final ValueNotifier<bool> _hideTabsValueNotifier;
  late TabsRouter tabsRouter;
  var homeTabIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return AutoTabsRouter(
          routes: const [
            // todo active this
            // Tab1ScreenRoute(),
            // Tab2ScreenRoute(),
            // Tab3ScreenRoute(),
            // Tab4ScreenRoute(),
          ],
          transitionBuilder: (context, child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          builder: (context, child) {
            tabsRouter = AutoTabsRouter.of(context);

            return Scaffold(
                body: child,
                bottomNavigationBar: ValueListenableBuilder(
                  valueListenable: _hideTabsValueNotifier,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return value ? const SizedBox() : buildBottomNavigationBar(context, tabsRouter, [0]);
                  },
                ));
          },
        );
      },
    );
  }

  Widget buildBottomNavigationBar(BuildContext context, TabsRouter tabsRouter, List<int>? navigationBarBadgesList) {
    return Container(
      decoration: BoxDecoration(color: context.scheme().mainBackground1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(thickness: 0.4, height: 0, color: context.scheme().divider),
          NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: context.scheme().primary16,
              labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) => states.contains(MaterialState.selected)
                    ? context.body2Medium.copyWith(color: context.scheme().primaryBold)
                    : context.body2Regular.copyWith(color: context.scheme().mainText),
              ),
            ),
            child: NavigationBar(
              backgroundColor: context.scheme().mainBackground1,
              selectedIndex: tabsRouter.activeIndex,
              animationDuration: const Duration(milliseconds: 500),
              onDestinationSelected: (index) {
                tabsRouter.setActiveIndex(index);
              },
              destinations: [
                NavigationDestination(
                  icon: _navigationBarIcon(
                    showBadge: isShowBadge(navigationBarBadgesList: navigationBarBadgesList, navigationItemId: 0),
                    selectedIcon: Icons.storefront_rounded,
                    icon: Icons.storefront_outlined,
                    isSelected: false,
                    height: 7,
                  ),
                  label: 'store',
                ),
                NavigationDestination(
                  icon: _navigationBarIcon(
                    showBadge: isShowBadge(navigationBarBadgesList: navigationBarBadgesList, navigationItemId: 0),
                    selectedIcon: Icons.storefront_rounded,
                    icon: Icons.storefront_outlined,
                    isSelected: false,
                    height: 7,
                  ),
                  label: 'store',
                ),
                NavigationDestination(
                  icon: _navigationBarIcon(
                    showBadge: isShowBadge(navigationBarBadgesList: navigationBarBadgesList, navigationItemId: 0),
                    selectedIcon: Icons.storefront_rounded,
                    icon: Icons.storefront_outlined,
                    isSelected: false,
                    height: 7,
                  ),
                  label: 'store',
                ),
                NavigationDestination(
                  icon: _navigationBarIcon(
                    showBadge: isShowBadge(navigationBarBadgesList: navigationBarBadgesList, navigationItemId: 0),
                    selectedIcon: Icons.storefront_rounded,
                    icon: Icons.storefront_outlined,
                    isSelected: false,
                    height: 7,
                  ),
                  label: 'store',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigationBarIcon({
    required IconData selectedIcon,
    required IconData icon,
    required bool isSelected,
    required double height,
    required bool showBadge,
    Widget? selectedSvgIcon,
    Widget? svgIcon,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height),
              if (svgIcon != null && selectedSvgIcon != null) isSelected ? selectedSvgIcon : svgIcon,
              if (svgIcon == null && selectedSvgIcon == null)
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? context.scheme().primaryBold : context.scheme().mainText,
                  size: 24,
                ),
              SizedBox(height: height),
            ],
          ),
        ),
        if (showBadge)
          Positioned(
            left: 0,
            top: 0,
            child: redCircleBadgeWidget(),
          )
      ],
    );
  }

  redCircleBadgeWidget() {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          color: context.scheme().error,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              strokeAlign: BorderSide.strokeAlignOutside, color: context.scheme().mainBackground1, width: 2)),
    );
  }

  bool isShowBadge({required List<int>? navigationBarBadgesList, required int navigationItemId}) {
    if (navigationBarBadgesList != null) {
      return navigationBarBadgesList.contains(navigationItemId);
    } else {
      return false;
    }
  }

// saveClickedBadgeItem(
//     {required BuildContext context, required List<int>? navigationBarBadgesList, required int navigationItemId}) {
//   if (navigationBarBadgesList != null && navigationBarBadgesList.isNotEmpty) {
//     if (navigationBarBadgesList.contains(navigationItemId)) {
//       List<String> savedBadgeClickedList = List.from(inject<SettingsManager>().getNavigationBarBadgesClickedList());
//       List<String> badgeClickedList = List.from(savedBadgeClickedList);
//       if (!savedBadgeClickedList.contains(navigationItemId.toString())) {
//         badgeClickedList.add(navigationItemId.toString());
//         inject<SettingsManager>().setNavigationBarBadgesClickedList(badgeClickedList);
//         context.read<HomeBloc>().add(const HomeEvent.reloadNavigationBarBadgeList());
//       }
//     }
//   }
// }
}
