// import 'dart:io';
//
// import 'package:ada_flutter_banking/core/config/strings.dart';
// import 'package:ada_flutter_banking/core/presentation/widget/dialog/ada_dialog.dart';
// import 'package:ada_flutter_banking/di/injection_container.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'bloc/exit_dialog_bloc.dart';
//
// enum ExitType { justCloseApp, logOutUser }
//
// class ExitDialog extends StatefulWidget {
//   final ExitType type;
//
//   const ExitDialog({super.key, this.type = ExitType.justCloseApp});
//
//   @override
//   State<ExitDialog> createState() => _ExitDialogState();
// }
//
// class _ExitDialogState extends State<ExitDialog> {
//   ValueNotifier<bool> showConfirmButtonLoading = ValueNotifier(false);
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => inject<ExitDialogBloc>(),
//       child: BlocConsumer<ExitDialogBloc, ExitDialogState>(
//         listener: (context, state) {
//           showConfirmButtonLoading.value = state.status.isLoading;
//           if (state.status.isUserRemoved) {
//             _closeApp();
//           }
//         },
//         builder: (context, state) {
//           return AdaDialog.confirm(
//             title: ss.exitApp,
//             description: ss.exitAppDescription,
//             headerIcon: Icons.logout,
//             confirmBtnLabel: ss.confirmAndExit,
//             dismissBtnLabel: ss.previousStep,
//             onConfirmTab: () {
//               if (widget.type == ExitType.logOutUser) {
//                 context.read<ExitDialogBloc>().add(const ExitDialogEvent.clearUserData());
//               } else {
//                 _closeApp();
//               }
//             },
//             showLoadingOnConfirmNotifier: showConfirmButtonLoading,
//           );
//         },
//       ),
//     );
//   }
//
//   _closeApp() {
//     if (Platform.isAndroid) {
//       SystemNavigator.pop();
//       exit(0);
//     } else if (Platform.isIOS) {
//       SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
//     }
//   }
// }
