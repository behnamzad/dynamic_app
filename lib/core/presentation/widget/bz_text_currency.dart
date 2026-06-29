import 'package:dynamic_app/core/presentation/widget/bz_text.dart';
import 'package:dynamic_app/core/util/currency_manager.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:flutter/material.dart';

enum DisplayType { justAmount, justCurrencyUnitTitle, titleWithAmount }

class BzTextCurrency extends StatefulWidget {
  final DisplayType displayType;
  final int? amount;
  final String extraTextAppendToTitle;
  final TextStyle? style;
  final TextStyle? currencyUnitStyle;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final double? gap;

  const BzTextCurrency.justCurrencyAmount({
    super.key,
    required this.amount,
    required this.style,
    this.textDirection,
    this.overflow,
  })  : displayType = DisplayType.justAmount,
        currencyUnitStyle = null,
        gap = null,
        extraTextAppendToTitle = '';

  const BzTextCurrency.justCurrencyUnitTitle({
    super.key,
    required this.style,
    this.currencyUnitStyle,
    this.extraTextAppendToTitle = '',
  })  : displayType = DisplayType.justCurrencyUnitTitle,
        textDirection = null,
        overflow = null,
        gap = null,
        amount = null;

  const BzTextCurrency.amountWithTitle({
    super.key,
    required this.style,
    this.currencyUnitStyle,
    this.gap,
    required this.amount,
    this.extraTextAppendToTitle = '',
  })  : displayType = DisplayType.titleWithAmount,
        textDirection = null,
        overflow = null;

  @override
  State<BzTextCurrency> createState() => _BzTextCurrencyState();
}

class _BzTextCurrencyState extends State<BzTextCurrency> {
  ValueNotifier<bool> changeCurrencyNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: changeCurrencyNotifier,
      builder: (BuildContext context, value, Widget? child) {
        return buildBody();
      },
    );
  }

  buildBody() {
    Widget child = Container();
    switch (widget.displayType) {
      case DisplayType.justAmount:
        child = buildJustAmountContent();
        break;
      case DisplayType.justCurrencyUnitTitle:
        child = buildJustCurrencyUnitTitleContent();
        break;
      case DisplayType.titleWithAmount:
        child = buildTitleWithAmountContent();
        break;
    }
    return child;
  }

  buildTitleWithAmountContent() {
    return Row(
      children: [buildJustAmountContent(), SizedBox(width: widget.gap ?? 4), buildJustCurrencyUnitTitleContent()],
    );
  }

  buildJustCurrencyUnitTitleContent() {
    return BzText(
      '${inject<CurrencyManager>().getCurrencyCurrencyUnitTitle()}${widget.extraTextAppendToTitle}',
      style: widget.currencyUnitStyle ?? widget.style,
    );
  }

  buildJustAmountContent() {
    return BzText(
      widget.amount != null ? inject<CurrencyManager>().currencyFormat(widget.amount) : '',
      style: widget.style,
      overflow: widget.overflow,
      textDirection: widget.textDirection,
    );
  }
}
