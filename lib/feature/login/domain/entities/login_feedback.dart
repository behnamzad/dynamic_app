enum LoginFeedbackType { none, success, clientError, serverError, warning }

enum LoginFeedbackCode {
  none,
  loginSuccess,
  registerSuccess,
  invalidLoginCredentials,
  weakPassword,
  emailAlreadyRegistered,
  usernameAlreadyTaken,
  emptyInputs,
  emptyLoginInputs,
  emptyRegisterInputs,
  emptyGender,
  invalidAge,
  invalidEmail,
  networkError,
  serverUnavailable,
  unknown,
}

extension LoginFeedbackCodeExt on LoginFeedbackCode {
  LoginFeedbackType get type {
    switch (this) {
      case LoginFeedbackCode.loginSuccess:
      case LoginFeedbackCode.registerSuccess:
        return LoginFeedbackType.success;
      case LoginFeedbackCode.emptyInputs:
      case LoginFeedbackCode.emptyLoginInputs:
      case LoginFeedbackCode.emptyRegisterInputs:
      case LoginFeedbackCode.emptyGender:
      case LoginFeedbackCode.invalidAge:
      case LoginFeedbackCode.weakPassword:
        return LoginFeedbackType.clientError;
      case LoginFeedbackCode.invalidLoginCredentials:
      case LoginFeedbackCode.emailAlreadyRegistered:
      case LoginFeedbackCode.usernameAlreadyTaken:
        return LoginFeedbackType.serverError;
      case LoginFeedbackCode.invalidEmail:
        return LoginFeedbackType.clientError;
      case LoginFeedbackCode.networkError:
        return LoginFeedbackType.clientError;
      case LoginFeedbackCode.serverUnavailable:
      case LoginFeedbackCode.unknown:
        return LoginFeedbackType.serverError;
      case LoginFeedbackCode.none:
        return LoginFeedbackType.none;
    }
  }

  String get message {
    switch (this) {
      case LoginFeedbackCode.loginSuccess:
        return 'ورود با موفقیت انجام شد.';
      case LoginFeedbackCode.registerSuccess:
        return 'ثبت‌نام با موفقیت انجام شد.';
      case LoginFeedbackCode.invalidLoginCredentials:
        return 'نام کاربری یا رمز عبور اشتباه است.';
      case LoginFeedbackCode.weakPassword:
        return 'رمز عبور باید حداقل ۶ کاراکتر باشد.';
      case LoginFeedbackCode.emailAlreadyRegistered:
        return 'این ایمیل قبلاً ثبت شده است.';
      case LoginFeedbackCode.usernameAlreadyTaken:
        return 'این نام کاربری قبلاً استفاده شده است.';
      case LoginFeedbackCode.emptyInputs:
        return 'اطلاعات لازم را کامل وارد کن.';
      case LoginFeedbackCode.emptyLoginInputs:
        return 'ایمیل و رمز عبور را وارد کن.';
      case LoginFeedbackCode.emptyRegisterInputs:
        return 'ایمیل، نام کاربری، رمز عبور، سن و جنسیت را کامل وارد کن.';
      case LoginFeedbackCode.emptyGender:
        return 'جنسیت را انتخاب کن.';
      case LoginFeedbackCode.invalidAge:
        return 'سن را به‌صورت عدد معتبر وارد کن.';
      case LoginFeedbackCode.invalidEmail:
        return 'فرمت ایمیل معتبر نیست.';
      case LoginFeedbackCode.networkError:
        return 'اتصال اینترنت را بررسی کن و دوباره تلاش کن.';
      case LoginFeedbackCode.serverUnavailable:
        return 'سرویس ورود موقتاً در دسترس نیست.';
      case LoginFeedbackCode.unknown:
        return 'خطای نامشخصی رخ داد. دوباره تلاش کن.';
      case LoginFeedbackCode.none:
        return '';
    }
  }
}

LoginFeedbackCode loginFeedbackCodeFromSupabaseMessage(String message) {
  final normalized = message.toLowerCase();

  // پیام خام از Supabase Auth می‌آید و اینجا برای UI به کد قابل نمایش تبدیل می‌شود.
  if (normalized.contains('invalid login credentials')) {
    return LoginFeedbackCode.invalidLoginCredentials;
  }
  if (normalized.contains('password should be at least') || normalized.contains('weak password')) {
    return LoginFeedbackCode.weakPassword;
  }
  if (normalized.contains('already registered') ||
      normalized.contains('already exists') ||
      normalized.contains('user already registered')) {
    return LoginFeedbackCode.emailAlreadyRegistered;
  }
  if (normalized.contains('invalid email')) {
    return LoginFeedbackCode.invalidEmail;
  }
  if (normalized.contains('socket') ||
      normalized.contains('network') ||
      normalized.contains('failed host lookup') ||
      normalized.contains('connection')) {
    return LoginFeedbackCode.networkError;
  }
  if (normalized.contains('server') || normalized.contains('service unavailable') || normalized.contains('timeout')) {
    return LoginFeedbackCode.serverUnavailable;
  }

  return LoginFeedbackCode.unknown;
}
