import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<_Initial>(_onInitial);
    on<_ChangeStatus>(_onChangeStatus);
  }

  FutureOr<void> _onInitial(_Initial event, Emitter<HomeState> emit) async {}

  FutureOr<void> _onChangeStatus(_ChangeStatus event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: state.status.isLoading ? HomeStatus.initial : HomeStatus.loading));
  }
}
