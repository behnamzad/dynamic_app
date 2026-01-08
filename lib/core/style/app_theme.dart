import 'package:dynamic_app/core/config/assets/assets.dart';
import 'package:dynamic_app/core/config/dimen.dart';
import 'package:dynamic_app/core/style/app_color.dart';
import 'package:dynamic_app/core/style/theme_service.dart';
import 'package:dynamic_app/core/util/extension/context_ext.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppTheme {
  bool isDark = false;
  final AppColors appColors;

  AppTheme({required this.appColors}) {
    isDark = inject<ThemeService>().isDark;
  }

//TODO: textField theme
//TODO: radio theme
  ThemeData appThemeLight(BuildContext context) {
    final defaultTheme = Theme.of(context).copyWith(brightness: Brightness.light);

    final theme = ThemeData(
      brightness: Brightness.light,
      primaryColor: appColors.primary.light,
      scaffoldBackgroundColor: appColors.mainBackground1.light,
      fontFamily: Assets.fontFamily,
      colorScheme: defaultTheme.colorScheme.copyWith(
          primary: appColors.primary.light, secondary: appColors.secondary.light, error: appColors.error.light),
      bottomSheetTheme: defaultTheme.bottomSheetTheme.copyWith(backgroundColor: appColors.dialogBackground.light),
      floatingActionButtonTheme: defaultTheme.floatingActionButtonTheme.copyWith(
        backgroundColor: appColors.floatButtonBackground.light,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(appColors.mainButtonText.light),
        fillColor: WidgetStateProperty.all(appColors.primaryBold.light),
        side: BorderSide(color: appColors.mainText.light, width: 2),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all(appColors.primary.light),
      ),
      dividerTheme: defaultTheme.dividerTheme.copyWith(
        space: Dimen.dividerThickness,
        thickness: Dimen.dividerThickness,
        color: appColors.divider.light,
      ),
      textTheme: defaultTheme.textTheme.copyWith(
        headlineMedium: context.headline4Bold,
        headlineSmall: context.headline5Bold,
        titleLarge: context.title2Bold,
        bodyLarge: context.body1Medium,
        bodyMedium: context.body2Medium,
        titleMedium: context.body2Bold,
        titleSmall: context.body3Medium,
        labelLarge: context.body1Bold.copyWith(color: acs.mainButtonText.light),
        bodySmall: context.body4Medium,
      ),
      inputDecorationTheme: defaultTheme.inputDecorationTheme.copyWith(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.inputBorder.light, width: Dimen.borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.inputBorder.light, width: Dimen.borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.primary.light, width: Dimen.borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius))),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.primary.light, width: Dimen.borderWidth),
          borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.error.light),
          borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.error.light),
          borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius)),
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          color: appColors.hint.light,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          color: appColors.hint.light,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: context.body4Medium.copyWith(color: appColors.error.light),
        errorMaxLines: 2,
        alignLabelWithHint: true,
      ),
    );

    return theme;
  }

