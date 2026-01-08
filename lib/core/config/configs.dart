import 'package:dynamic_app/di/injection_container.dart';
import 'package:dynamic_app/flavors.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Configs {
  bool get isActiveOtpDialogInPayment => F.isGooglePlay ? true : false;

  bool get isActiveOtpDialogInResetUserPass => F.isGooglePlay ? true : false;

  bool get isActiveOtpDialogInAppActivation => F.isGooglePlay ? true : false;

  bool get isActiveOtpDialogInWithdrawWallet => F.isGooglePlay ? true : false;
}

/// cs = Config s
Configs cs = inject<Configs>();
