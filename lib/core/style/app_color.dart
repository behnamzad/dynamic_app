import 'package:dynamic_app/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

class AppColor {
  const AppColor({required this.light, required this.dark});

  final Color light;
  final Color dark;
}

@LazySingleton()
class AppColors {
  /// Main ///

  AppColor get primary => const AppColor(light: Color(0xFF6227CF), dark: Color(0xFF908CE5));


  AppColor get primary16 => const AppColor(light: Color(0xFFE9E9EC), dark: Color(0xFF827F9F));

  AppColor get primary20 => const AppColor(light: Color(0xFFFCF1CC), dark: Color(0xFF443D27));

  AppColor get primary24 => const AppColor(light: Color(0xFFFCEEC2), dark: Color(0xFF443D27));

  AppColor get primaryBold => const AppColor(light: Color(0xFF271191), dark: Color(0xFFA396D0));

  AppColor get secondary => const AppColor(light: Color(0xFF000000), dark: Color(0xFFEDEDED));

  AppColor get success => const AppColor(light: Color(0xFF00BD79), dark: Color(0xFF5CCCAB));

  AppColor get warning => const AppColor(light: Color(0xFFF86F03), dark: Color(0xFFFFA761));

  AppColor get link => const AppColor(light: Color(0xFF2173E0), dark: Color(0xFF96D2FF));

  AppColor get error => const AppColor(light: Color(0xFFFF0000), dark: Color(0xFFFA8378));

  AppColor get white => const AppColor(light: Color(0xFFFFFFFF), dark: Color(0xFFFFFFFF));

  AppColor get switchActiveColor => const AppColor(light: Color(0xFF00A56E), dark: Color(0xFF4FB69B));

  AppColor get switchActiveTrackColor => const AppColor(light: Color(0xFFABE1CF), dark: Color(0xFF2A4B43));

  /// Background ///
  AppColor get mainBackground1 => const AppColor(light: Color(0xFFFFFFFF), dark: Color(0xFF141515));

  AppColor get mainBackground2 => const AppColor(light: Color(0xFFF2F2F2), dark: Color(0xFF0C0C0C));

  AppColor get mainBackground3 => const AppColor(light: Color(0xFFF2F2F2), dark: Color(0xFF242424));

  AppColor get mainBackground4 => const AppColor(light: Color(0xFFF4F4F4), dark: Color(0xFF272727));

  AppColor get mainBackground5 => const AppColor(light: Color(0xFFF6F6F6), dark: Color(0xFF242424));

  AppColor get mainBackground6 => const AppColor(light: Color(0xFFEBEBEB), dark: Color(0XFF020202));

  AppColor get mainBackground7 => const AppColor(light: Color(0xFFEAEAEA), dark: Color(0XFF0A0A0A));

  AppColor get mainBackground8 => const AppColor(light: Color(0xFF1E1E20), dark: Color(0xFF2C2C2C));

  AppColor get dialogBackground => const AppColor(light: Color(0xFFFFFFFF), dark: Color(0xFF1B1B1B));

  AppColor get backAndCancelButtonBackground => const AppColor(light: Color(0xFFEDEDED), dark: Color(0xFF363636));

  AppColor get disableButtonBackground => const AppColor(light: Color(0xFFF2F2F2), dark: Color(0xFF292929));

  AppColor get floatButtonBackground => const AppColor(light: Color(0xFFDFFC9C), dark: Color(0xFFCCDF9F));

  AppColor get errorBackground => const AppColor(light: Color(0xFFFFDEDE), dark: Color(0xFF362725));

  AppColor get linkBackground => const AppColor(light: Color(0xFFE1F0FB), dark: Color(0xFF232834));

  AppColor get warningBackground => const AppColor(light: Color(0xFFFEEAD9), dark: Color(0xFF473527));

  AppColor get successBackground => const AppColor(light: Color(0xFFEBFAF4), dark: Color(0xFF252F2E));

  AppColor get bottomDialogBackground => const AppColor(light: Color(0xFFFFFFFF), dark: Color(0xFF323336));

  AppColor get androidLogo => const AppColor(light: Color(0xFFA1B644), dark: Color(0xFFA1B644));

  AppColor get iosLogo => const AppColor(light: Color(0xFF464646), dark: Color(0xFFCCCCCC));

  AppColor get darkBlue => const AppColor(light: Color(0xFF1A65C9), dark: Color(0xFF1A65C9));

