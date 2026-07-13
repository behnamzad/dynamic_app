import 'package:dynamic_app/core/presentation/widget/dialog/dialog_theme_mode.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';

class BzDialog extends StatefulWidget {
  const BzDialog.confirm({
    super.key,
    this.themeMode = DialogThemeMode.confirm,
    required this.title,
    this.bodyContent,
    this.headerIcon,
    this.confirmBtnLabel,
    this.headerIconWidget,
    this.dismissBtnLabel,
    this.showLoadingOnConfirmNotifier,
    this.customButtons,
    this.enablePopOnConfirm,
    required this.onConfirmTab,
    this.description,
    this.onDismissTab,
    this.showDismissButton = true,
  });

  const BzDialog.alert({
    super.key,
    this.themeMode = DialogThemeMode.alert,
    required this.title,
    this.bodyContent,
    this.headerIcon,
    this.headerIconWidget,
    this.dismissBtnLabel,
    this.description,
    this.enablePopOnConfirm,
    this.onDismissTab,
  }) : confirmBtnLabel = null,
       customButtons = null,
       onConfirmTab = null,
       showDismissButton = true,
       showLoadingOnConfirmNotifier = null;

  final DialogThemeMode themeMode;
  final String title;
  final String? description;
  final String? confirmBtnLabel;
  final String? dismissBtnLabel;
  final Widget? bodyContent;
  final Widget? customButtons;
  final IconData? headerIcon;
  final Widget? headerIconWidget;
  final VoidCallback? onConfirmTab;
  final VoidCallback? onDismissTab;
  final bool? enablePopOnConfirm;
  final bool showDismissButton;

  // when we want to show loading in confirm btn
  final ValueNotifier<bool>? showLoadingOnConfirmNotifier;

  @override
  State<BzDialog> createState() => _BzDialogState();
}

class _BzDialogState extends State<BzDialog> {
  @override
  Widget build(BuildContext context) {
    var isConfirmDialog = widget.themeMode == DialogThemeMode.confirm;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(28),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: context.scheme().dialogBackground),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 18),
                  child: Row(
                    children: [
                      //widget.headerIconWidget ??
                      // Container(
                      //   height: 40,
                      //   width: 40,
                      //   decoration: BoxDecoration(color: context.scheme().mainBackground2, shape: BoxShape.circle),
                      //   child: Icon(
                      //     widget.headerIcon ?? Icons.info_outline,
                      //     size: 22,
                      //     color: context.scheme().titleText,
                      //   ),
                      // ),
                      //const SizedBox(width: 16),
                      BzText(widget.title, style: context.headline5Bold.copyWith(color: context.scheme().titleText)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child:
                      widget.bodyContent ??
                      BzText(
                        textAlign: TextAlign.justify,
                        widget.description ?? '',
                        style: context.body2Regular.copyWith(color: context.scheme().mainText, height: 1.4),
                      ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      widget.customButtons ??
                      SizedBox(
                        height: 42,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.showDismissButton)
                              BzButton.cancel(
                                isFullWidth: false,
                                horizontalPadding: !isConfirmDialog ? 22 : 24,
                                text: widget.dismissBtnLabel ?? ss.gotIt,
                                onPressed: widget.onDismissTab ?? () => context.maybePop(),
                                textStyle: context.body1Bold.copyWith(color: context.scheme().primary),
                                backgroundColor: !isConfirmDialog
                                    ? context.scheme().backAndCancelButtonBackground
                                    : Colors.transparent,
                                borderSize: 0,
                              ),
                            if (isConfirmDialog) ...[
                              const SizedBox(width: 8),
                              ValueListenableBuilder<bool>(
                                valueListenable: widget.showLoadingOnConfirmNotifier ?? ValueNotifier(false),
                                builder: (context, value, child) {
                                  return BzButton.submit(
                                    isFullWidth: false,
                                    horizontalPadding: 22,
                                    text: widget.confirmBtnLabel ?? ss.confirmAndContinue,
                                    textStyle: context.body1Bold.copyWith(color: context.scheme().mainButtonText),
                                    showLoading: value,
                                    loadingSize: 20,
                                    loadingStrokeWidth: 2.2,
                                    onPressed: () {
                                      widget.onConfirmTab?.call();
                                      if ((widget.enablePopOnConfirm ?? true)) {
                                        value == false ? context.maybePop(true) : {};
                                      }
                                    },
                                    textColor: context.scheme().mainButtonText,
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
