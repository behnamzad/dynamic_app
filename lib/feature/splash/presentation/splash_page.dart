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
  Widget build(BuildContext context) {
    return BasePageWidget(
      appBar: AdaAppBar(
        title: 'Dynamic App',
        onBackPress: () => context.router.push(const PageOneRoute()),
      ),
      child: AdaText(
        'test',
        style: context.body1Regular.copyWith(color: context.scheme().titleText),
      ),
    );
  }
}