//TODO: textField theme
//TODO: radio theme
  ThemeData appThemeDark(BuildContext context) {
    final defaultTheme = Theme.of(context).copyWith(brightness: Brightness.dark);

    final theme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: appColors.primary.dark,
      scaffoldBackgroundColor: appColors.mainBackground1.dark,
      fontFamily: Assets.fontFamily,
      colorScheme: defaultTheme.colorScheme
          .copyWith(primary: appColors.primary.dark, secondary: appColors.secondary.dark, error: appColors.error.dark),
      bottomSheetTheme: defaultTheme.bottomSheetTheme.copyWith(backgroundColor: appColors.dialogBackground.dark),
      floatingActionButtonTheme: defaultTheme.floatingActionButtonTheme.copyWith(
        backgroundColor: appColors.floatButtonBackground.dark,
      ),
      dividerTheme: defaultTheme.dividerTheme.copyWith(
        space: Dimen.dividerThickness,
        thickness: Dimen.dividerThickness,
        color: appColors.divider.dark,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(appColors.mainButtonText.dark),
        fillColor: WidgetStateProperty.all(appColors.primaryBold.dark),
        side: BorderSide(color: appColors.mainText.dark, width: 2),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all(appColors.primary.dark),
      ),
      textTheme: defaultTheme.textTheme.copyWith(
        headlineMedium: context.headline4Bold,
        headlineSmall: context.headline5Bold,
        titleLarge: context.title2Bold,
        bodyLarge: context.body1Medium,
        bodyMedium: context.body2Medium,
        titleMedium: context.body2Bold,
        titleSmall: context.body3Medium,
        labelLarge: context.body1Bold.copyWith(color: acs.mainButtonText.dark),
        bodySmall: context.body4Medium,
      ),
      inputDecorationTheme: defaultTheme.inputDecorationTheme.copyWith(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.inputBorder.dark, width: Dimen.borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.inputBorder.dark, width: Dimen.borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColors.primary.dark, width: Dimen.borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius))),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.primary.dark, width: Dimen.borderWidth),
          borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.error.dark),
          borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.error.dark),
          borderRadius: const BorderRadius.all(Radius.circular(Dimen.multiInputRadius)),
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          color: appColors.hint.dark,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          color: appColors.hint.dark,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: defaultTheme.textTheme.bodySmall?.copyWith(color: appColors.error.dark),
        errorMaxLines: 2,
        alignLabelWithHint: true,
      ),
    );

    return theme;
  }
}

extension TextThemeSchemeExtension on BuildContext {
  TextStyle get headline1Bold => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w700, fontSize: 28);

  TextStyle get headline1Medium => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w500, fontSize: 28);

  TextStyle get headline1Regular => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w400, fontSize: 28);

  TextStyle get headline2Bold => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w700, fontSize: 26);

  TextStyle get headline2Medium => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w500, fontSize: 26);

  TextStyle get headline2Regular => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w400, fontSize: 26);

  TextStyle get headline3ExtraBold => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w800, fontSize: 24);

  TextStyle get headline3Bold => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w700, fontSize: 24);

  TextStyle get headline3Medium => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w500, fontSize: 24);

  TextStyle get headline3Regular => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w400, fontSize: 24);

  TextStyle get headline4ExtraBold => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w800, fontSize: 22);

  TextStyle get headline4Bold => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w700, fontSize: 22);

  TextStyle get headline4Medium => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w500, fontSize: 22);

  TextStyle get headline4Regular => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w400, fontSize: 22);

  TextStyle get headline5Bold => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w700, fontSize: 20);

  TextStyle get headline5Medium => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w500, fontSize: 20);

  TextStyle get headline5Regular => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w400, fontSize: 20);

  TextStyle get title1Bold => TextStyle(color: scheme().mainText, fontWeight: FontWeight.w700, fontSize: 18);

  TextStyle get title1Medium => TextStyle(color: scheme().mainText, fontWeight: FontWeight.w500, fontSize: 18);

  TextStyle get title1Regular => TextStyle(color: scheme().mainText, fontWeight: FontWeight.w400, fontSize: 18);

  TextStyle get title2Bold => TextStyle(color: scheme().titleText, fontWeight: FontWeight.w700, fontSize: 17);

  TextStyle get title2Medium => TextStyle(color: scheme().mainText, fontWeight: FontWeight.w500, fontSize: 17);

  TextStyle get title2Regular => TextStyle(color: scheme().mainText, fontWeight: FontWeight.w400, fontSize: 17);

  TextStyle get body1Bold => TextStyle(color: scheme().subText, fontWeight: FontWeight.w700, fontSize: 16);

  TextStyle get body1Medium => TextStyle(color: scheme().subText, fontWeight: FontWeight.w500, fontSize: 16);

  TextStyle get body1Regular => TextStyle(color: scheme().subText, fontWeight: FontWeight.w400, fontSize: 16);

  TextStyle get body2Bold => TextStyle(color: scheme().subText, fontWeight: FontWeight.w700, fontSize: 15);

  TextStyle get body2Medium => TextStyle(color: scheme().subText, fontWeight: FontWeight.w500, fontSize: 15);

  TextStyle get body2Regular => TextStyle(color: scheme().subText, fontWeight: FontWeight.w400, fontSize: 15);

  TextStyle get body3Bold => TextStyle(color: scheme().subText, fontWeight: FontWeight.w700, fontSize: 14);

  TextStyle get body3Medium => TextStyle(color: scheme().subText, fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get body3Regular => TextStyle(color: scheme().subText, fontWeight: FontWeight.w400, fontSize: 14);

  TextStyle get body4Bold => TextStyle(color: scheme().subText, fontWeight: FontWeight.w700, fontSize: 13);

  TextStyle get body4Medium => TextStyle(color: scheme().subText, fontWeight: FontWeight.w500, fontSize: 13);

  TextStyle get body4Regular => TextStyle(color: scheme().subText, fontWeight: FontWeight.w400, fontSize: 13);

  TextStyle get body5Bold => TextStyle(color: scheme().subText, fontWeight: FontWeight.w700, fontSize: 12);

  TextStyle get body5Medium => TextStyle(color: scheme().subText, fontWeight: FontWeight.w500, fontSize: 12);

  TextStyle get body5Regular => TextStyle(color: scheme().subText, fontWeight: FontWeight.w400, fontSize: 12);
}

