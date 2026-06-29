import 'dart:async';

import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/data_provider/product/domain/repository/product_repo.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ProductRepo _productRepo;

  LoginBloc(this._productRepo) : super(LoginState.initial()) {
    // on<_Init>(_onInit);
  }

  FutureOr<void> _onInit(_Init event, Emitter<LoginState> emit) {}
}
