import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/home_shop/presentation/home_shop_page.dart';

@RoutePage()
class Tab4Screen extends StatelessWidget {
  const Tab4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeShopPage().wrappedRoute(context);
  }
}
