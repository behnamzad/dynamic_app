import 'package:dynamic_app/core/config/dimen.dart';
import 'package:dynamic_app/core/config/strings.dart';
import 'package:dynamic_app/core/presentation/bloc/base_app/app_base_bloc.dart';
import 'package:dynamic_app/core/presentation/widget/bz_overlay_loading_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_retry_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_text.dart';
import 'package:dynamic_app/core/style/app_theme.dart';
import 'package:dynamic_app/core/util/extension/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

enum PageLoadingMode { onScreen, overlay, onScreenAndOverlay, none }

class BasePageWidget extends StatefulWidget {
  const BasePageWidget(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.statusBarColor,
      this.systemNavigationBarColor,
      this.systemNavigationBarIconBrightness,
      this.statusBarIconBrightness,
      this.appBar,
      this.onScreenLoadingModeShowCircularLoadingByState = false,
      this.onScreenLoadingModeDescription,
      this.onScreenLoadingModeShowFailureByState,
      this.onScreenLoadingOnTryAgainCLick,
      this.bottomNav,
      this.failureMessage,
      this.resizeToAvoidBottomInset = true,
      this.floatingActionButton,
      this.topLoadingMargin = 0,
      this.appBarAreaHeight,})
      : pageLoadingMode = PageLoadingMode.none;

  const BasePageWidget.withOverlayLoading(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.statusBarColor,
      this.systemNavigationBarColor,
      this.systemNavigationBarIconBrightness,
      this.statusBarIconBrightness,
      this.appBar,
      this.onScreenLoadingModeDescription,
      this.onScreenLoadingModeShowCircularLoadingByState = false,
      this.onScreenLoadingModeShowFailureByState = false,
      this.onScreenLoadingOnTryAgainCLick,
      this.bottomNav,
      this.failureMessage,
      this.resizeToAvoidBottomInset = true,
      this.floatingActionButton,
      this.topLoadingMargin = 0,
      this.appBarAreaHeight,})
      : pageLoadingMode = PageLoadingMode.overlay;

  const BasePageWidget.withOnScreenLoading(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.statusBarColor,
      this.systemNavigationBarColor,
      this.systemNavigationBarIconBrightness,
      this.statusBarIconBrightness,
      this.appBar,
      this.onScreenLoadingModeDescription,
      this.onScreenLoadingOnTryAgainCLick,
      required this.onScreenLoadingModeShowCircularLoadingByState,
      required this.onScreenLoadingModeShowFailureByState,
      this.bottomNav,
      this.failureMessage,
      this.resizeToAvoidBottomInset = true,
      this.floatingActionButton,
      this.topLoadingMargin = 0,
      this.appBarAreaHeight,})
      : pageLoadingMode = PageLoadingMode.onScreen;

  const BasePageWidget.withOnScreenAndOverLayLoading(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.statusBarColor,
      this.systemNavigationBarColor,
      this.systemNavigationBarIconBrightness,
      this.statusBarIconBrightness,
      this.appBar,
      this.onScreenLoadingModeDescription,
      required this.onScreenLoadingModeShowCircularLoadingByState,
      required this.onScreenLoadingModeShowFailureByState,
      this.onScreenLoadingOnTryAgainCLick,
      this.bottomNav,
      this.failureMessage,
      this.resizeToAvoidBottomInset = true,
      this.floatingActionButton,
      this.topLoadingMargin = 0,
      this.appBarAreaHeight,})
      : pageLoadingMode = PageLoadingMode.onScreenAndOverlay;

  final Widget child;
  final Widget? bottomNav;
  final Color? backgroundColor;
  final Color? statusBarColor;
  final Color? systemNavigationBarColor;
  final Brightness? systemNavigationBarIconBrightness;
  final Brightness? statusBarIconBrightness;
  final Widget? appBar;
  final double? appBarAreaHeight;
  final bool? onScreenLoadingModeShowCircularLoadingByState;
  final String? onScreenLoadingModeDescription;
  final bool? onScreenLoadingModeShowFailureByState;
  final Function? onScreenLoadingOnTryAgainCLick;
  final PageLoadingMode pageLoadingMode;
  final String? failureMessage;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingActionButton;
  final double topLoadingMargin;

  @override
  State<BasePageWidget> createState() => _BasePageWidgetState();
}

