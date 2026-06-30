import 'dart:math';

import 'package:dynamic_app/core/presentation/core/models/text_field_validation.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/core/util/extension/string_ext.dart';
import 'package:dynamic_app/core/util/shared_preferences_helper.dart';
import 'package:flutter/services.dart';

enum TextFieldType {
  borderLess,
  outline;

  bool get isBorderLess => this == TextFieldType.borderLess;

  bool get isOutline => this == TextFieldType.outline;
}

class BzTextField extends StatefulWidget {
  const BzTextField.borderLess({
    super.key,
    this.textEditingController,
    this.label,
    this.hint,
    this.bottomText,
    this.textColor,
    this.hintColor,
    this.textFontSize,
    this.textHeight,
    this.hintFontSize,
    this.textWeight,
    this.borderColor,
    this.borderWidth,
    this.bottomTextColor,
    this.enabled = true,
    this.isInputInValid = false,
    this.showFooterMessageIcon = true,
    this.isInputValid = false,
    this.obscureText = false,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.maxLength,
    this.maxLines,
    this.focusNode,
    this.prefix,
    this.suffix,
    this.suffixIcon,
    this.prefixIcon,
    this.textAlign,
    this.textDirection = TextDirection.ltr,
    this.hintDirection = TextDirection.rtl,
    this.isRequired = false,
    this.setLeftPaddingMatchToRequiredField = false,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.padding,
    this.mainPadding,
    this.textAlignVertical,
    this.expands,
    this.textStyle,
    this.minLines,
    this.isOnlyNumeric = false,
    this.isShowFullLetterKeyboard = false,
    this.isTextFieldPassword = false,
    this.isShowSwitchKeyboardType = true,
    this.showBiometrics = false,
    this.onBiometricsTap,
    this.toggleKeyboardModeValueNotifier,
    this.setAlphanumericKeyboardAsDefaultForFirstUseByHand = false,
    this.obscureState,
    this.isShowToggleObscureVisibility = false,
    this.reloadStateController,
    this.readOnly = false,
    this.enabledAutofillHints = false,
    this.textFieldValidationList,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
  })  : _textFieldType = TextFieldType.borderLess,
        borderRadius = null;

  const BzTextField.outline({
    super.key,
    this.textEditingController,
    this.label,
    this.hint,
    this.bottomText,
    this.textColor,
    this.hintColor,
    this.textFontSize,
    this.textHeight,
    this.hintFontSize,
    this.textWeight,
    this.borderColor,
    this.borderWidth,
    this.bottomTextColor,
    this.enabled = true,
    this.isInputInValid = false,
    this.showFooterMessageIcon = true,
    this.isInputValid = false,
    this.obscureText = false,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.maxLength,
    this.maxLines,
    this.focusNode,
    this.prefix,
    this.suffix,
    this.suffixIcon,
    this.prefixIcon,
    this.textAlign,
    this.textDirection = TextDirection.rtl,
    this.hintDirection = TextDirection.rtl,
    this.isRequired = false,
    this.setLeftPaddingMatchToRequiredField = false,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.padding,
    this.mainPadding,
    this.borderRadius,
    this.textAlignVertical,
    this.expands,
    this.textStyle,
    this.minLines,
    this.isOnlyNumeric = false,
    this.isShowFullLetterKeyboard = false,
    this.readOnly = false,
    this.showBiometrics = false,
    this.isTextFieldPassword = false,
    this.isShowSwitchKeyboardType = true,
    this.onBiometricsTap,
    this.toggleKeyboardModeValueNotifier,
    this.setAlphanumericKeyboardAsDefaultForFirstUseByHand = false,
    this.obscureState,
    this.isShowToggleObscureVisibility = false,
    this.reloadStateController,
    this.enabledAutofillHints = false,
    this.textFieldValidationList,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
  }) : _textFieldType = TextFieldType.outline;

