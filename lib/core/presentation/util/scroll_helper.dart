import 'package:dynamic_app/core/util/common_ui_imports.dart';

class ScrollHelper {
  void onScroll(ScrollController controller, {required VoidCallback onEndScroll}) {
    if (controller.position.atEdge) {
      bool isBottom = controller.position.pixels == controller.position.maxScrollExtent;
      if (isBottom && controller.hasClients) {
        onEndScroll.call();
      }
    }
  }
}
