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
      appBar: BzAppBar(
        title: 'Dynamic App',
        onBackPress: () => context.replaceRoute(HomePageRoute()),
      ),
      child: BzText(
        'test',
        style: context.body1Regular.copyWith(color: context.scheme().titleText),
      ),
    );
  }
}
