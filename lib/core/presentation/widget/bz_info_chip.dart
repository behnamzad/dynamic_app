import 'package:dynamic_app/core/util/common_ui_imports.dart';

class BzInfoChip extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? iconColor;

  const BzInfoChip({super.key, required this.text, this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: context.scheme().mainBackground4, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: iconColor ?? context.scheme().primary),
              const HGap(4),
            ],
            Flexible(
              child: BzText(
                text,
                style: context.body4Medium.copyWith(color: context.scheme().mainText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
