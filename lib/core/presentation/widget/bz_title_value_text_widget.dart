import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:flutter/services.dart';

class BzTitleValueTextWidget extends StatelessWidget {
  final List<BzTitleValueText> items;
  final double itemSpacingSize;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const BzTitleValueTextWidget({
    super.key,
    required this.items,
    this.itemSpacingSize = 20,
    this.titleStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _getItems(context, context.scheme()),
    );
  }

  List<Widget> _getItems(BuildContext context, ColorScheme scheme) {
    List<Widget> widgets = [];
    for (var item in items) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BzText(item.title, style: titleStyle ?? context.body2Regular),
                const SizedBox(width: 24),
              ],
            ),
            _getValueWidget(item, context, scheme),
          ],
        ),
      );
      if (items.last != item) widgets.add(SizedBox(height: itemSpacingSize));
    }

    return widgets;
  }

  Widget _getValueWidget(BzTitleValueText item, BuildContext context, ColorScheme scheme) {
    if (item.isCopyable) {
      return Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(Dimen.buttonRadius),
            onTap: () {
              Clipboard.setData(ClipboardData(text: item.value));
              showToastCopy(text: ss.copied, bottomPadding: MediaQuery.of(context).size.height / 2);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 32,
                  height: 24,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: item.value));
                        showToastCopy(text: ss.copied, bottomPadding: MediaQuery.of(context).size.height / 2);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Icon(Icons.copy_sharp, color: context.scheme().subText, size: 20),
                    ),
                  ),
                ),
                Flexible(
                  child: BzText(
                    item.value,
                    style: valueStyle ?? context.body1Medium.copyWith(color: context.scheme().mainText),
                    textDirection: item.direction,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (item.flexible) {
      return Flexible(
        child: BzText(
          item.value,
          style: item.valueStyle ?? valueStyle ?? context.body1Medium.copyWith(color: context.scheme().mainText),
          textDirection: item.direction,
        ),
      );
    } else {
      return BzText(
        item.value,
        style: item.valueStyle ?? valueStyle ?? context.body1Medium.copyWith(color: context.scheme().mainText),
        textDirection: item.direction,
      );
    }
  }
}

class BzTitleValueText {
  final String title;
  final String value;
  final TextDirection direction;
  final bool isCopyable;
  final bool flexible;
  final TextStyle? valueStyle;

  const BzTitleValueText({
    required this.title,
    required this.value,
    this.isCopyable = false,
    this.flexible = false,
    this.direction = TextDirection.ltr,
    this.valueStyle,
  });
}
