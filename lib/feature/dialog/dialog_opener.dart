import 'package:dynamic_app/core/presentation/widget/dialog/bz_confirm_dialog.dart';
import 'package:dynamic_app/core/presentation/widget/dialog/bz_dialog.dart';
import 'package:dynamic_app/core/presentation/widget/dialog/bz_warning_dialog.dart';
import 'package:dynamic_app/core/presentation/widget/dialog/dialog_theme_mode.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/dialog/ada_date_picker/bz_date_picker.dart';


openWarningDialog(
  BuildContext context, {
  DialogThemeMode warningDialogMode = DialogThemeMode.alert,
  IconData? headerIcon,
  double? horizontalPadding,
  VoidCallback? onConfirmTab,
  required String title,
  String? btnText,
  bool dismissible = true,
  required Widget bodyContent,
}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierColor: context.scheme().dialogShadow,
    builder: (context) {
      return BzWarningDialog(
        warningMode: warningDialogMode,
        title: title,
        btnText: btnText,
        bodyContent: bodyContent,
        horizontalPadding: horizontalPadding,
        headerIcon: headerIcon,
        onConfirmTab: onConfirmTab,
      );
    },
  );
}

Future openConfirmDialog(
  BuildContext context, {
  DialogThemeMode dialogThemeMode = DialogThemeMode.alert,
  required String title,
  String? confirmBtnLabel,
  String? cancelBtnLabel,
  IconData? headerIcon,
  Widget? headerIconWidget,
  required Widget bodyContent,
  bool? barrierDismissible,
  ValueNotifier<bool>? showLoadingOnConfirmNotifier,
  Widget? customButtons,
  required VoidCallback onConfirmTab,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    barrierColor: context.scheme().dialogShadow,
    builder: (context) {
      return BzConfirmDialog(
        warningMode: dialogThemeMode,
        title: title,
        headerIcon: headerIcon,
        cancelBtnLabel: cancelBtnLabel,
        headerIconWidget: headerIconWidget,
        showLoadingOnConfirmNotifier: showLoadingOnConfirmNotifier,
        bodyContent: bodyContent,
        customButtons: customButtons,
        confirmBtnLabel: confirmBtnLabel,
        onConfirmTab: onConfirmTab,
      );
    },
  );
}

Future openBzConfirmDialog(
  BuildContext context, {
  required String title,
  String? description,
  String? confirmBtnLabel,
  String? dismissBtnLabel,
  IconData? headerIcon,
  Widget? headerIconWidget,
  Widget? bodyContent,
  bool? barrierDismissible,
  bool? enablePopOnConfirm = true,
  ValueNotifier<bool>? showLoadingOnConfirmNotifier,
  Widget? customButtons,
  bool showDismissButton = true,
  VoidCallback? onDismissTab,
  required VoidCallback onConfirmTab,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    barrierColor: context.scheme().dialogShadow,
    child: BzDialog.confirm(
      themeMode: DialogThemeMode.confirm,
      title: title,
      description: description,
      headerIcon: headerIcon,
      dismissBtnLabel: dismissBtnLabel,
      headerIconWidget: headerIconWidget,
      showLoadingOnConfirmNotifier: showLoadingOnConfirmNotifier,
      bodyContent: bodyContent,
      customButtons: customButtons,
      confirmBtnLabel: confirmBtnLabel,
      enablePopOnConfirm: enablePopOnConfirm,
      onConfirmTab: onConfirmTab,
      showDismissButton: showDismissButton,
      onDismissTab: onDismissTab,
    ),
  );
}

Future openBzAlertDialog(
  BuildContext context, {
  required String title,
  String? description,
  String? dismissBtnLabel,
  IconData? headerIcon,
  Widget? headerIconWidget,
  Widget? bodyContent,
  bool? barrierDismissible,
  ValueNotifier<bool>? showLoadingOnConfirmNotifier,
  Widget? customButtons,
  VoidCallback? onDismissTab,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    barrierColor: context.scheme().dialogShadow,
    child: BzDialog.alert(
      themeMode: DialogThemeMode.alert,
      title: title,
      description: description,
      headerIcon: headerIcon,
      dismissBtnLabel: dismissBtnLabel,
      headerIconWidget: headerIconWidget,
      bodyContent: bodyContent,
      onDismissTab: onDismissTab,
    ),
  );
}

Future<T?> showAnimatedDialog<T>({
  required BuildContext context,
  required Widget child,
  required bool barrierDismissible,
  Color? barrierColor,
}) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? context.scheme().dialogShadow,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(type: MaterialType.transparency, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(scale: Tween<double>(begin: 0.8, end: 1).animate(curvedAnimation), child: child),
        );
      },
    ),
  );
}


Future<dynamic> openDatePicker({
  required BuildContext context,
  required String title,
  required String startDate,
  required String endDate,
  String? currentDate,
  bool showDayColumn = true,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BzDatePicker(
        title: title,
        startDate: startDate,
        endDate: endDate,
        currentDate: currentDate,
        showDayColumn: showDayColumn,
      );
    },
  );
}



/// to get offset use ==>
// Listener(
//               onPointerUp: (value) {
//               final offset = = value.position;
//                howPopUp(context, offset);
//               },);
//or
// GestureDetector(
//       onTapDown: (tapDownDetails) {
//         final offset = tapDownDetails.globalPosition;
//         showPopUp(context, offset);)
Future<void> showPopUp(
  BuildContext context, {
  required Offset offset,
  Widget? dialogBody,
  required String title,
  required Widget titleIconWidget,
  required String message,
}) async {
  double left = offset.dx;
  double top = offset.dy;
  double right = MediaQuery.of(context).size.width - offset.dx;
  double bottom = MediaQuery.of(context).size.height - offset.dy;

  await showMenu(
    context: context,
    color: Colors.transparent,
    position: RelativeRect.fromLTRB(left, top, right, bottom),
    elevation: 0,
    items: [
      PopupMenuItem(
        enabled: false,
        padding: EdgeInsets.zero,
        value: 1,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child:
                dialogBody ??
                SizedBox(
                  width: 220,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14.0) + const EdgeInsets.only(top: 16.0, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            titleIconWidget,
                            const SizedBox(width: 8),
                            BzText(
                              title,
                              style: context.body3Medium.copyWith(color: Theme.of(context).colorScheme.titleText),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                        thickness: Theme.of(context).dividerTheme.thickness,
                        color: Theme.of(context).colorScheme.mainBackground2,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14.0) + const EdgeInsets.only(top: 12.0, bottom: 14),
                        child: BzText(
                          message,
                          style: context.body4Regular.copyWith(
                            color: Theme.of(context).colorScheme.mainText,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    ],
  );
}
