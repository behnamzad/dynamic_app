import 'package:dynamic_app/core/util/common_ui_imports.dart';

class BottomSheetHeader extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? subTitle;
  final Widget? icon;
  final Widget? closeIcon;
  final Function? onClosePressed;
  final bool showDivider;
  final bool showClose;
  final bool isNumericTitle;
  final bool showHandler;
  final double? bottomDividerPadding;
  final double? bottomTitlePadding;
  final double? bottomHandlerPadding;
  final TextDirection? textDirection;
  final TextDirection? subTitleDirection;

  const BottomSheetHeader({
    Key? key,
    required this.title,
    this.titleWidget,
    this.icon,
    this.onClosePressed,
    this.showHandler = false,
    this.closeIcon,
    this.showDivider = true,
    this.showClose = false,
    this.isNumericTitle = false,
    this.textDirection,
    this.bottomDividerPadding,
    this.subTitle,
    this.bottomTitlePadding,
    this.subTitleDirection,
    this.bottomHandlerPadding,
  }) : super(key: key);

  const BottomSheetHeader.withHandler({
    Key? key,
    this.showHandler = true,
    this.title,
    this.titleWidget,
    this.icon,
    this.closeIcon,
    this.showClose = false,
    this.onClosePressed,
    this.showDivider = false,
    this.isNumericTitle = false,
    this.textDirection,
    this.subTitle,
    this.bottomDividerPadding,
    this.bottomTitlePadding,
    this.subTitleDirection,
    this.bottomHandlerPadding,
  }) : super(key: key);

  const BottomSheetHeader.withClose({
    Key? key,
    this.showHandler = true,
    this.title,
    this.titleWidget,
    this.icon,
    this.closeIcon,
    this.onClosePressed,
    this.showDivider = false,
    this.isNumericTitle = false,
    this.textDirection,
    this.subTitle,
    this.bottomDividerPadding,
    this.bottomTitlePadding,
    this.subTitleDirection,
    this.bottomHandlerPadding,
  }) : showClose = true,
       super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showClose) {
      return buildHeaderWithCloseAndBilbilakTitle(context);
    } else {
      return showHandler
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: bottomHandlerPadding ?? 8),
                  height: 4,
                  width: 38,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: context.scheme().bilbilakBottomSheet,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                titleWidget ??
                    Visibility(
                      visible: title != null,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2, bottom: bottomTitlePadding ?? 12),
                        child: BzText(title ?? '', style: context.title2Bold, textDirection: textDirection),
                      ),
                    ),
                Visibility(
                  visible: subTitle != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 4),
                    child: BzText(
                      subTitle ?? '',
                      style: context.body1Regular.copyWith(color: context.scheme().subText),
                      textDirection: subTitleDirection ?? textDirection,
                    ),
                  ),
                ),
                Visibility(
                  visible: showDivider,
                  child: Column(
                    children: [
                      SizedBox(height: 3),
                      Divider(height: 0.7, thickness: 0.7, color: context.scheme().divider),
                      SizedBox(height: bottomDividerPadding ?? 16),
                    ],
                  ),
                ),
              ],
            )
          : Directionality(
              textDirection: textDirection ?? TextDirection.rtl,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (icon != null) Padding(padding: const EdgeInsets.only(top: 4), child: icon),
                        if (icon != null) const SizedBox(width: 12),
                        isNumericTitle
                            ? Expanded(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: BzText(title ?? '', style: context.title2Medium),
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: BzText(title ?? '', style: context.title2Medium, textAlign: TextAlign.center),
                                ),
                              ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(Dimen.defaultRadius)),
                            onTap: () {
                              if (onClosePressed != null) {
                                onClosePressed;
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, right: 10, left: 10, bottom: 6),
                              child: Container(
                                constraints: const BoxConstraints(minHeight: 38),
                                child: Center(
                                  child:
                                      closeIcon ?? //todo ad close icon later
                                      Icon(Icons.close, color: context.scheme().mainBackground1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showDivider,
                    child: Divider(height: 3, thickness: 1, color: context.scheme().divider),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
    }
  }

  Widget buildHeaderWithCloseAndBilbilakTitle(BuildContext context) {
    return SizedBox(
      height: 68,
      child: Stack(
        children: [
          Positioned(
            right: 15.0,
            top: 36.0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => Navigator.of(context).pop(),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Icon(Icons.close_rounded, color: context.scheme().titleText, size: 24),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: 4,
                    width: 38,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: context.scheme().bilbilakBottomSheet,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  Visibility(
                    visible: title != null,
                    child: Padding(
                      padding: EdgeInsets.only(top: bottomHandlerPadding ?? 10),
                      child: BzText(title ?? '', style: context.title2Bold, textDirection: textDirection),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderWithCloseAndBilbilak(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Stack(
        children: [
          Positioned(
            right: 6.0,
            top: 6.0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => Navigator.of(context).pop(),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.close_rounded, color: context.scheme().titleText, size: 24),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                height: 4,
                width: 38,
                decoration: BoxDecoration(
                  color: context.scheme().bilbilakBottomSheet,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