extension ColorSchemeExtension on ColorScheme {
  Color get primary => brightness == Brightness.light ? acs.primary.light : acs.primary.dark;

  Color get primaryBold => brightness == Brightness.light ? acs.primaryBold.light : acs.primaryBold.dark;

  Color get primary16 => brightness == Brightness.light ? acs.primary16.light : acs.primary16.dark;

  Color get primary20 => brightness == Brightness.light ? acs.primary20.light : acs.primary20.dark;

  Color get primary24 => brightness == Brightness.light ? acs.primary24.light : acs.primary24.dark;

  Color get secondary => brightness == Brightness.light ? acs.secondary.light : acs.secondary.dark;

  Color get success => brightness == Brightness.light ? acs.success.light : acs.success.dark;

  Color get warning => brightness == Brightness.light ? acs.warning.light : acs.warning.dark;

  Color get link => brightness == Brightness.light ? acs.link.light : acs.link.dark;

  Color get error => brightness == Brightness.light ? acs.error.light : acs.error.dark;

  Color get white => brightness == Brightness.light ? acs.white.light : acs.white.dark;

  Color get mainBackground1 => brightness == Brightness.light ? acs.mainBackground1.light : acs.mainBackground1.dark;

  Color get mainBackground2 => brightness == Brightness.light ? acs.mainBackground2.light : acs.mainBackground2.dark;

  Color get mainBackground3 => brightness == Brightness.light ? acs.mainBackground3.light : acs.mainBackground3.dark;

  Color get mainBackground4 => brightness == Brightness.light ? acs.mainBackground4.light : acs.mainBackground4.dark;

  Color get mainBackground5 => brightness == Brightness.light ? acs.mainBackground5.light : acs.mainBackground5.dark;

  Color get mainBackground6 => brightness == Brightness.light ? acs.mainBackground6.light : acs.mainBackground6.dark;

  Color get mainBackground7 => brightness == Brightness.light ? acs.mainBackground7.light : acs.mainBackground7.dark;

  Color get mainBackground8 => brightness == Brightness.light ? acs.mainBackground8.light : acs.mainBackground8.dark;

  Color get dialogBackground => brightness == Brightness.light ? acs.dialogBackground.light : acs.dialogBackground.dark;

  Color get backAndCancelButtonBackground =>
      brightness == Brightness.light ? acs.backAndCancelButtonBackground.light : acs.backAndCancelButtonBackground.dark;

  Color get disableButtonBackground =>
      brightness == Brightness.light ? acs.disableButtonBackground.light : acs.disableButtonBackground.dark;

  Color get floatButtonBackground =>
      brightness == Brightness.light ? acs.floatButtonBackground.light : acs.floatButtonBackground.dark;

  Color get errorBackground => brightness == Brightness.light ? acs.errorBackground.light : acs.errorBackground.dark;

  Color get linkBackground => brightness == Brightness.light ? acs.linkBackground.light : acs.linkBackground.dark;

