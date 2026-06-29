
import 'package:dynamic_app/core/util/common_ui_imports.dart';

class BzRetryWidget extends StatelessWidget {
  final String? message;
  final String? labelButton;
  final Function() onRetryClick;

  const BzRetryWidget({
    super.key,
    this.message,
    required this.onRetryClick,
    this.labelButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          BzButton.submit(
            text: labelButton ?? ss.tryAgain,
            textFontSize: 15,
            horizontalPadding: 16,
            minSize: 40,
            onPressed: onRetryClick,
            isFullWidth: false,
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: BzText(
              message ?? ss.errorFetchInformation,
              style: context.title1Bold.copyWith(color: context.scheme().titleText, height: 1.3),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: BzText(
              ss.retryMessage,
              style: context.body3Regular.copyWith(color: context.scheme().hint, height: 1.3),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
