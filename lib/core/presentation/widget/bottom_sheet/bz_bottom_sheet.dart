

import 'package:dynamic_app/core/presentation/bloc/base_app/app_base_bloc.dart';
import 'package:dynamic_app/core/presentation/widget/ada_overlay_loading_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';

import 'package:flutter/services.dart';

import 'bottom_sheet_header.dart';

class BzBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? titleWidget;
  final String? subTitle;
  final Widget? icon;
  final Widget? closeIcon;
  final Function? onClosePressed;
  final bool showDivider;
  final bool isFullScreen; // like a page screen
  final bool isFullBottomSheet; //show bottom sheet in max height
  final bool isNumericTitle;
  final bool showHandler;
  final TextDirection? textDirection;
  final double? horizontalPadding;
  final double? bottomDividerPadding;
  final double? bottomTitlePadding;
  final double? bottomHandlerPadding;
  final double? topPadding;
  final TextDirection? subTitleDirection;
  final EdgeInsets? margin;

  const BzBottomSheet.oldStyle({
    super.key,
    required this.child,
    required this.title,
    this.titleWidget,
    required this.icon,
    this.onClosePressed,
    this.closeIcon,
    this.showDivider = true,
    this.isNumericTitle = false,
    this.horizontalPadding,
    this.textDirection,
    this.isFullScreen = false,
    this.subTitle,
    this.bottomDividerPadding,
    this.bottomTitlePadding,
    this.topPadding,
    this.margin,
    this.subTitleDirection,
    this.bottomHandlerPadding,
  }) : showHandler = false,
       isFullBottomSheet = true;

  const BzBottomSheet.fullBottomSheet({
    super.key,
    required this.child,
    required this.title,
    this.titleWidget,
    this.icon,
    this.onClosePressed,
    this.closeIcon,
    this.showDivider = true,
    this.isNumericTitle = false,
    this.horizontalPadding,
    this.textDirection,
    this.isFullScreen = false,
    this.subTitle,
    this.bottomDividerPadding,
    this.bottomTitlePadding,
    this.topPadding,
    this.margin,
    this.subTitleDirection,
    this.bottomHandlerPadding,
  }) : showHandler = true,
       isFullBottomSheet = true;

  const BzBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
    this.textDirection,
    this.horizontalPadding,
    this.showDivider = false,
    this.subTitle,
    this.bottomDividerPadding,
    this.bottomTitlePadding,
    this.topPadding,
    this.margin,
    this.subTitleDirection,
    this.bottomHandlerPadding,
  }) : showHandler = true,
       isFullScreen = false,
       icon = null,
       closeIcon = null,
       onClosePressed = null,
       isNumericTitle = false,
       isFullBottomSheet = false;

  const BzBottomSheet.withoutHandler({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
    this.textDirection,
    this.horizontalPadding,
    this.isFullScreen = false,
    this.subTitle,
    this.bottomDividerPadding,
    this.bottomTitlePadding,
    this.topPadding,
    this.margin,
    this.subTitleDirection,
    this.bottomHandlerPadding,
  }) : showHandler = false,
       icon = null,
       closeIcon = null,
       onClosePressed = null,
       showDivider = false,
       isNumericTitle = false,
       isFullBottomSheet = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: _setSystemChrome(context),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                margin: margin,
                constraints: isFullScreen
                    ? null
                    : BoxConstraints(maxHeight: MediaQuery.of(context).size.height - (isFullBottomSheet ? 30 : 30)),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  right: showDivider ? 0 : horizontalPadding ?? 16,
                  left: showDivider ? 0 : horizontalPadding ?? 16,
                  top: topPadding ?? ((showHandler == false && (title == null && titleWidget == null)) ? 20 : 0),
                ),
                decoration: BoxDecoration(
                  color: context.scheme().dialogBackground,
                  borderRadius: isFullScreen
                      ? null
                      : BorderRadius.only(
                          topLeft: Radius.circular(Dimen.bottomSheetRadius),
                          topRight: Radius.circular(Dimen.bottomSheetRadius),
                          bottomLeft: (Radius.circular(margin != null ? Dimen.bottomSheetRadius : 0)),
                          bottomRight: (Radius.circular(margin != null ? Dimen.bottomSheetRadius : 0)),
                        ),
                ),
                child: Column(
                  mainAxisSize: isFullScreen ? MainAxisSize.max : MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isFullBottomSheet) ...[
                      BottomSheetHeader.withClose(
                        title: title,
                        titleWidget: titleWidget,
                        subTitle: subTitle,
                        subTitleDirection: subTitleDirection,
                        closeIcon: closeIcon,
                        icon: icon,
                        isNumericTitle: isNumericTitle,
                        onClosePressed: onClosePressed,
                        showDivider: showDivider,
                        showHandler: showHandler,
                        textDirection: textDirection,
                        bottomDividerPadding: bottomDividerPadding,
                        bottomTitlePadding: bottomTitlePadding ?? 6,
                        bottomHandlerPadding: bottomHandlerPadding,
                      ),
                    ] else if (showHandler || (title != null || titleWidget != null)) ...[
                      BottomSheetHeader(
                        title: title,
                        titleWidget: titleWidget,
                        subTitle: subTitle,
                        subTitleDirection: subTitleDirection,
                        closeIcon: closeIcon,
                        showClose: isFullBottomSheet,
                        icon: icon,
                        isNumericTitle: isNumericTitle,
                        onClosePressed: onClosePressed,
                        showDivider: showDivider,
                        showHandler: showHandler,
                        textDirection: textDirection,
                        bottomDividerPadding: bottomDividerPadding,
                        bottomTitlePadding: bottomTitlePadding ?? 6,
                        bottomHandlerPadding: bottomHandlerPadding,
                      ),
                    ],
                    Flexible(
                      child: SingleChildScrollView(
                        physics: isFullBottomSheet
                            ? const NeverScrollableScrollPhysics()
                            : const ClampingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: showDivider ? (horizontalPadding ?? 16) : 0,
                            left: showDivider ? (horizontalPadding ?? 16) : 0,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeBottom: true,
                                  child: child,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<AppBaseBloc, AppBaseState>(
              builder: (context, overlayLoadingState) {
                return Visibility(
                  visible: overlayLoadingState.overlayLoadingStatus.isStartLoadingOverBottomSheet,
                  child: GestureDetector(
                    onVerticalDragDown: (_) {},
                    child: AbsorbPointer(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black.withValues(alpha: 0.65),
                        child: Center(child: OverLayLoadingWidget(message: overlayLoadingState.loadingMessage)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _setSystemChrome(context) {
    return SystemUiOverlayStyle(systemNavigationBarColor: _getNavigationColor(context));
  }

  _getNavigationColor(context) {
    return Theme.of(context).colorScheme.dialogBackground;
    // return Theme.of(context).scaffoldBackgroundColor; //scaffoldBackgroundColor is mainBackground1 in appTheme
  }
}
