import 'package:dynamic_app/core/presentation/widget/sized_circular_progress_indicator.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';

@RoutePage()
class SplashPage extends StatefulWidget implements AutoRouteWrapper {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.replaceRoute(const LoginPageRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 48, color: context.scheme().primary),
            const VGap(16),
            BzText(ss.storeName, style: context.headline1Bold.copyWith(color: context.scheme().primary)),

            const VGap(48),

            const SizedCircularProgressIndicator(width: 28, height: 28),
          ],
        ),
      ),
    );
  }
}