  Color get warningBackground =>
      brightness == Brightness.light ? acs.warningBackground.light : acs.warningBackground.dark;

  Color get successBackground =>
      brightness == Brightness.light ? acs.successBackground.light : acs.successBackground.dark;

  Color get mainText => brightness == Brightness.light ? acs.mainText.light : acs.mainText.dark;

  Color get subText => brightness == Brightness.light ? acs.subText.light : acs.subText.dark;

  Color get titleText => brightness == Brightness.light ? acs.titleText.light : acs.titleText.dark;

  Color get inputText => brightness == Brightness.light ? acs.inputText.light : acs.inputText.dark;

  Color get mainButtonText => brightness == Brightness.light ? acs.mainButtonText.light : acs.mainButtonText.dark;

  Color get disableButtonText =>
      brightness == Brightness.light ? acs.disableButtonText.light : acs.disableButtonText.dark;

  Color get backAndCancelButtonText =>
      brightness == Brightness.light ? acs.backAndCancelButtonText.light : acs.backAndCancelButtonText.dark;

  Color get floatButtonText => brightness == Brightness.light ? acs.floatButtonText.light : acs.floatButtonText.dark;

  Color get buttonBorder1 => brightness == Brightness.light ? acs.buttonBorder1.light : acs.buttonBorder1.dark;

  Color get buttonBorder2 => brightness == Brightness.light ? acs.buttonBorder2.light : acs.buttonBorder2.dark;

  Color get activeFilterBorder =>
      brightness == Brightness.light ? acs.activeFilterBorder.light : acs.activeFilterBorder.dark;

  Color get inputBorder => brightness == Brightness.light ? acs.inputBorder.light : acs.inputBorder.dark;

  Color get boxBorder => brightness == Brightness.light ? acs.boxBorder.light : acs.boxBorder.dark;

  Color get divider => brightness == Brightness.light ? acs.divider.light : acs.divider.dark;

  Color get hint => brightness == Brightness.light ? acs.hint.light : acs.hint.dark;

  Color get radioButton => brightness == Brightness.light ? acs.radioButton.light : acs.radioButton.dark;

  Color get dialogShadow => brightness == Brightness.light ? acs.dialogShadow.light : acs.dialogShadow.dark;

  Color get dialogIcon => brightness == Brightness.light ? acs.dialogIcon.light : acs.dialogIcon.dark;

  Color get selectIcon => brightness == Brightness.light ? acs.selectIcon.light : acs.selectIcon.dark;

  Color get bilbilakBottomSheet =>
      brightness == Brightness.light ? acs.bilbilakBottomSheet.light : acs.bilbilakBottomSheet.dark;


  Color get androidLogo => brightness == Brightness.light ? acs.androidLogo.light : acs.androidLogo.dark;

  Color get iosLogo => brightness == Brightness.light ? acs.iosLogo.light : acs.iosLogo.dark;

  Color get profileIcon => brightness == Brightness.light ? acs.profileIcon.light : acs.profileIcon.dark;

  Color get darkBlue => brightness == Brightness.light ? acs.darkBlue.light : acs.darkBlue.dark;

  Color get plaqueBg => brightness == Brightness.light ? acs.plaqueBg.light : acs.plaqueBg.dark;

  Color get highContrast => brightness == Brightness.light ? Colors.black : Colors.white;

  Color get purple => brightness == Brightness.light ? acs.purple.light : acs.purple.dark;

  Color get purpleBackground => brightness == Brightness.light ? acs.purpleBackground.light : acs.purpleBackground.dark;

  Color get switchActiveColor =>
      brightness == Brightness.light ? acs.switchActiveColor.light : acs.switchActiveColor.dark;

  Color get switchActiveTrackColor =>
      brightness == Brightness.light ? acs.switchActiveTrackColor.light : acs.switchActiveTrackColor.dark;

  Color get shimmerBaseColor => brightness == Brightness.light ? acs.shimmerBaseColor.light : acs.shimmerBaseColor.dark;

  Color get shimmerHighlightColor =>
      brightness == Brightness.light ? acs.shimmerHighlightColor.light : acs.shimmerHighlightColor.dark;
}
