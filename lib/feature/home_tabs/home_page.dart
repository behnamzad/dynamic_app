import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/dialog/bottom_sheet_util.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bloc/home_bloc.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bottom_sheet/home_exit_bottom_sheet_content_widget.dart';

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
  bool _isExitBottomSheetOpen = false;
  int homeTabIndex = 3;
  int searchTabIndex = 2;
  int cartTabIndex = 1;
  int meTabIndex = 0;

  @override
  void initState() {
    _hideTabsValueNotifier = ValueNotifier(false);
    super.initState();
  }

  int currentIndex = 1;

  @override
  void dispose() {
    _hideTabsValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return AutoTabsRouter(
          routes: const [Tab1ScreenRoute(), Tab2ScreenRoute(), Tab3ScreenRoute(), Tab4ScreenRoute()],
          transitionBuilder: (context, child, animation) => FadeTransition(opacity: animation, child: child),
          builder: (context, child) {
            tabsRouter = AutoTabsRouter.of(context);

            return PopScope<Object?>(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                _handleBack(context);
              },
              child: Scaffold(
                body: child,
                bottomNavigationBar: ValueListenableBuilder(
                  valueListenable: _hideTabsValueNotifier,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return value ? const SizedBox() : buildBottomNavigationBar(context, tabsRouter, [0]);
                  },
                ),
              ),
            );
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
              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (Set<WidgetState> states) => states.contains(WidgetState.selected)
                    ? context.body2Bold.copyWith(color: context.scheme().primaryBold)
                    : context.body2Regular.copyWith(color: context.scheme().mainText),
              ),
            ),
            child: NavigationBar(
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              backgroundColor: context.scheme().mainBackground2,
              selectedIndex: tabsRouter.activeIndex,
              animationDuration: const Duration(milliseconds: 1500),
              height: 65,
              indicatorColor: context.scheme().primary2,
              onDestinationSelected: (index) {
                tabsRouter.setActiveIndex(index);
              },
              destinations: [
                NavigationDestination(
                  icon: _navigationBarIcon(
                    icon: Icons.person_rounded,
                    isSelected: tabsRouter.activeIndex == meTabIndex,
                  ),
                  tooltip: ss.personal,
                  label: ss.personal,
                ),
                NavigationDestination(
                  icon: _navigationBarIcon(
                    icon: Icons.shopping_bag_rounded,
                    isSelected: tabsRouter.activeIndex == cartTabIndex,
                  ),
                  tooltip: ss.cart,
                  label: ss.cart,
                ),
                NavigationDestination(
                  icon: _navigationBarIcon(
                    icon: Icons.search_rounded,
                    isSelected: tabsRouter.activeIndex == searchTabIndex,
                  ),
                  tooltip: ss.search,
                  label: ss.search,
                ),
                NavigationDestination(
                  icon: _navigationBarIcon(
                    icon: Icons.home_rounded,
                    isSelected: tabsRouter.activeIndex == homeTabIndex,
                  ),
                  tooltip: ss.home,
                  label: ss.home,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigationBarIcon({required IconData icon, required bool isSelected}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Icon(icon, color: isSelected ? context.scheme().primaryBold : context.scheme().mainText, size: 28),
        ),
      ],
    );
  }

  Future<void> _handleBack(BuildContext context) async {
    if (tabsRouter.activeIndex != homeTabIndex) {
      tabsRouter.setActiveIndex(homeTabIndex);
      return;
    }

    if (_isExitBottomSheetOpen) return;
    _isExitBottomSheetOpen = true;
    try {
      await bsUtil.openBottomSheet(context, contentChild: const HomeExitBottomSheetContentWidget());
    } finally {
      _isExitBottomSheetOpen = false;
    }
  }
}
