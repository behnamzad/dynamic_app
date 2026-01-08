part of 'app_base_bloc.dart';

@freezed
class AppBaseEvent with _$AppBaseEvent {
  const factory AppBaseEvent.changeLoading({required bool isStartLoading, String? loadingMessage}) =
      _ChangeLoading;
  const factory AppBaseEvent.changeLoadingOverBottomSheet({required bool isStartLoading, String? loadingMessage}) =
      _ChangeLoadingOverBottomSheet;

  const factory AppBaseEvent.changeTheme({required ThemeMode themeMode}) =_ChangeTheme;
}