  AppColor get plaqueBg => const AppColor(light: Color(0xFFDCFAE2), dark: Color(0xFFAACDB4));


  /// Text ///
  AppColor get mainText => const AppColor(light: Color(0xFF424242), dark: Color(0xFFCCCCCC));

  AppColor get subText => const AppColor(light: Color(0xFF757575), dark: Color(0xFF979797));

  AppColor get titleText => const AppColor(light: Color(0xFF0A1014), dark: Color(0xFFF0F0F0));

  AppColor get inputText => const AppColor(light: Color(0xFF1C1C1E), dark: Color(0xFFF0F0F0));

  AppColor get mainButtonText => const AppColor(light: Color(0xFFFFFFFF), dark: Color(0xFF202123));

  AppColor get disableButtonText => const AppColor(light: Color(0xFF979797), dark: Color(0xFF757575));

  AppColor get backAndCancelButtonText => const AppColor(light: Color(0xFF000000), dark: Color(0xFFFFFFFF));

  AppColor get floatButtonText => const AppColor(light: Color(0xFF1C1C1E), dark: Color(0xFF202123));

  /// Border ///
  AppColor get buttonBorder1 => const AppColor(light: Color(0xFF979797), dark: Color(0xFF979797));

  AppColor get buttonBorder2 => const AppColor(light: Color(0xFFCDCDCD), dark: Color(0xFF5E5F60));

  AppColor get activeFilterBorder => const AppColor(light: Color(0xFFEBD8AA), dark: Color(0xFF635228));

  AppColor get inputBorder => const AppColor(light: Color(0xFFBEBEBE), dark: Color(0xFF7D7D7D));

  AppColor get boxBorder => const AppColor(light: Color(0xFFE4E4E4), dark: Color(0xFF353535));

  /// Other ///
  AppColor get divider => const AppColor(light: Color(0xFFD8D8D8), dark: Color(0xFF3D3D3D));

  AppColor get hint => const AppColor(light: Color(0xFF878787), dark: Color(0xFF878787));

  AppColor get radioButton => const AppColor(light: Color(0xFF5A5A5A), dark: Color(0xFFB4B4B4));

  AppColor get dialogShadow => AppColor(light: Colors.black.withValues(alpha: 0.4), dark: Colors.black.withValues(alpha: 0.72));

  AppColor get dialogIcon => const AppColor(light: Color(0xFF4C4C4C), dark: Color(0xFF979797));

  AppColor get selectIcon => const AppColor(light: Color(0xFFB4B4B4), dark: Color(0xFF8C8C8C));

  AppColor get bilbilakBottomSheet => const AppColor(light: Color(0xFFCECED1), dark: Color(0xFF757575));

  AppColor get profileIcon => const AppColor(light: Color(0xFF5A5A5A), dark: Color(0xFFB4B4B4));


  List<AppColor> get cardColors => [
        const AppColor(light: Color(0xFFA1E5BC), dark: Color(0xFF8CC29E)),
        const AppColor(light: Color(0xFFFFC56D), dark: Color(0xFFE1A862)),
        const AppColor(light: Color(0xFFBEDCDF), dark: Color(0xFF96BEB4)),
        const AppColor(light: Color(0xFFFFA591), dark: Color(0xFFDC8B79)),
        const AppColor(light: Color(0xFFB6DBFA), dark: Color(0xFF99BAD8)),
        const AppColor(light: Color(0xFFFFE473), dark: Color(0xFFD6BF61)),
        const AppColor(light: Color(0xFFCAD4FD), dark: Color(0xFFB0B6D4)),
        const AppColor(light: Color(0xFFEBBCF0), dark: Color(0xFFC99EC9)),
        const AppColor(light: Color(0xFFA5E5EB), dark: Color(0xFF8CC0C0)),
        const AppColor(light: Color(0xFFE2A6BA), dark: Color(0xFFCB93A5)),
      ];

  AppColor get purple => const AppColor(light: Color(0xFF5536BF), dark: Color(0xFFAAB0FA));

  AppColor get purpleBackground => const AppColor(light: Color(0xFFEBE7F7), dark: Color(0xFF37383F));

  AppColor get shimmerBaseColor => const AppColor(light: Color(0xFFE4D9FA), dark: Color(0xFF353535));

  AppColor get shimmerHighlightColor => const AppColor(light: Color(0xFFC0BAD5), dark: Color(0xFF262626));
}

/// acs = App color s
AppColors acs = inject<AppColors>();
