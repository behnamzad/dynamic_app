import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/core/presentation/widget/dialog/dialog_theme_mode.dart';


class BzConfirmDialog extends StatefulWidget {
  const BzConfirmDialog(
      {super.key,
      required this.warningMode,
      required this.title,
      required this.bodyContent,
      this.headerIcon,
      this.confirmBtnLabel,
      this.headerIconWidget,
      this.cancelBtnLabel,
      this.showLoadingOnConfirmNotifier,
      this.customButtons,
    required this.onConfirmTab,
  });

  final DialogThemeMode warningMode;
  final String title;
  final String? confirmBtnLabel;
  final String? cancelBtnLabel;
  final Widget bodyContent;
  final Widget? customButtons;
  final IconData? headerIcon;
  final Widget? headerIconWidget;
  final VoidCallback onConfirmTab;

  // when we want to show loading in confirm btn
  final ValueNotifier<bool>? showLoadingOnConfirmNotifier;

  @override
  State<BzConfirmDialog> createState() => _BzConfirmDialogState();
}

class _BzConfirmDialogState extends State<BzConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(28),
          padding: const EdgeInsets.only(
            top: 24,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.scheme().dialogBackground,
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      widget.headerIconWidget ??
                          Icon(widget.headerIcon ?? Icons.info_outline, size: 42, color: getHeaderColor()),
                      const SizedBox(height: 12),
                      BzText(widget.title,
                          style: context.title1Bold.copyWith(
                            color: getHeaderColor(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      widget.bodyContent,
                      const SizedBox(height: 32),
                      widget.customButtons ??
                          SizedBox(
                            height: 46,
                            child: Row(
                              children: [
                                Expanded(
                                  child: BzButton.outline(
                                    text: widget.cancelBtnLabel ?? ss.previousStep,
                                    onPressed: () => context.maybePop(),
                                    borderColor: context.scheme().buttonBorder2,
                                    textStyle: context.body2Bold.copyWith(color: context.scheme().primary),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ValueListenableBuilder<bool>(
                                      valueListenable: widget.showLoadingOnConfirmNotifier ?? ValueNotifier(false),
                                      builder: (context, value, child) {
                                        return BzButton.submit(
                                          text: widget.confirmBtnLabel ?? ss.confirmAndContinue,
                                          showLoading: value,
                                          onPressed: () {
                                            widget.onConfirmTab.call();
                                            widget.showLoadingOnConfirmNotifier == null ? context.maybePop(true) : {};
                                          },
                                          backgroundColor: context.scheme().error,
                                          textStyle: context.body2Bold.copyWith(color: context.scheme().mainButtonText),
                                        );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getHeaderColor() {
    Color bgColor = context.scheme().link;

    switch (widget.warningMode) {
      case DialogThemeMode.alert:
        bgColor = Theme.of(context).colorScheme.titleText;
        break;
      case DialogThemeMode.warning:
        bgColor = context.scheme().warning;
        break;
      case DialogThemeMode.error:
        bgColor = context.scheme().error;
        break;
      case DialogThemeMode.custom:
        // TODO: Handle this case.
        break;
      case DialogThemeMode.confirm:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
    return bgColor;
  }
}
