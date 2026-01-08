import 'package:dynamic_app/core/config/dimen.dart';
import 'package:dynamic_app/core/presentation/widget/ada_text.dart';
import 'package:dynamic_app/core/style/app_theme.dart';
import 'package:dynamic_app/core/util/extension/context_ext.dart';
import 'package:flutter/material.dart';

class AdaAppBar extends StatelessWidget {
  const AdaAppBar(
      {super.key,
      this.title = '',
      this.showBackButton = true,
      this.action,
      this.height,
      this.onBackPress,
      this.titleWidget,
      this.bgColor,
      this.showDivider = false,
      this.backIcon,
      this.multiAccountWidget,
      this.showCloseButton = false,
      this.isUseSafeArea = true});

  final String title;
  final bool showBackButton;
  final bool isUseSafeArea;
  final Widget? backIcon;
  final Widget? multiAccountWidget;
  final Widget? titleWidget;
  final Function()? onBackPress;
  final Widget? action;
  final double? height;
  final Color? bgColor;
  final bool showDivider;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    if (isUseSafeArea) {
      return SafeArea(
        child: _appBar(context),
      );
    } else {
      return _appBar(context);
    }
  }

  Container _appBar(BuildContext context) {
    return Container(
      height: height ?? Dimen.appBarHeight,
      color: bgColor ?? context.scheme().mainBackground1,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBackButton)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: onBackPress ??
                        () {
                          Navigator.of(context).pop();
                        },
                    child: SizedBox(
                        width: Dimen.appBarHeight,
                        height: Dimen.appBarHeight,
                        child: backIcon ??
                            Icon(
                              showCloseButton ? Icons.close_rounded : Icons.arrow_back_sharp,
                              color: context.scheme().titleText,
                            )),
                  ),
                ),
            ],
          ),
          if (multiAccountWidget != null)
            Positioned(
              right: 6,
              top: 4,
              child: multiAccountWidget!,
            ),
          Positioned.fill(
            child: Center(
              child:
                  titleWidget ?? AdaText(title, style: context.title1Bold.copyWith(color: context.scheme().titleText)),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Material(
              color: Colors.transparent,
              child: action ?? Container(),
            ),
          ),
          Visibility(
            visible: showDivider,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 1,
                width: double.infinity,
                color: context.scheme().divider,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
