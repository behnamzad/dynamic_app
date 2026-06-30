part of 'app_base_bloc.dart';

enum OverlayLoadingStatus {
  startLoading,
  stopLoading,
  startLoadingOverBottomSheet,
  stopLoadingOverBottomSheet;

  bool get isStartLoading => this == OverlayLoadingStatus.startLoading;

  bool get isStopLoading => this == OverlayLoadingStatus.stopLoading;

  bool get isStopLoadingOverBottomSheet => this == OverlayLoadingStatus.stopLoadingOverBottomSheet;

  bool get isStartLoadingOverBottomSheet => this == OverlayLoadingStatus.startLoadingOverBottomSheet;
}

enum ThemeStatus {
  initialDefaultTheme,
  changeThemeDone;

  bool get isInitialDefaultTheme => this == ThemeStatus.initialDefaultTheme;

  bool get isChangeThemeDone => this == ThemeStatus.changeThemeDone;
}

@freezed
class AppBaseState with _$AppBaseState {
  const factory AppBaseState(
      {@Default(OverlayLoadingStatus.stopLoading) OverlayLoadingStatus overlayLoadingStatus,
      @Default(ThemeStatus.initialDefaultTheme) ThemeStatus themeStatus,
      String? loadingMessage,
      int? salt,
      @Default(ThemeMode.system) ThemeMode themeMode,}) = _AppBaseState;
}
