import 'package:dynamic_app/core/config/dimen.dart';
import 'package:dynamic_app/core/presentation/widget/ada_text.dart';
import 'package:dynamic_app/core/presentation/widget/sized_circular_progress_indicator.dart';
import 'package:dynamic_app/core/style/app_theme.dart';
import 'package:dynamic_app/core/util/extension/context_ext.dart';
import 'package:flutter/material.dart';

enum ButtonType {
  submit,
  cancel,
  outline;

  bool get isSubmit => this == ButtonType.submit;

  bool get isCancel => this == ButtonType.cancel;

  bool get isOutline => this == ButtonType.outline;
}

class AdaButton extends StatefulWidget {
  const AdaButton.submit({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.isFullWidth = true,
    this.showLoading = false,
    this.minSize = Dimen.buttonMinHeight,
    this.textFontSize,
    this.textFontWeight = FontWeight.w700,
    this.enabled = true,
    this.borderRadius = Dimen.buttonRadius,
    this.borderSize = 0,
    required this.onPressed,
    this.leftArrow = false,
    this.rightArrow = false,
    this.icon,
    this.iconSize,
    this.leftIconData,
    this.horizontalPadding,
    this.arrowIconSize,
    this.loadingSize,
    this.loadingStrokeWidth,
  })  : _buttonType = ButtonType.submit,
        borderColor = null;

  const AdaButton.cancel({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.isFullWidth = true,
    this.showLoading = false,
    this.minSize = Dimen.buttonMinHeight,
    this.textFontSize,
    this.textFontWeight = FontWeight.w700,
    this.enabled = true,
    this.borderRadius = Dimen.buttonRadius,
    this.borderSize,
    required this.onPressed,
    this.icon,
    this.iconSize,
    this.leftIconData,
    this.horizontalPadding,
    this.arrowIconSize,
    this.loadingSize,
    this.loadingStrokeWidth,
  })  : _buttonType = ButtonType.cancel,
        borderColor = null,
        leftArrow = false,
        rightArrow = false;

  const AdaButton.outline({
    super.key,
    required this.text,
    this.textColor,
    this.textStyle,
    this.borderColor,
    this.isFullWidth = true,
    this.showLoading = false,
    this.minSize = Dimen.buttonMinHeight,
    this.textFontSize,
    this.textFontWeight = FontWeight.w700,
    this.enabled = true,
    this.borderRadius = Dimen.buttonRadius,
    this.borderSize,
    this.icon,
    this.backgroundColor = Colors.transparent,
    this.iconSize,
    this.horizontalPadding,
    this.leftIconData,
    required this.onPressed,
    this.arrowIconSize,
    this.loadingSize,
    this.loadingStrokeWidth,
  })  : _buttonType = ButtonType.outline,
        leftArrow = false,
        rightArrow = false;

  final ButtonType _buttonType;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? borderColor;
  final bool isFullWidth;
  final bool showLoading;
  final double minSize;
  final double? textFontSize;
  final double? loadingSize;
  final double? loadingStrokeWidth;
  final FontWeight? textFontWeight;
  final bool enabled;
  final double borderRadius;
  final double? borderSize;
  final VoidCallback onPressed;
  final bool leftArrow;
  final bool rightArrow;
  final IconData? leftIconData;
  final Widget? icon;
  final double? iconSize;
  final double? horizontalPadding;
  final double? arrowIconSize;

  @override
  State<AdaButton> createState() => _AdaButtonState();
}

class _AdaButtonState extends State<AdaButton> {
  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius:
            BorderRadius.circular(widget._buttonType.isOutline ? widget.borderRadius : widget.borderRadius - 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: _getBackgroundColor(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          enableFeedback: false,
          // disabledColor: ,
          onTap: (widget.showLoading || !widget.enabled) ? null : widget.onPressed,
          child: SizedBox(
            height: widget.minSize,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? (widget.isFullWidth ? 0 : 32)),
                  child: Row(
                    mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: widget.icon != null && !widget.showLoading,
                        child: SizedBox(
                          width: widget.iconSize ?? 40,
                          height: widget.iconSize ?? 40,
                          child: widget.icon ?? Container(),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: AdaText(
                              widget.text,
                              textAlign: TextAlign.center,
                              style: widget.textStyle != null
                                  ? widget.showLoading
                                      ? widget.textStyle!.copyWith(color: Colors.transparent)
                                      : widget.textStyle
                                  : context.body1Bold.copyWith(
                                      color: widget.showLoading ? Colors.transparent : _getTextColor(context),
                                      fontSize: widget.textFontSize,
                                      fontWeight: widget.textFontWeight,
                                    ),
                            ),
                          ),
                          Visibility(
                            visible: widget.showLoading,
                            child: Center(
                              child: SizedCircularProgressIndicator(
                                width: widget.loadingSize ?? 22,
                                height: widget.loadingSize ?? 22,
                                strokeWidth: widget.loadingStrokeWidth ?? 2.8,
                                color: _getTextColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                widget.leftIconData != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Visibility(
                          visible: !widget.showLoading,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(widget.leftIconData,
                                size: widget.arrowIconSize ?? 24, color: _getTextColor(context)),
                          ),
                        ),
                      )
                    : Visibility(
                        visible: widget.leftArrow,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Visibility(
                            visible: !widget.showLoading,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.arrow_forward,
                                  size: widget.arrowIconSize ?? 24, color: _getTextColor(context)),
                            ),
                          ),
                        ),
                      ),
                Visibility(
                  visible: widget.rightArrow,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 17),
                    child: Visibility(
                      visible: !widget.showLoading,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.west, size: widget.arrowIconSize ?? 23, color: _getTextColor(context)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    button = Container(
      height: widget.minSize + 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          width: _calculateBorderWidth(),
          color: widget._buttonType.isOutline ? _getBorderColor(context) : _getBackgroundColor(context),
        ),
      ),
      child: button,
    );

    return widget.isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  double _calculateBorderWidth() {
    if (widget.borderSize != null) {
      return widget.borderSize!;
    }

    if (widget.borderColor != null &&
        widget.borderColor != context.scheme().buttonBorder2 &&
        widget.borderColor != context.scheme().buttonBorder1) {
      return Dimen.adaButtonBorderWidthBold;
    }

    return Dimen.adaButtonBorderWidth;
  }

  Color _getBackgroundColor(BuildContext context) {
    if (!widget.enabled && !widget.showLoading) {
      return _getDisableBackgroundColor(context);
    }
    return widget.backgroundColor ??
        (widget._buttonType.isSubmit
            ? context.scheme().primary
            : widget._buttonType.isCancel
                ? context.scheme().backAndCancelButtonBackground
                : context.scheme().mainBackground1);
  }

  Color _getDisableBackgroundColor(BuildContext context) {
    return widget.showLoading
        ? _getBackgroundColor(context)
        : widget._buttonType.isOutline
            ? Colors.transparent
            : context.scheme().disableButtonBackground;
  }

  Color _getTextColor(BuildContext context) {
    return widget.textColor ??
        (!widget.enabled
            ? context.scheme().disableButtonText
            : widget._buttonType.isSubmit
                ? Theme.of(context).textTheme.labelLarge!.color!
                : widget._buttonType.isCancel
                    ? context.scheme().backAndCancelButtonText
                    : context.scheme().primaryBold);
  }

  Color _getBorderColor(BuildContext context) {
    return widget.borderColor ?? context.scheme().buttonBorder2;
  }
}