  final TextFieldType _textFieldType;
  final TextEditingController? textEditingController;
  final String? label;
  final String? hint;
  final String? bottomText;
  final Color? textColor;
  final Color? hintColor;
  final double? textFontSize;
  final double? textHeight;
  final double? hintFontSize;
  final FontWeight? textWeight;
  final Color? borderColor;
  final double? borderWidth;
  final Color? bottomTextColor;
  final bool enabled;
  final bool enabledAutofillHints;
  final bool isInputInValid;
  final bool showFooterMessageIcon;
  final bool isInputValid;
  final bool obscureText;
  final bool autoFocus;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? maxLines;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextAlign? textAlign;
  final TextDirection textDirection;
  final TextDirection hintDirection;
  final bool isRequired;
  final bool setLeftPaddingMatchToRequiredField;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final EdgeInsets? padding;
  final EdgeInsets? mainPadding;
  final double? borderRadius;
  final bool readOnly;
  final TextAlignVertical? textAlignVertical;
  final bool? expands;
  final int? minLines;
  final TextStyle? textStyle;
  final bool isOnlyNumeric;
  final bool isShowFullLetterKeyboard;
  final bool isTextFieldPassword;
  final bool isShowSwitchKeyboardType;
  final bool showBiometrics;
  final VoidCallback? onBiometricsTap;
  final ValueNotifier<bool>? toggleKeyboardModeValueNotifier;
  final bool? setAlphanumericKeyboardAsDefaultForFirstUseByHand;
  final ValueNotifier<bool>? obscureState;
  final bool isShowToggleObscureVisibility;
  final List<TextFieldValidation>? textFieldValidationList;
  final ReloadStateController? reloadStateController;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;

  @override
  State<BzTextField> createState() => _BzTextFieldState();
}

class ReloadStateController {
  late Function(String) onChanged;
}

class _BzTextFieldState extends State<BzTextField> {
  String text = '';
  bool _isNumericKeyboard = true;
  bool _isVisibleTextContent = false;
  int? cursorIndex;

