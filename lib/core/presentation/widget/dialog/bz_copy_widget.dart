import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:flutter/services.dart';

class BzCopyWidget extends StatefulWidget {
  final String text;
  final String? actionBtnText;
  final Function(String) onCopySelected;

  const BzCopyWidget({super.key, required this.text, required this.onCopySelected, this.actionBtnText});

  @override
  State<BzCopyWidget> createState() => _BzCopyWidgetState();
}

class _BzCopyWidgetState extends State<BzCopyWidget> {
  bool isCopied = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: context.scheme().primary, borderRadius: BorderRadius.circular(100)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.scheme().mainBackground1,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: BzText(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: context.title1Bold.copyWith(color: context.scheme().titleText),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 48,
                margin: const EdgeInsets.only(right: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.text));
                    setState(() {
                      isCopied = true;
                    });
                    _resetCopyState();
                    widget.onCopySelected(widget.text);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isCopied ? Icons.check : Icons.copy, size: 22, color: context.scheme().primaryBold),
                      const SizedBox(width: 12),
                      BzText(
                        isCopied ? ss.copied : widget.actionBtnText ?? ss.copy,
                        style: context.body1Bold.copyWith(color: context.scheme().primaryBold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _resetCopyState() {
    Future.delayed(const Duration(seconds: 2), () => setState(() => isCopied = false));
  }
}
