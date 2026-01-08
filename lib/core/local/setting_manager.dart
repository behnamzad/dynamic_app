import 'dart:convert';


import 'package:dynamic_app/core/local/user/enum/gender.dart';
import 'package:dynamic_app/core/local/user/enum/user_register_status.dart';
import 'package:dynamic_app/core/local/user/enum/user_status.dart';
import 'package:dynamic_app/core/util/app_logger.dart';
import 'package:dynamic_app/core/util/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsManager {
  final SharedPreferencesHelper prefs;

  SettingsManager(this.prefs);

  final String _quickChargeSelectedProduct = 'quick_charge_S_P';
  final String _quickChargeSelectedFinalProduct = 'quick_charge_F_S_P';
  final String _quickChargeSelectedPhoneNumber = 'quick_charge_A_P_N';
  final String _quickChargeSelectedVendorId = 'quick_charge_s_v_i';
  final String _quickChargeSelectedProductId = 'quick_charge_s_p_i';
  final String _quickChargeSelectedDepositAccount = 'quick_charge_S_D_A';
  final String _quickChargeActivationStatusKey = 'quick_charge_A_S_K';
  final String _openDepositTokenKey = 'open_D_T_K';
  final String _openDepositStatusKey = 'open_D_S_K';
  final String _opAuthJwtByMehrAcc = 'open_A_J_B_M_A';
  final String _publicKey = 'public_K';
  final String _privateKey = 'pv_K';
  final String _userNicknameKey = 'user_N_N_K';
  final String _userNameKey = 'user_N_K';
  final String _passwordKey = 'p_w_K';
  final String _jwTokenKey = 'j_w_t_K';
  final String _refreshTokenKey = 'refresh_t_K';
  final String _adaTokenKey = 'ada_t_k';
  final String _cookieKey = 'cookie_K';
  final String _userStatusKey = 'user_S_K';
  final String _userGenderKey = 'user_g_K';
  final String _userRegisterStatusKey = 'user_R_S_K';
  final String _deviceIdKey = 'device_I_K';
  final String _nationalCodeKey = 'national_C_K';
  final String _cifKey = 'cif_K';
  final String _mobileNumberKey = 'mobile_N_K';
  final String _symmetricKeyKey = 'symmetricKey';
  final String _symmetricKeyIsSentKey = 'symmetricKey_i_s';
  final String _agreementLastAvailableVersionKey = 'agreement_L_A_V_K';
  final String _agreementAcceptedVersionKey = 'agreement_A_V_K';
  final String _mBankConfigKey = 'MBank_Config_K';
  final String _mBankAgreementKey = 'MBank_agreement_K';
  final String _investAgreementKey = 'invest_agreement_K';
  final String _agreementIsAcceptedKey = 'agreement_i_a_K';
  final String _useTomanKey = 'use_t_a_K';
  final String _showingWithdrawalBalanceKey = 'show_w_b_K';
  final String _showFastChargeAndInternetPackageKey = 'show_f_c_i_p_K';
  final String _enableFastChargeFromSettingsKey = 'e_f_c_f_s_K';
  final String _showUpcomingEventsKey = 'show_u_e_K';
  final String _enableCloudDbKey = 'enable_c_d_K';
  final String _ssoTokenKey = 'ssoToken_';
  final String _audienceTokenKey = 'audienceToken_';
  final String _biometricOptionVisibility = '_biometricOptionVisibility';
  final String _biometricOptionRecommender = '_biometricOptionRecommender';
  final String _themeKeyValue = 'theme_key_value';
  final String _showSuggestion = '_showSuggestion';
  final String _profileAvatarKey = '_profile_a_Key';
  final String _newVersionAvailableKey = '_new_v_a_Key';
  final String _lastAvailableUpdateVersionCode = '_last_a_u_v_c_Key';
  final String _tuneTokens = '_tune_tokens_Key';
  final String _dailyRecommendationsKey = '_daily_recom_K';
  final String _dailyRawRecommendationsKey = '_daily_raw_R_K';
  final String _ssoBaseTokenKey = '_sso_b_t_K';
  final String _agreementStepCompletedKey = '_agreement_S_C_K';
  final String _smsConfirmEndTimeKey = '_smsConfirmEndTimeKey';
  final String _lastCardDepositUpdate = '_lastCardDepositUpdate';
  final String _needToLogin = '_needToLogin';
  final String _needToOpenDeposit = '_needToOpenDeposit';
  final String _activeBiometricSuggestionViewed = '_activeBiometricSuggestionViewed';
  final String _lastRejectedTargetNumber = 'last_rejected_target_number';
  final String _destinationLongTapText = 'destination_longTap_text';
  final String _contactLongTapText = 'contact_longTap_text';
  final String _skipPermissionForReadOtpOfPayment = 'skip_permission_r_o_p';
  final String _goldWalletAssetIdSetCorrect = 'g_w_AssetIdCorrectSet';
  final String _biometricType = 'biometric_type';
  final String _cloudUserNameKey = 'c_user_N_K';
  final String _cloudPasswordKey = 'c_p_w_K';
  final String _cloudEnabledKey = 'c_e_K';
  final String _banketDepositNumber = '_banket_d_n';
  final String _fastTransferKey = 'fast_transfer';
  final String _investCardWidget = 'invest_card_w';
  final String _migrationNativeContactKey = 'M_N_C_k';
  final String _migrationNativeContactIsDoneKey = 'M_N_C_I_D_k';
  final String _isFirstPurchaseQuickChargeKey = '_first_purchase_q_c';
  final String _isHideUserAccountsWarningKey = '_hide_warning_u_a';
  final String _isExpandedMultiAccountExpandableListKey = '_ex_m_a_e_l_k';
  final String _showActivateAutoBillBannerKey = 'showActivateAutoBillBannerKey';
  final String _showActiveDevicesDescriptionWarningKey = 'showActiveDevicesDescriptionWarning';
  final String _submitAppReviewByUser = '_submitAppReviewByUser';
  final String _countOfSuccessTransaction = '_countOfSuccessTransaction';
  final String _lastDismissAppReview = '_lastDismissAppReview';
  final String _fcmToken = '_fcmToken';
  final String _basicWalletKey = 'b_wa_k';
  final String _selectDepositToShowInDashboard = '_select_deposit_in_d';
  final String _selectDepositToShowInDashboardFromBottomSheet = '_select_deposit_in_d_bt';
  final String _toggleAmountVisibilityAllBalance = '_toggle_amount_visibility_ab';
  final String _toggleAmountVisibilityWalletBalance = '_toggle_amount_visibility_wb';
  final String _toggleAmountVisibilityAllAccounts = '_toggle_amount_visibility_all_account';
  final String _toggleAmountVisibilityInvestments = '_toggle_amount_visibility_investments';
  final String _widgetBalanceColor = '_widgetBalanceColor';
  final String _withdrawRequestResponse = '_withdrawRequestResponse';
  final String _goldWallet = '_g_w_add';
  final String _silverWallet = '_s_w_id';
  final String _rialWallet = '_r_w_add';
  final String _isAppAutoLock = '_app_auto_lock';
  final String _userUniqueId = '_userUniqueId';
  final String _registeredCashback = '_registeredCashback';
  final String _isShownMultiAccountHint = '_is_s_m_a_h_key';
  final String _askedForNotificationPermission = 'a_f_n_p';
  final String _registeredCashBackPanList = 'r_c_b_p_l_key';
  final String _lastCoreBankType = 'l_c_b_t_key';
  final String _autoUpdateCashAccount = 'a_u_c_a_b_key';
  final String _newTagBadgeShortcutClickedList = 'n_t_b_s_c_l_key';
  final String _redCircleBadgeShortcutClickedList = 'r_c_b_s_c_l_key';
  final String _navigationBarBadgesClickedList = 'n_b_b_c_l_key';
  final String _isUpdateFromBazarInBankoApp = 'i_u_f_b_i_b_a_key';

  Future<bool> setTheme(ThemeMode themMode) async {
    return prefs.setString(_themeKeyValue, themMode.name);
  }

  String getTheme() {
    return prefs.getString(_themeKeyValue, defaultValue: ThemeMode.system.name);
  }

  setDeviceId(String deviceId) {
    prefs.setStringAndEncrypt(_deviceIdKey, deviceId);
  }

  getDeviceId() {
    return prefs.getEncryptedString(_deviceIdKey, defaultValue: '');
  }

  setUserName(String userName) {
    prefs.setStringAndEncrypt(_userNameKey, userName);
  }

  String getUserName() {
    return prefs.getEncryptedString(_userNameKey);
  }


  setPassword(String pass) {
    prefs.setStringAndEncrypt(_passwordKey, pass);
  }

  String getPassword() {
    return prefs.getEncryptedString(_passwordKey);
  }

  setMobileNumber(String mobile) {
    prefs.setStringAndEncrypt(_mobileNumberKey, mobile);
  }

  getMobileNumber() {
    return prefs.getEncryptedString(_mobileNumberKey);
  }

  setNationalCode(String nationalCode) {
    prefs.setStringAndEncrypt(_nationalCodeKey, nationalCode);
  }

  getNationalCode() {
    return prefs.getEncryptedString(_nationalCodeKey);
  }
  setUserRegisterStatus(UserRegisterStatus userRegisterStatus) {
    prefs.setString(_userRegisterStatusKey, userRegisterStatus.name);
  }

  getUserRegisterStatus() {
    return UserRegisterStatus.values.byName(prefs.getString(_userRegisterStatusKey));
  }
  setUserStatus(UserStatus userStatus,{String? callFrom}) {
    try {
      if(callFrom!=null) {
        AppLogger.debugLog('callFrom : $callFrom and new userStatus is:${userStatus.name}');
      }
    }catch(_){}

    prefs.setString(_userStatusKey, userStatus.name);

    try {
      AppLogger.debugLog('getUserStatus : ${(prefs.getString(_userStatusKey))}');
    }catch(_){}
  }

  getUserStatus() {
    return UserStatus.values.byName(prefs.getString(_userStatusKey));
  }

  setUserGender(Gender userGender) {
    prefs.setString(_userGenderKey, userGender.name);
  }

  getUserGender() {
    return Gender.values.byName(prefs.getString(_userGenderKey));
  }

  String getUserNickname() {
    return prefs.getEncryptedString(_userNicknameKey);
  }

  setUserNickname(String userNickname) {
    prefs.setStringAndEncrypt(_userNicknameKey, userNickname);
  }

  setAcceptedAgreement(bool isSent) {
    prefs.setBool(_agreementIsAcceptedKey, isSent);
  }

  bool isAcceptedAgreement() {
    return prefs.getBool(_agreementIsAcceptedKey);
  }
}
