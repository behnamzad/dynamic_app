import 'package:dynamic_app/di/injection_container.dart';
import 'package:flutter/material.dart';

 class Dimen {
  static const double buttonMinHeight = 50;
  static const double dialogButtonHeight = 46;
  static const double cardHeight = 205;
  static const double miniCardHeight = 185;
  static const double appBarHeight = 58;
  static const double searchBarHeight = 62;
  static const double textFieldHeight = 54;
  static const double fabHeight = 55;

  static const double defaultRadius = 16;
  static const double buttonRadius = 12;
  static const double multiInputRadius = 12;
  static const double inputRadius = 12;
  static const double popupRadius = 12.0;
  static const double smallRadius = 6.0;
  static const double smallBtnRadius = 10;
  static const double dialogButtonRadius = 10;
  static const double bottomSheetRadius = 20;
  static const double fabRadius = 14;

  static const double pagePaddingHorizontal = 16;

  static const double dividerThickness = 1;

  static const double borderWidth = 1.5;
  static const double borderWidthBold = 1.8;
  static const double selectedBorderWidth = 2.2;

  static const double adaButtonBorderWidth = 1.3;
  static const double adaButtonBorderWidthBold = 2;

  static const double iconSmallSize = 23;
  static const double bottomToastPadding = 80;
  static const double toastOnFabPadding = 92;

  static double bottomToastKeyBoardPadding(BuildContext ctx) => MediaQuery.of(ctx).viewInsets.bottom + 76;

  double get bankHeaderLogoWidth => 126;

  double get bankHeaderLogoHeight => 42;

  double get bankHeaderLogoAppBarWidth => 72;

  double get bankHeaderLogoAppBarHeight => 12;

  double get tabBarHeight => 54;


  static const double dailyCardHeight = 184;
}

Dimen dimen = inject<Dimen>();