class _BasePageWidgetState extends State<BasePageWidget> {
  @override
  Widget build(BuildContext context) {
    return (widget.pageLoadingMode == PageLoadingMode.overlay ||
            widget.pageLoadingMode == PageLoadingMode.onScreenAndOverlay)
        ? BlocBuilder<AppBaseBloc, AppBaseState>(
            builder: (context, overlayLoadingState) {
              debugPrint('overlayLoadingState  ${overlayLoadingState.overlayLoadingStatus}');
              return Directionality(
                textDirection: TextDirection.rtl,
                child: LoadingOverlay(
                  color: context.scheme().dialogShadow.withValues(alpha: 0.9),
                  isLoading: overlayLoadingState.overlayLoadingStatus.isStartLoading,
                  progressIndicator: BzOverLayLoadingWidget(message: overlayLoadingState.loadingMessage),
                  child: getScaffold(),
                ),
              );
            },
          )
        : getScaffold();
  }

  getScaffold() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _setSystemChrome(context),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset ?? true,
          backgroundColor: widget.backgroundColor,
          appBar: widget.appBar != null
              ? PreferredSize(
                  preferredSize: Size.fromHeight(widget.appBarAreaHeight ?? Dimen.appBarHeight),
                  child: widget.appBar ?? const SizedBox(),
                )
              : null,
          bottomNavigationBar: widget.bottomNav,
          body: SafeArea(
            child: _getMainWidget(context),
          ),
        ),
      ),
    );
  }

  _getStatusColor(context) {
    if (widget.statusBarColor != null) {
      return widget.statusBarColor;
    } else if (widget.backgroundColor != null) {
      return widget.backgroundColor;
    } else {
      // return Theme.of(context).scaffoldBackgroundColor;
      return Colors.transparent; // use for show transparent status bar when open bottom sheet
    }
  }

  _getNavigationColor(context) {
    if (widget.systemNavigationBarColor != null) {
      return widget.systemNavigationBarColor;
    } else if (widget.backgroundColor != null) {
      return widget.backgroundColor;
    } else {
      return Theme.of(context).scaffoldBackgroundColor;
    }
  }

  _setSystemChrome(context) {
    return SystemUiOverlayStyle(
      statusBarIconBrightness: widget.statusBarIconBrightness ?? _getStatusDefaultBrightness(context),
      systemNavigationBarColor: _getNavigationColor(context),
      statusBarColor: _getStatusColor(context),
      systemNavigationBarIconBrightness:
          widget.systemNavigationBarIconBrightness ?? _getStatusDefaultBrightness(context),
    );
  }

  _getStatusDefaultBrightness(context) {
    return Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark;
  }

  Widget _getMainWidget(BuildContext context) {
    if (widget.pageLoadingMode == PageLoadingMode.onScreen ||
        widget.pageLoadingMode == PageLoadingMode.onScreenAndOverlay) {
      if (widget.onScreenLoadingModeShowCircularLoadingByState == true) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: widget.topLoadingMargin),
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              BzText(
                widget.onScreenLoadingModeDescription ?? ss.fetchingData,
                style: context.body1Regular.copyWith(
                  color: context.scheme().mainText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 56),
            ],
          ),
        );
      } else if (widget.onScreenLoadingModeShowFailureByState == true) {
        return BzRetryWidget(
            message: widget.failureMessage,
            onRetryClick: () {
              if (widget.onScreenLoadingOnTryAgainCLick != null) widget.onScreenLoadingOnTryAgainCLick!();
            },);
      } else {
        return widget.child;
      }
    } else {
      return widget.child;
    }
  }
}
