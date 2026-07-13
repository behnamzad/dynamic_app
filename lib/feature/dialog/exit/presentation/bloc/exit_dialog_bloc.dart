// import 'package:ada_flutter_banking/core/local/user/user_manager.dart';
// import 'package:ada_flutter_banking/core/util/app_clear_data_util.dart';
// import 'package:ada_flutter_banking/data_provider/ada/active_device_manager/active_device_manager.dart';
// import 'package:ada_flutter_banking/di/injection_container.dart';
// import 'package:bloc/bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:injectable/injectable.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// part 'exit_dialog_bloc.freezed.dart';
// part 'exit_dialog_event.dart';
// part 'exit_dialog_state.dart';
//
// @injectable
// class ExitDialogBloc extends Bloc<ExitDialogEvent, ExitDialogState> {
//   final UserManager userManager;
//   final SharedPreferences sharePrefs;
//   final ActiveDeviceManager activeDeviceManager;
//
//   ExitDialogBloc(this.userManager, this.sharePrefs, this.activeDeviceManager) : super(const ExitDialogState()) {
//     on<_ClearUserData>(_onClearUserData);
//   }
//
//   _onClearUserData(event, Emitter<ExitDialogState> emit) async {
//     emit(state.copyWith(status: MainStatus.loading));
//
//     bool isClearSharePrefs =
//         await inject<AppClearDataUtil>().clearAlAppData(deleteCurrentAccountFromMultiAccount: true);
//     if (isClearSharePrefs) {
//       emit(state.copyWith(status: MainStatus.userRemoved));
//     }
//
//     ///if call remove-active-device service, need session and show login dialog in agreement page before login
//     /* await activeDeviceManager.removeActiveDevice( onSuccess: (data) async {
//       bool isClearSharePrefs = await inject<AppClearDataUtil>().clearAlAppData(deleteCurrentAccountFromMultiAccount: true);
//       if (isClearSharePrefs) {
//         emit(state.copyWith(status: MainStatus.userRemoved));
//       }
//     }, onError: (apiError){
//       emit(state.copyWith(status: MainStatus.failure));
//     });*/
//   }
// }
