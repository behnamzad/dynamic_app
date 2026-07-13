import 'package:dynamic_app/core/presentation/bloc/base_app/app_base_bloc.dart';
import 'package:dynamic_app/core/presentation/widget/bottom_sheet/bz_bottom_sheet.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:injectable/injectable.dart';

@injectable
class BottomSheetUtil {
  Future<dynamic> _openBottomSheet(
    BuildContext context, {
    required Widget contentChild,
    String? title,
    Widget? titleWidget,
    String? subTitle,
    TextDirection? subTitleDirection,
    bool isWithoutHandler = false,
    bool isHaveHeightFactor = false,
    bool isFullScreen = false,
    bool isFullBottomSheet = false,
    bool? isDismissible,
    TextDirection? textDirection,
    double? horizontalPadding,
    double? bottomDividerPadding,
    double? bottomTitlePadding,
    double? bottomHandlerPadding,
    double? topPadding,
    bool showDivider = false,
    EdgeInsets? margin,
  }) {
    if (context.read<AppBaseBloc>().state.overlayLoadingStatus.isStartLoadingOverBottomSheet) {
      updateLoadingOverBottomSheetStatus(context: context, isShowLoading: false);
    }

    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: (isDismissible ?? !isFullScreen),
      isScrollControlled: true,
      isDismissible: (isDismissible ?? !isFullScreen),
      barrierColor: context.scheme().brightness == Brightness.light ? null : Colors.black.withValues(alpha: 0.7),
      backgroundColor: Colors.transparent,
      builder: (builder) {
        if (isWithoutHandler) {
          return FractionallySizedBox(
            heightFactor: isHaveHeightFactor ? null : 1,
            child: BzBottomSheet.withoutHandler(
              title: title,
              titleWidget: titleWidget,
              subTitle: subTitle,
              subTitleDirection: subTitleDirection,
              isFullScreen: isFullScreen,
              textDirection: textDirection,
              horizontalPadding: horizontalPadding,
              topPadding: topPadding,
              bottomHandlerPadding: bottomHandlerPadding,
              child: contentChild,
            ),
          );
        } else if (isFullBottomSheet) {
          return BzBottomSheet.fullBottomSheet(
            title: title,
            titleWidget: titleWidget,
            subTitle: subTitle,
            subTitleDirection: subTitleDirection,
            textDirection: textDirection,
            horizontalPadding: horizontalPadding,
            showDivider: showDivider,
            bottomDividerPadding: bottomDividerPadding,
            topPadding: topPadding,
            bottomHandlerPadding: bottomHandlerPadding,
            child: contentChild,
          );
        } else {
          return BzBottomSheet(
            title: title,
            titleWidget: titleWidget,
            subTitle: subTitle,
            subTitleDirection: subTitleDirection,
            textDirection: textDirection,
            horizontalPadding: horizontalPadding,
            showDivider: showDivider,
            bottomDividerPadding: bottomDividerPadding,
            bottomTitlePadding: bottomTitlePadding,
            bottomHandlerPadding: bottomHandlerPadding,
            topPadding: topPadding,
            margin: margin,
            child: contentChild,
          );
        }
      },
    );
  }

  Future<dynamic> openBottomSheet(
    BuildContext context, {
    required Widget contentChild,
    String? title,
    Widget? titleWidget,
    String? subTitle,
    TextDirection? subTitleDirection,
    bool isWithoutHandler = false,
    bool? isDismissible,
    bool isFullScreen = false,
    bool isHaveHeightFactor = false,
    bool showDivider = false,
    double? horizontalPadding,
    double? bottomDividerPadding,
    double? bottomTitlePadding,
    double? bottomHandlerPadding,
    double? topPadding,
  }) {
    return _openBottomSheet(
      context,
      contentChild: contentChild,
      title: title,
      titleWidget: titleWidget,
      subTitle: subTitle,
      subTitleDirection: subTitleDirection,
      isDismissible: isDismissible,
      isFullScreen: isFullScreen,
      showDivider: showDivider,
      isHaveHeightFactor: isHaveHeightFactor,
      isWithoutHandler: isWithoutHandler,
      horizontalPadding: horizontalPadding,
      bottomDividerPadding: bottomDividerPadding,
      bottomTitlePadding: bottomTitlePadding,
      bottomHandlerPadding: bottomHandlerPadding,
      topPadding: topPadding,
    );
  }

  Future<dynamic> openRawBottomSheet(BuildContext context, {required Widget contentChild, bool useSafeArea = true}) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: useSafeArea,
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: context.scheme().brightness == Brightness.light ? null : Colors.black.withValues(alpha: 0.7),
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: context.scheme().dialogBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimen.bottomSheetRadius),
              topRight: Radius.circular(Dimen.bottomSheetRadius),
            ),
          ),
          child: contentChild,
        );
      },
    );
  }
}

BottomSheetUtil bsUtil = inject<BottomSheetUtil>();
