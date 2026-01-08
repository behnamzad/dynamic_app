import 'dart:async';

import 'package:dynamic_app/core/local/setting_manager.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'app_base_bloc.freezed.dart';
part 'app_base_event.dart';
part 'app_base_state.dart';

@lazySingleton
@injectable
class AppBaseBloc extends Bloc<AppBaseEvent, AppBaseState> {
  final SettingsManager settingsManager;

  AppBaseBloc(this.settingsManager) : super(const AppBaseState()) {
    on<_ChangeLoading>(_onChangeLoading);
    on<_ChangeLoadingOverBottomSheet>(_onChangeLoadingOverBottomSheet);
    on<_ChangeTheme>(_onChangeTheme);
  }

  bool isAutoLockActive = false;

  Future<void> _onChangeLoading(_ChangeLoading event, Emitter<AppBaseState> emit) async {
    if (event.isStartLoading) {
      emit(state.copyWith(
          overlayLoadingStatus: OverlayLoadingStatus.startLoading, loadingMessage: event.loadingMessage));
    } else {
      emit(state.copyWith(overlayLoadingStatus: OverlayLoadingStatus.stopLoading));
    }
  }

  Future<void> _onChangeLoadingOverBottomSheet(_ChangeLoadingOverBottomSheet event, Emitter<AppBaseState> emit) async {
    if (event.isStartLoading) {
      emit(state.copyWith(
          overlayLoadingStatus: OverlayLoadingStatus.startLoadingOverBottomSheet,
          loadingMessage: event.loadingMessage));
    } else {
      emit(state.copyWith(overlayLoadingStatus: OverlayLoadingStatus.stopLoadingOverBottomSheet));
    }
  }

  FutureOr<void> _onChangeTheme(_ChangeTheme event, Emitter<AppBaseState> emit) async {
    await settingsManager.setTheme(event.themeMode);
    emit(state.copyWith(
        themeStatus: ThemeStatus.changeThemeDone,
        themeMode: event.themeMode,
        salt: DateTime.now().millisecondsSinceEpoch));
  }
}
