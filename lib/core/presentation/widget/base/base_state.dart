import 'package:dynamic_app/core/presentation/bloc/base_app/app_base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {}

///============= Over page ================
_startLoading({required BuildContext buildContext, String? loadingMessage}) {
  buildContext
      .read<AppBaseBloc>()
      .add(AppBaseEvent.changeLoading(isStartLoading: true, loadingMessage: loadingMessage));
}

_stopLoading({required BuildContext buildContext}) {
  buildContext.read<AppBaseBloc>().add(const AppBaseEvent.changeLoading(isStartLoading: false));
}

updateLoadingStatus({required BuildContext context, required bool isShowLoading, String? message}) {
  isShowLoading ? _startLoading(buildContext: context, loadingMessage: message) : _stopLoading(buildContext: context);
}

///============= OverBottomSheet ================
_startLoadingOverBottomSheet({required BuildContext buildContext, String? loadingMessage}) {
  buildContext
      .read<AppBaseBloc>()
      .add(AppBaseEvent.changeLoadingOverBottomSheet(isStartLoading: true, loadingMessage: loadingMessage));
}

_stopLoadingOverBottomSheet({required BuildContext buildContext, String? loadingMessage}) {
  buildContext
      .read<AppBaseBloc>()
      .add(AppBaseEvent.changeLoadingOverBottomSheet(isStartLoading: false, loadingMessage: loadingMessage));
}

updateLoadingOverBottomSheetStatus({required BuildContext context, required bool isShowLoading, String? message}) {
  isShowLoading
      ? _startLoadingOverBottomSheet(buildContext: context, loadingMessage: message)
      : _stopLoadingOverBottomSheet(buildContext: context);
}

changeTheme({required BuildContext context, required ThemeMode selectedThemeMode}) {
  context.read<AppBaseBloc>().add(AppBaseEvent.changeTheme(themeMode: selectedThemeMode));
}
