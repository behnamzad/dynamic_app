import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/cart/presentation/cart_page.dart';

@RoutePage()
class Tab3Screen extends StatelessWidget {
  const Tab3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartPage().wrappedRoute(context);
  }
}
