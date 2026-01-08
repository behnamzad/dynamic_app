// ignore_for_file: constant_identifier_names
import 'package:dynamic_app/di/di_environments.dart';

enum Flavor {
 BASE_DYNAMIC_APP
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.BASE_DYNAMIC_APP:
        return 'فروشگاه هوشمند';
      default:
        return 'title';
    }
  }


  static bool get isCafeBazaar {
    return cafeBazaar.contains(name);
  }


  static bool get isGooglePlay {
    return googlePlay.contains(name);
  }

  static bool get isWebsite {
    return webSite.contains(name);
  }
}
