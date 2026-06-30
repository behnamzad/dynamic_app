import 'package:dynamic_app/core/config/dimen.dart';
import 'package:dynamic_app/core/presentation/widget/bz_text.dart';
import 'package:dynamic_app/core/style/app_theme.dart';
import 'package:flutter/material.dart';

enum MultiTextFiledThemeMode { normal, error }

class MultiTextField extends StatelessWidget {
  final List<Widget> textFields;
  final String? footerText;
  final Widget? footerWidget;
  final MultiTextFiledThemeMode multiRowThemeMode;
  final bool isKeyBoardOpen;
  final EdgeInsets? margin;
  final bool? isMultiTextFocus;

  const MultiTextField({
    super.key,
    required this.textFields,
    this.footerText,
    this.footerWidget,
    required this.isKeyBoardOpen,
    this.margin,
    this.isMultiTextFocus = true,
    required this.multiRowThemeMode,
  });

  Color _getBorderColor(
    BuildContext context,
    MultiTextFiledThemeMode multiRowThemeMode,
  ) {
    Color borderColor = Theme.of(context).dividerColor;
    switch (multiRowThemeMode) {
      case MultiTextFiledThemeMode.normal:
        borderColor = isKeyBoardOpen && isMultiTextFocus!
            ? Theme.of(context).colorScheme.titleText
            : Theme.of(context).colorScheme.inputBorder;
        break;
      case MultiTextFiledThemeMode.error:
        borderColor = Theme.of(context).colorScheme.error;
        break;
    }
    return borderColor;
  }

  TextStyle? _getFooterTextStyle(
    BuildContext context,
    MultiTextFiledThemeMode multiRowThemeMode,
  ) {
    TextStyle? footerTextStyle = context.body3Regular;
    switch (multiRowThemeMode) {
      case MultiTextFiledThemeMode.normal:
        footerTextStyle = context.body3Regular.copyWith(
          color: Theme.of(context).colorScheme.hint,
        );
        break;
      case MultiTextFiledThemeMode.error:
        footerTextStyle = context.body4Regular.copyWith(color: Theme.of(context).colorScheme.error);
        break;
    }
    return footerTextStyle;
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = _getBorderColor(context, multiRowThemeMode);
    TextStyle? footerTextStyle = _getFooterTextStyle(context, multiRowThemeMode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: margin ?? const EdgeInsets.only(top: 26, bottom: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(Dimen.multiInputRadius),
            ),
            border: Border.all(
              width: isKeyBoardOpen ? 2 : 1.5,
              color: borderColor,
            ),
          ),
          child: Column(
            children: textFields.map((textFieldWidget) {
              return Column(
                children: [
                  textFieldWidget,
                  if (textFieldWidget != textFields[textFields.length - 1])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        thickness: Theme.of(context).dividerTheme.thickness,
                        color: Theme.of(context).colorScheme.divider,
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        if (footerWidget != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15, start: 15),
            child: footerWidget!,
          ),
        if (footerWidget == null && footerText != null && footerText!.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8, top: 4),
            child: BzText(footerText!, style: footerTextStyle),
          ),
      ],
    );
  }
}
