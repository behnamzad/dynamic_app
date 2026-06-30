import 'dart:math';

import 'package:dynamic_app/core/presentation/widget/bz_multi_text_filed.dart';
import 'package:dynamic_app/core/presentation/widget/bz_text_field.dart';
import 'package:dynamic_app/core/util/app_device_info_util.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/core/util/input_formatters_regex_utils.dart';
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
  late final TextEditingController _usernameTextEditingController;
  late final TextEditingController _passwordTextEditingController;
  FocusNode currentPassFocusNode = FocusNode();

  @override
  void initState() {
    _keyboardVisibilityValueNotifier = ValueNotifier(true);
    _scrollController = ScrollController();
    _usernameTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _passwordTextEditingController.clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardVisibilityValueNotifier.addListener(() => changeScroll());
    });
    _keyboardVisibilityValueNotifier.value = MediaQuery.of(context).viewInsets.bottom != 0;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {},
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
                              const SizedBox(height: 12),
                              _loginBtn(state),
                              const SizedBox(height: 14),
                              _registerBtn(context),
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
  Widget _loginBtn(LoginState state) {
    return BzButton.submit(
      text: ss.login,
      showLoading: state.status.isLoading,
      onPressed: () {
        context.replaceRoute(HomePageRoute());
      },
    );
  }

  Widget _registerBtn(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {},
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: Center(
            child: BzText(
              ss.register,
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
