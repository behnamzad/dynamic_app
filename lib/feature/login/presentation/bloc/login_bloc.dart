import 'dart:async';

import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/feature/login/domain/entities/login_feedback.dart';
import 'package:dynamic_app/feature/login/domain/repository/login_repo.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo _repo;
  final UserManager _userManager;

  LoginBloc(this._repo, this._userManager) : super(LoginState.initial()) {
    on<_Init>(_onInit);
    on<_ChangeMode>(_onChangeMode);
    on<_Login>(_onLogin);
    on<_Register>(_onRegister);
  }

  FutureOr<void> _onInit(_Init event, Emitter<LoginState> emit) {
    // شروع صفحه لاگین اینجاست؛ کاربر ذخیره‌شده و ایمیل آخرین ورود از UserManager خوانده می‌شود.
    _userManager.loadSavedUser();
    emit(state.copyWith(email: _userManager.savedLoginEmail));
  }

  FutureOr<void> _onChangeMode(_ChangeMode event, Emitter<LoginState> emit) {
    // تغییر مود از UI شروع می‌شود و فیلدها با تغییر state در صفحه خالی می‌شوند.
    emit(
      state.copyWith(
        mode: event.mode,
        status: Status.initial,
        userName: null,
        email: null,
        passWord: null,
        feedbackCode: LoginFeedbackCode.none,
      ),
    );
  }

  Future<void> _onLogin(_Login event, Emitter<LoginState> emit) async {
    final email = event.email.trim();
    final password = event.password.trim();

    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(status: Status.invalidInput, feedbackCode: LoginFeedbackCode.emptyLoginInputs));
      return;
    }

    if (!_isValidEmail(email)) {
      emit(state.copyWith(status: Status.invalidInput, feedbackCode: LoginFeedbackCode.invalidEmail));
      return;
    }

    if (password.length < 6) {
      emit(state.copyWith(status: Status.invalidInput, feedbackCode: LoginFeedbackCode.weakPassword));
      return;
    }

    emit(state.copyWith(status: Status.loading, errorMessage: null, feedbackCode: LoginFeedbackCode.none));
    final response = await _repo.login(email, password);

    await response.when(
      completed: (data, statusCode) async {
        // نتیجه موفق از dataSource به Bloc می‌رسد و به پیام قابل نمایش برای UI تبدیل می‌شود.
        if (data.user != null) {
          await _userManager.setCurrentUserFromSupabase(user: data.user!, session: data.session);
        }
        emit(
          state.copyWith(
            status: Status.success,
            email: email,
            passWord: password,
            feedbackCode: LoginFeedbackCode.loginSuccess,
          ),
        );
      },
      error: (apiError) async {
        final feedbackCode = loginFeedbackCodeFromSupabaseMessage(apiError.message);
        emit(state.copyWith(status: Status.error, errorMessage: apiError.message, feedbackCode: feedbackCode));
      },
    );
  }

  Future<void> _onRegister(_Register event, Emitter<LoginState> emit) async {
    final email = event.email.trim();
    final username = event.username.trim();
    final password = event.password.trim();
    final gender = event.gender.trim();
    final age = event.age;

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      emit(state.copyWith(status: Status.invalidInput, feedbackCode: LoginFeedbackCode.emptyRegisterInputs));
      return;
    }

    if (gender.isEmpty) {
      emit(state.copyWith(status: Status.invalidInput, feedbackCode: LoginFeedbackCode.emptyGender));
      return;
    }

    if (age == null || age < 7 || age > 120) {
      emit(state.copyWith(status: Status.invalidInput, feedbackCode: LoginFeedbackCode.invalidAge));
      return;
    }

    if (!_isValidEmail(email)) {
      emit(state.copyWith(status: Status.invalidInput, feedbackCode: LoginFeedbackCode.invalidEmail));
      return;
    }

    if (password.length < 6) {
      emit(state.copyWith(status: Status.invalidInput, feedbackCode: LoginFeedbackCode.weakPassword));
      return;
    }

    emit(state.copyWith(status: Status.loading, errorMessage: null, feedbackCode: LoginFeedbackCode.none));

    final usernameResponse = await _repo.isUsernameAvailable(username);
    final isUsernameAvailable = usernameResponse.when(
      completed: (data, statusCode) => data,
      error: (apiError) => null,
    );

    if (isUsernameAvailable == false) {
      emit(state.copyWith(status: Status.error, feedbackCode: LoginFeedbackCode.usernameAlreadyTaken));
      return;
    }

    if (isUsernameAvailable == null) {
      emit(state.copyWith(status: Status.error, feedbackCode: LoginFeedbackCode.serverUnavailable));
      return;
    }

    final response = await _repo.register(email, username, password, gender, age);

    response.when(
      completed: (data, statusCode) {
        // نتیجه ثبت‌نام موفق اینجا به enum تبدیل می‌شود تا UI متن فارسی ثابت نمایش دهد.
        emit(
          state.copyWith(
            status: Status.success,
            mode: LoginMode.login,
            userName: null,
            email: email,
            passWord: null,
            feedbackCode: LoginFeedbackCode.registerSuccess,
          ),
        );
      },
      error: (apiError) {
        final feedbackCode = loginFeedbackCodeFromSupabaseMessage(apiError.message);
        emit(state.copyWith(status: Status.error, errorMessage: apiError.message, feedbackCode: feedbackCode));
      },
    );
  }

  bool _isValidEmail(String email) {
    // اعتبارسنجی ساده کلاینتی؛ Supabase Auth در نهایت ایمیل واقعی و رمز را برای ورود نیاز دارد.
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }
}
