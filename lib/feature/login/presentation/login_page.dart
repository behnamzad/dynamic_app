import 'dart:math';

import 'package:dynamic_app/core/presentation/widget/bz_multi_text_filed.dart';
import 'package:dynamic_app/core/presentation/widget/bz_text_field.dart';
import 'package:dynamic_app/core/util/app_device_info_util.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/core/util/input_formatters_regex_utils.dart';
import 'package:dynamic_app/feature/login/domain/entities/login_feedback.dart';
import 'package:dynamic_app/feature/login/presentation/bloc/login_bloc.dart';
import 'package:flutter/services.dart';

@RoutePage()
class LoginPage extends StatefulWidget implements AutoRouteWrapper {
  const LoginPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => inject<LoginBloc>()..add(const LoginEvent.init()), child: this);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with InputFormattersRegexUtils, WidgetsBindingObserver {
  late final ValueNotifier<bool> _keyboardVisibilityValueNotifier;
  late final ScrollController _scrollController;
  late final TextEditingController _emailTextEditingController;
  late final TextEditingController _usernameTextEditingController;
  late final TextEditingController _passwordTextEditingController;
  late final TextEditingController _ageTextEditingController;
  String? _selectedGender;
  LoginMode? _lastMode;
  FocusNode currentPassFocusNode = FocusNode();

  @override
  void initState() {
    _keyboardVisibilityValueNotifier = ValueNotifier(true);
    _scrollController = ScrollController();
    _emailTextEditingController = TextEditingController();
    _usernameTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _ageTextEditingController = TextEditingController();
    _passwordTextEditingController.clear();

    super.initState();
  }

  @override
  void dispose() {
    _keyboardVisibilityValueNotifier.dispose();
    _scrollController.dispose();
    _emailTextEditingController.dispose();
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _ageTextEditingController.dispose();
    currentPassFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardVisibilityValueNotifier.addListener(() => changeScroll());
    });
    _keyboardVisibilityValueNotifier.value = MediaQuery.of(context).viewInsets.bottom != 0;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        _showLoginFeedback(state.feedbackCode);
        _syncLoginModeAndSavedEmail(state);
        if (state.status.isSuccess && state.feedbackCode == LoginFeedbackCode.loginSuccess) {
          context.replaceRoute(HomePageRoute());
        }
      },
      builder: (context, state) {
        return BasePageWidget(
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      collapsedHeight: Dimen.appBarHeight,
                      automaticallyImplyLeading: false,
                      backgroundColor: context.scheme().mainBackground1,
                      title: Visibility(
                        visible: _keyboardVisibilityValueNotifier.value,
                        child: Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Center(
                            child: BzText(
                              ss.storeName,
                              style: context.headline1Bold.copyWith(color: context.scheme().primary),
                            ),
                            // child: as.headerLogo.svg(
                            //   width: dimen.bankHeaderLogoAppBarWidth,
                            //   height: dimen.bankHeaderLogoAppBarHeight,
                            // ),
                          ),
                        ),
                      ),
                      pinned: true,
                      floating: true,
                      expandedHeight: 224,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Visibility(
                          visible: !_keyboardVisibilityValueNotifier.value,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 64),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                children: [
                                  Icon(Icons.storefront_sharp, size: 78, color: context.scheme().primary),
                                  const VGap(8),
                                  BzText(
                                    ss.storeName,
                                    style: context.headline2Bold.copyWith(color: context.scheme().primary),
                                  ),
                                ],
                              ),
                              // child: as.headerLogo.svg(
                              //   width: 200,
                              //   //height: dimen.bankHeaderLogoHeight,
                              // ),
                            ),
                          ),
                        ),
                        collapseMode: CollapseMode.parallax,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          height:
                              MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).viewPadding.top +
                                  Dimen.appBarHeight +
                                  max((MediaQuery.of(context).viewPadding.bottom - 24), 0)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MultiTextField(
                                margin: const EdgeInsets.only(bottom: 8),
                                isKeyBoardOpen: _keyboardVisibilityValueNotifier.value,
                                textFields: [
                                  BzTextField.borderLess(
                                    key: const Key('email'),
                                    hint: 'ایمیل',
                                    textEditingController: _emailTextEditingController,
                                    keyboardType: TextInputType.emailAddress,
                                    textAlign: TextAlign.left,
                                    textDirection: TextDirection.ltr,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp(regexPersianCharacterExceptDigit)),
                                    ],
                                    hintDirection: TextDirection.rtl,
                                    enabled: !state.status.isLoading,
                                  ),
                                  if (state.mode.isRegister)
                                    BzTextField.borderLess(
                                      key: const Key('userName'),
                                      hint: ss.username,
                                      textEditingController: _usernameTextEditingController,
                                      keyboardType: TextInputType.text,
                                      textAlign: TextAlign.left,
                                      textDirection: TextDirection.ltr,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(RegExp(regexPersianCharacterExceptDigit)),
                                      ],
                                      hintDirection: TextDirection.rtl,
                                      enabled: !state.status.isLoading,
                                    ),
                                  if (state.mode.isRegister)
                                    BzTextField.borderLess(
                                      key: const Key('age'),
                                      hint: 'سن',
                                      textEditingController: _ageTextEditingController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.left,
                                      textDirection: TextDirection.ltr,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      hintDirection: TextDirection.rtl,
                                      enabled: !state.status.isLoading,
                                    ),
                                  BzTextField.borderLess(
                                    key: const Key('password'),
                                    hint: ss.password,
                                    textEditingController: _passwordTextEditingController,
                                    keyboardType: TextInputType.text,
                                    isTextFieldPassword: true,
                                    focusNode: currentPassFocusNode,
                                    textDirection: TextDirection.ltr,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp(regexPersianCharacterExceptDigit)),
                                    ],
                                    hintDirection: TextDirection.rtl,
                                    maxLength: 15,
                                    enabled: !state.status.isLoading,
                                    onChanged: (value) {},
                                  ),
                                ],
                                // footerText: state.invalidInputs![0].isMobileNumber?"a":'b',
                                footerText: state.status.isInvalidInput ? ss.usernameAndPasswordInputError : '',
                                multiRowThemeMode: state.status.isInvalidInput
                                    ? MultiTextFiledThemeMode.error
                                    : MultiTextFiledThemeMode.normal,
                              ),
                              if (state.mode.isRegister) ...[
                                const SizedBox(height: 10),
                                _genderSelector(context, state),
                              ],
                              const SizedBox(height: 12),
                              if (state.mode.isLogin) _loginBtn(state),
                              if (state.mode.isRegister) _registerSubmitBtn(state),
                              const SizedBox(height: 14),
                              if (state.mode.isLogin) _goToRegisterModeBtn(context),
                              if (state.mode.isRegister) _goToLoginModeBtn(context),
                              //const Spacer(),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 32,
                  child: Visibility(
                    visible: !_keyboardVisibilityValueNotifier.value,
                    child: BzText(
                      '${ss.version} ${inject<AppDeviceInfoUtil>().appVersion}',
                      style: context.title2Regular.copyWith(color: context.scheme().subText),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //region Widgets
  void _syncLoginModeAndSavedEmail(LoginState state) {
    if (_lastMode != null && _lastMode != state.mode) {
      _clearInputs();
    }
    _lastMode = state.mode;

    // بعد از اولین ورود موفق، ایمیل از SharedPreferences داخل Bloc خوانده می‌شود و اینجا در UI می‌نشیند.
    if (state.email != null && state.email!.isNotEmpty && _emailTextEditingController.text.isEmpty) {
      _emailTextEditingController.text = state.email!;
    }
  }

  void _clearInputs() {
    _emailTextEditingController.clear();
    _usernameTextEditingController.clear();
    _passwordTextEditingController.clear();
    _ageTextEditingController.clear();
    setState(() {
      _selectedGender = null;
    });
  }

  void _showLoginFeedback(LoginFeedbackCode feedbackCode) {
    if (feedbackCode == LoginFeedbackCode.none) {
      return;
    }

    // پیام نهایی از LoginBloc با enum می‌آید؛ اینجا فقط نوع toast مناسب انتخاب می‌شود.
    switch (feedbackCode.type) {
      case LoginFeedbackType.clientError:
        showToast(feedbackCode.message);
        break;
      case LoginFeedbackType.serverError:
        showToastError(feedbackCode.message);
        break;
      case LoginFeedbackType.success:
        showToastSuccess(feedbackCode.message);
        break;
      case LoginFeedbackType.warning:
        showToastWarning(feedbackCode.message);
        break;
      case LoginFeedbackType.none:
        break;
    }
  }

  Widget _loginBtn(LoginState state) {
    return BzButton.submit(
      text: ss.login,
      showLoading: state.status.isLoading,
      onPressed: () {
        // این دکمه فقط در مود ورود نمایش داده می‌شود و فقط عملیات login را شروع می‌کند.
        context.read<LoginBloc>().add(
          LoginEvent.login(email: _emailTextEditingController.text, password: _passwordTextEditingController.text),
        );
      },
    );
  }

  Widget _genderSelector(BuildContext context, LoginState state) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(child: _genderOption(context, title: 'خانم', value: 'female', enabled: !state.status.isLoading)),
        const HGap(10),
        Expanded(child: _genderOption(context, title: 'آقا', value: 'male', enabled: !state.status.isLoading)),
      ],
    );
  }

  Widget _genderOption(BuildContext context, {required String title, required String value, required bool enabled}) {
    final isSelected = _selectedGender == value;

    return BzGestureDetector(
      onTap: enabled
          ? () {
              setState(() {
                _selectedGender = value;
              });
            }
          : null,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? context.scheme().primary.withValues(alpha: 0.12) : context.scheme().mainBackground4,
          border: Border.all(color: isSelected ? context.scheme().primary : context.scheme().boxBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: BzText(
          title,
          style: context.title2Bold.copyWith(
            color: isSelected ? context.scheme().primary : context.scheme().mainText,
          ),
        ),
      ),
    );
  }

  Widget _registerSubmitBtn(LoginState state) {
    return BzButton.submit(
      text: ss.register,
      showLoading: state.status.isLoading,
      onPressed: () {
        // این دکمه فقط در مود ثبت‌نام نمایش داده می‌شود و فقط عملیات register را شروع می‌کند.
        context.read<LoginBloc>().add(
          LoginEvent.register(
            email: _emailTextEditingController.text,
            username: _usernameTextEditingController.text,
            password: _passwordTextEditingController.text,
            gender: _selectedGender ?? '',
            age: int.tryParse(_ageTextEditingController.text),
          ),
        );
      },
    );
  }

  Widget _goToRegisterModeBtn(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          // از مود ورود به مود ثبت‌نام می‌رویم و Bloc فیلدها را برای UI ریست می‌کند.
          context.read<LoginBloc>().add(const LoginEvent.changeMode(LoginMode.register));
        },
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: Center(
            child: BzText(
              'حساب کاربری نداری؟',
              textAlign: TextAlign.center,
              style: context.title2Bold.copyWith(fontSize: 17, color: context.scheme().primaryBold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _goToLoginModeBtn(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          // از مود ثبت‌نام به مود ورود برمی‌گردیم و UI فرم ورود را نمایش می‌دهد.
          context.read<LoginBloc>().add(const LoginEvent.changeMode(LoginMode.login));
        },
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: Center(
            child: BzText(
              'حساب کاربری داری؟ ورود',
              textAlign: TextAlign.center,
              style: context.title2Bold.copyWith(fontSize: 17, color: context.scheme().primaryBold),
            ),
          ),
        ),
      ),
    );
  }

  //endregion

  // region Function
  changeScroll() {
    var bot = _scrollController.position.minScrollExtent;
    var top = _scrollController.position.maxScrollExtent - MediaQuery.of(context).viewPadding.top;
    _scrollController.animateTo(
      _keyboardVisibilityValueNotifier.value ? top : bot,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  //endregion
}
