import 'dart:async';

import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/feature/login/domain/repository/login_repo.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo _repo;

  LoginBloc(this._repo) : super(LoginState.initial()) {
    on<_Init>(_onInit);
  }

  FutureOr<void> _onInit(_Init event, Emitter<LoginState> emit) {}
}
