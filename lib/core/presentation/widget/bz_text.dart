import 'package:dynamic_app/core/util/string_helper.dart';
import 'package:flutter/material.dart';

class BzText extends Text {
  final String text;

  BzText(
    this.text, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  }) : super(text.toPersianCharacters());
}
