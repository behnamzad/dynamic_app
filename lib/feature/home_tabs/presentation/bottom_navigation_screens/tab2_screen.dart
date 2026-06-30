import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/cart/presentation/cart_page.dart';

@RoutePage()
class Tab2Screen extends StatelessWidget {
  const Tab2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartPage().wrappedRoute(context);
  }
}