  @override
  void initState() {
    cursorIndex = widget.textEditingController?.text.length ?? 0;

    if (widget.textEditingController?.value.text.isNotEmpty == true) {
      _onTextChange(widget.textEditingController!.value.text);
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.toggleKeyboardModeValueNotifier != null) {
        widget.toggleKeyboardModeValueNotifier!.addListener(() => _toggleKeyboardMode());
      }
      if (widget.obscureState != null) {
        widget.obscureState!.addListener(() => _toggleVisibility());
      }
    });
    widget.reloadStateController?.onChanged = _onTextChange;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.isRequired || widget.setLeftPaddingMatchToRequiredField)
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 4),
                child: BzText(
                  widget.isRequired ? '*' : ' ',
                  style: context.body2Medium.copyWith(color: context.scheme().error, fontSize: Dimen.iconSmallSize),
                ),
              ),
            Expanded(
              child: Directionality(
                textDirection: _mainDirection,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        autofillHints: widget.enabledAutofillHints
                            ? const [
                                AutofillHints.oneTimeCode,
                              ]
                            : null,
                        readOnly: widget.readOnly,
                        contextMenuBuilder: widget.contextMenuBuilder,
                        controller: widget.textEditingController,
                        enabled: widget.enabled,
                        focusNode: widget.focusNode,
                        obscureText: widget.isTextFieldPassword ? (!_isVisibleTextContent) : widget.obscureText,
                        keyboardAppearance: Theme.of(context).brightness,
                        inputFormatters: widget.isTextFieldPassword
                            ? (_isNumericKeyboard
                                ? (<TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]|[۰-۹]')),
                                  ])
                                : widget.inputFormatters)
                            : widget.inputFormatters,
                        scrollPadding: const EdgeInsets.all(0.0),
                        maxLength: widget.maxLength,
                        keyboardType: widget.isTextFieldPassword
                            ? (_isNumericKeyboard
                                ? const TextInputType.numberWithOptions(decimal: true)
                                : TextInputType.visiblePassword)
                            : widget.keyboardType,
                        maxLines: widget.expands == true
                            ? null
                            : widget.maxLines ?? (widget.keyboardType == TextInputType.multiline ? 3 : 1),
                        minLines: widget.minLines,
                        expands: widget.expands ?? false,
                        autofocus: widget.autoFocus,
                        style: widget.textStyle ??
                            context.title2Medium.copyWith(
                              color: widget.textColor ?? context.scheme().titleText,
                              height: widget.textHeight,
                            ),
                        onTap: () {
                          if (widget.textEditingController != null) {
                            if (widget.textEditingController!.selection ==
                                TextSelection.fromPosition(
                                  TextPosition(offset: widget.textEditingController!.text.length - 1),
                                )) {
                              setState(() {
                                widget.textEditingController!.selection = TextSelection.fromPosition(
                                  TextPosition(offset: widget.textEditingController!.text.length),
                                );
                              });
                            }
                          }
                          widget.onTap?.call();
                        },
                        textInputAction: widget.textInputAction,
                        onEditingComplete: widget.onEditingComplete,
                        textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
                        textDirection: _textDirection,
                        onChanged: _onTextChange,
                        onSubmitted: _onSubmitted,
                        textAlign: _textAlign,
                        decoration: InputDecoration(
                          contentPadding:
                              widget.padding ?? const EdgeInsets.only(top: 14, bottom: 14, right: 16, left: 16),
                          border: widget._textFieldType.isBorderLess
                              ? InputBorder.none
                              : getBorder(BorderType.regularBorder),
                          enabledBorder: widget._textFieldType.isBorderLess
                              ? InputBorder.none
                              : getBorder(BorderType.enabledBorder),
                          disabledBorder: widget._textFieldType.isBorderLess
                              ? InputBorder.none
                              : getBorder(BorderType.disabledBorder),
                          focusedBorder: widget._textFieldType.isBorderLess
                              ? InputBorder.none
                              : getBorder(BorderType.focusedBorder),
                          errorBorder:
                              widget._textFieldType.isBorderLess ? InputBorder.none : getBorder(BorderType.errorBorder),
                          focusedErrorBorder: widget._textFieldType.isBorderLess
                              ? InputBorder.none
                              : getBorder(BorderType.focusedErrorBorder),
                          prefix: widget.prefix,
                          suffix: widget.suffix,
                          prefixIcon: widget.prefixIcon,
                          labelText: widget.label,
                          hintText: widget.hint,
                          isDense: true,
                          hintStyle: context.body1Regular.copyWith(
                            color: widget.hintColor ?? context.scheme().hint,
                            letterSpacing: 0,
                          ),
                          errorStyle: const TextStyle(height: 0.001, color: Colors.transparent),
                          errorText: widget.isInputInValid ? widget.bottomText : null,
                          // errorStyle: context.body4Regular.copyWith(
                          //   color: widget.bottomTextColor ?? context.scheme().error,
                          //   height: widget.textHeight ?? 1.6,
                          // ),
                          errorMaxLines: 1,
                          counterText: '',
                          suffixIcon: widget.isTextFieldPassword &&
                                  (widget.obscureState == null || widget.isShowToggleObscureVisibility)
                              ? (text.isNotEmpty)
                                  ? (Container(
                                      margin: const EdgeInsets.only(
                                        right: 4,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(100),
                                        onTap: _toggleVisibility,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            left: 12,
                                            right: 12,
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          child: Icon(
                                            _isVisibleTextContent
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: context.scheme().titleText,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ))
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        (widget.isOnlyNumeric ||
                                                widget.isShowFullLetterKeyboard ||
                                                !widget.isShowSwitchKeyboardType ||
                                                widget.toggleKeyboardModeValueNotifier != null)
                                            ? const SizedBox(
                                                height: 30,
                                              )
                                            : Container(
                                                width: 38,
                                                height: 38,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: context.scheme().primary2,
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(100),
                                                    onTap: () {
                                                      _toggleKeyboardMode();
                                                    },
                                                    child: Center(
                                                      child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child: Icon(
                                                          _isNumericKeyboard
                                                              ? Icons.keyboard_alt_outlined
                                                              : Icons.dialpad,
                                                          color: context.scheme().primaryBold,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        (widget.showBiometrics)
                                            ? Container(
                                                margin: const EdgeInsets.only(left: 8),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (widget.onBiometricsTap != null) {
                                                      widget.onBiometricsTap!();
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 24,
                                                    margin: const EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 15,
                                                      left: 8,
                                                      right: 9,
                                                    ),
                                                    height: 24,
                                                    child: Center(
                                                      child: SizedBox(
                                                        height: 24,
                                                        width: 24,
                                                        child: Icon(
                                                          Icons.fingerprint,
                                                          color: context.scheme().subText,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                              : widget.suffixIcon,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: (widget.isInputInValid || widget.isInputValid) && widget.showFooterMessageIcon,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: [
                  Icon(
                    widget.isInputInValid ? Icons.info_outline : Icons.check_circle_outline,
                    size: 18,
                    color: widget.isInputInValid ? context.scheme().error : context.scheme().success,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  BzText(
                    widget.bottomText ?? '',
                    style: context.body4Medium.copyWith(
                      color: widget.bottomTextColor ?? context.scheme().error,
                      height: widget.textHeight ?? 1.6,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.textFieldValidationList != null) ...[
          const SizedBox(
            height: 8,
          ),
          Column(mainAxisSize: MainAxisSize.min, children: validateItems(context)),
        ],
      ],
    );
  }

  bool get _hasInvalidValidation {
    return widget.textFieldValidationList?.any(
          (item) => item.validationStatusType == ValidationStatusType.invalid,
        ) ??
        false;
  }

  validateItems(BuildContext context) {
    return widget.textFieldValidationList!.map((e) {
      var validationIcon = getValidationIcon(e.validationStatusType);
      var validationColor = getValidationColor(e.validationStatusType);
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Icon(validationIcon, size: 20, color: validationColor),
            const SizedBox(
              width: 10,
            ),
            BzText(
              e.text,
              style: context.body3Medium.copyWith(
                color: validationColor,
                height: widget.textHeight ?? 1.6,
              ),
              maxLines: 2,
            ),
          ],
        ),
      );
    }).toList();
  }

  Color getValidationColor(ValidationStatusType validationStatusType) {
    switch (validationStatusType) {
      case ValidationStatusType.normal:
        return context.scheme().hint;
      case ValidationStatusType.invalid:
        return context.scheme().error;
      case ValidationStatusType.valid:
        return context.scheme().success;
    }
  }

  IconData getValidationIcon(ValidationStatusType validationStatusType) {
    switch (validationStatusType) {
      case ValidationStatusType.normal:
        return Icons.info_outline;
      case ValidationStatusType.invalid:
        return Icons.cancel;
      case ValidationStatusType.valid:
        return Icons.check_circle;
    }
  }

  TextDirection get _mainDirection {
    TextDirection direction;

    if (widget.isTextFieldPassword) {
      direction = (text.isEmpty) ? TextDirection.rtl : TextDirection.ltr;
    } else {
      direction = (widget.textAlign != null && widget.textAlign == TextAlign.left)
          ? TextDirection.ltr
          : ((text.isEmpty) ? widget.hintDirection : widget.textDirection);
    }
    return direction;
  }

  TextDirection get _textDirection {
    TextDirection direction;
    if (widget.isTextFieldPassword) {
      direction = (text.isEmpty) ? TextDirection.rtl : TextDirection.ltr;
    } else {
      direction = (text.isNotEmpty && widget.textDirection == TextDirection.rtl && RegExp('[0-9]').hasMatch(text))
          ? TextDirection.ltr
          : ((text.isEmpty) ? widget.hintDirection : widget.textDirection);
    }
    return direction;
  }

  TextAlign get _textAlign {
    TextAlign? textAlign;
    if (widget.isTextFieldPassword) {
      textAlign = TextAlign.start;
    } else {
      textAlign = widget.textAlign ??
          ((text.isNotEmpty && widget.textDirection == TextDirection.rtl && RegExp('[0-9]').hasMatch(text))
              ? TextAlign.left
              : (text.isEmpty)
                  ? ((widget.hintDirection == TextDirection.rtl) ? TextAlign.right : TextAlign.left)
                  : (widget.textDirection == TextDirection.rtl)
                      ? TextAlign.right
                      : TextAlign.left);
    }
    return textAlign;
  }

  _onTextChange(String changedText) {
    String newText = changedText.replaceFarsiNumberCharacters();
    int lastSeparatorCount = ','.allMatches(newText).length;

    int offset = 0;

    if (widget.textEditingController != null) {
      offset = widget.textEditingController!.selection.baseOffset;

      int newSeparatorCount = ','.allMatches(newText).length;

      cursorIndex = min(offset + newSeparatorCount - lastSeparatorCount, newText.length);

      widget.textEditingController!.value = widget.textEditingController!.value.copyWith(
        text: newText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: cursorIndex!, affinity: TextAffinity.upstream),
        ),
      );
    }
    if (widget.onChanged != null) widget.onChanged!(newText);
    setState(() {
      if (changedText.isEmpty && widget.obscureState == null) _isVisibleTextContent = false;
      text = newText;
    });
  }

  _onSubmitted(String changedText) {
    String newText = changedText.replaceFarsiNumberCharacters();
    int lastSeparatorCount = ','.allMatches(newText).length;

    int offset = 0;

    if (widget.textEditingController != null) {
      offset = widget.textEditingController!.selection.baseOffset;

      int newSeparatorCount = ','.allMatches(newText).length;

      cursorIndex = min(offset + newSeparatorCount - lastSeparatorCount, newText.length);

      widget.textEditingController!.value = widget.textEditingController!.value.copyWith(
        text: newText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: cursorIndex!, affinity: TextAffinity.upstream),
        ),
      );
    }
    if (widget.onSubmitted != null) widget.onSubmitted!(newText);
    setState(() {
      if (changedText.isEmpty && widget.obscureState == null) _isVisibleTextContent = false;
      text = newText;
    });
  }

  _toggleVisibility() {
    setState(() {
      _isVisibleTextContent = !_isVisibleTextContent;
    });
  }

  _toggleKeyboardMode() async {
    _isNumericKeyboard = !_isNumericKeyboard;
    _isNumericKeyboard = await inject<SharedPreferencesHelper>().setBool('isNumericKeyboard', _isNumericKeyboard);
    FocusManager.instance.primaryFocus!.unfocus();
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500), () {});
    if (widget.focusNode != null) widget.focusNode!.requestFocus();
  }

  getBorder(BorderType type) {
    var borderColor = context.scheme().inputBorder;
    var width = Dimen.borderWidth;
    switch (type) {
      case BorderType.regularBorder:
        borderColor = context.scheme().inputBorder;
        break;
      case BorderType.enabledBorder:
        borderColor = context.scheme().inputBorder;
        break;
      case BorderType.focusedBorder:
        borderColor = context.scheme().titleText;
        width = Dimen.selectedBorderWidth;
        break;
      case BorderType.errorBorder:
        borderColor = context.scheme().error;

        break;
      case BorderType.focusedErrorBorder:
        borderColor = context.scheme().error;
        width = Dimen.selectedBorderWidth;

        break;
      case BorderType.disabledBorder:
        borderColor = context.scheme().boxBorder;
        break;
    }
    if (_hasInvalidValidation) {
      borderColor = context.scheme().error;
    }
    return OutlineInputBorder(
      borderSide: BorderSide(color: widget.borderColor ?? borderColor, width: widget.borderWidth ?? width),
      borderRadius: BorderRadius.circular(Dimen.inputRadius),
    );
  }
}

Widget _defaultContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
  return AdaptiveTextSelectionToolbar.editableText(
    editableTextState: editableTextState,
  );
}

enum BorderType { regularBorder, enabledBorder, disabledBorder, focusedBorder, errorBorder, focusedErrorBorder }
