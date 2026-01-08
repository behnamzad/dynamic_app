import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/core/presentation/route/app_router.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitialNavigationManager {
  final AppRouter _appRouter;
  final UserManager _um;

  InitialNavigationManager(this._appRouter, this._um);

  Future<void> handleInitialNavigation() async {}
}
