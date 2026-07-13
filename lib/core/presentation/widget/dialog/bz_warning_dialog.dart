import 'package:dynamic_app/core/presentation/widget/dialog/dialog_theme_mode.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';

class BzWarningDialog extends StatefulWidget {
  const BzWarningDialog({
    super.key,
    required this.warningMode,
    required this.title,
    this.btnText,
    required this.bodyContent,
    this.horizontalPadding,
    this.headerIcon,
    this.onConfirmTab,
  });

  final DialogThemeMode warningMode;
  final String title;
  final String? btnText;
  final IconData? headerIcon;
  final Widget bodyContent;
  final double? horizontalPadding;
  final VoidCallback? onConfirmTab;

  @override
  State<BzWarningDialog> createState() => _BzWarningDialogState();
}

class _BzWarningDialogState extends State<BzWarningDialog> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(28),
          padding: const EdgeInsets.only(top: 24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: context.scheme().dialogBackground),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(widget.headerIcon ?? Icons.info_outline, size: 42, color: getHeaderColor()),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BzText(widget.title, style: context.title1Bold.copyWith(color: getHeaderColor())),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 20),
                      child: widget.bodyContent,
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(height: 46, child: _getConfirmBtn()),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getConfirmBtn() {
    switch (widget.warningMode) {
      case DialogThemeMode.alert:
      case DialogThemeMode.warning:
      case DialogThemeMode.error:
        return BzButton.cancel(
          textStyle: context.body2Bold.copyWith(color: context.scheme().primary),
          text: widget.btnText ?? ss.gotIt,
          onPressed: () {
            if (widget.onConfirmTab != null) widget.onConfirmTab!();
            Navigator.pop(context, true);
          },
        );
      case DialogThemeMode.custom:
        return BzButton.submit(
          textStyle: context.body2Bold.copyWith(color: context.scheme().mainButtonText),
          text: widget.btnText ?? ss.gotIt,
          onPressed: () {
            if (widget.onConfirmTab != null) widget.onConfirmTab!();
            Navigator.pop(context, true);
          },
        );
      case DialogThemeMode.confirm:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Color getHeaderColor() {
    Color bgColor = context.scheme().link;

    switch (widget.warningMode) {
      case DialogThemeMode.alert:
        bgColor = context.scheme().titleText;
        break;
      case DialogThemeMode.warning:
        bgColor = context.scheme().warning;
        break;
      case DialogThemeMode.error:
        bgColor = context.scheme().error;
        break;
      case DialogThemeMode.custom:
        bgColor = context.scheme().titleText;
        break;
      case DialogThemeMode.confirm:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
    return bgColor;
  }
}
