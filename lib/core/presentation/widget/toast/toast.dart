import 'package:flutter/material.dart';
import 'package:flutter_toast/toast.dart' as toast;

showToast(
  String text, {
  IconData? icon,
  String? iconPath,
  double? bottomPadding,
  bool? isFullWidth,
  bool? showIconRounded,
  bool? hideIcon,
  Color? backgroundColor,
  Color? textColor,
  Color? iconColor,
  double? iconSize,
  double? iconPadding,
  int? animationDuration, // in millis
  int? duration,
  Widget? actionWidget,
}) {
  toast.showToast(text,
      icon: icon,
      iconPath: iconPath,
      hideIcon: hideIcon,
      bottomPadding: bottomPadding,
      isFullWidth: isFullWidth,
      iconSize: iconSize,
      iconPadding: iconPadding,
      showIconRounded: showIconRounded,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconColor: iconColor,
      animationDuration: animationDuration,
      duration: duration,
      actionWidget: actionWidget,
      isDark: false,);
}

showToastCopy(
    {String? text,
    IconData? icon,
    String? iconPath,
    double? bottomPadding,
    bool? isFullWidth,
    bool? showIconRounded,
    bool? hideIcon,
    double? iconSize,
    double? iconPadding,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    int? animationDuration, // in millis
    int? duration,}) {
  // in millis
  toast.showToastCopy(
      text: text,
      icon: icon,
      iconPath: iconPath,
      bottomPadding: bottomPadding,
      iconSize: iconSize,
      iconPadding: iconPadding,
      isFullWidth: isFullWidth,
      hideIcon: hideIcon,
      showIconRounded: showIconRounded,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconColor: iconColor,
      animationDuration: animationDuration,
      duration: duration,
      isDark: false,);
}

showToastError(String text,
    {IconData? icon,
    String? iconPath,
    double? bottomPadding,
    bool? isFullWidth,
    bool? hideIcon,
    bool? showIconRounded,
    double? iconSize,
    double? iconPadding,
    int? animationDuration,
    Widget? actionWidget, // in millis
    int? duration,}) {
  toast.showToastError(text,
      icon: icon,
      iconSize: iconSize,
      iconPadding: iconPadding,
      iconPath: iconPath,
      hideIcon: hideIcon,
      bottomPadding: bottomPadding,
      isFullWidth: isFullWidth,
      showIconRounded: showIconRounded,
      animationDuration: animationDuration,
      duration: duration,
      actionWidget: actionWidget,
      isDark: false,);
}

showToastSuccess(
  String text, {
  IconData? icon,
  String? iconPath,
  double? bottomPadding,
  bool? isFullWidth,
  bool? hideIcon,
  bool? showIconRounded,
  double? iconSize,
  double? iconPadding,
  int? animationDuration, // in millis
  int? duration,
  Widget? actionWidget,
}) {
  toast.showToastSuccess(text,
      icon: icon,
      iconSize: iconSize,
      iconPadding: iconPadding,
      iconPath: iconPath,
      hideIcon: hideIcon,
      bottomPadding: bottomPadding,
      isFullWidth: isFullWidth,
      showIconRounded: showIconRounded,
      animationDuration: animationDuration,
      duration: duration,
      actionWidget: actionWidget,
      isDark: false,);
}

showToastWarning(
  String text, {
  IconData? icon,
  String? iconPath,
  double? bottomPadding,
  bool? isFullWidth,
  bool? hideIcon,
  bool? showIconRounded,
  double? iconSize,
  double? iconPadding,
  int? animationDuration, // in millis
  int? duration,
  Widget? actionWidget,
}) {
  toast.showToastWarning(text,
      icon: icon,
      iconSize: iconSize,
      iconPadding: iconPadding,
      iconPath: iconPath,
      hideIcon: hideIcon,
      bottomPadding: bottomPadding,
      isFullWidth: isFullWidth,
      showIconRounded: showIconRounded,
      animationDuration: animationDuration,
      duration: duration,
      actionWidget: actionWidget,
      isDark: false,);
}
