import 'package:dynamic_app/core/util/common_ui_imports.dart';

class CheckoutRow extends StatelessWidget {
  final String title;

  final String? subTitle;

  final IconData icon;
  final IconData? endIcon;
  final VoidCallback? onTapEndIcon;

  const CheckoutRow(
      {super.key, required this.title, this.subTitle, required this.icon, this.endIcon, this.onTapEndIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: context.scheme().primary2),
            child: Icon(
              icon,
              color: context.scheme().primary,
              size: 32,
            ),
          ),
          const HGap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BzText(
                title,
                style: context.body1Bold.copyWith(color: context.scheme().titleText),
              ),
              if (subTitle != null)
                BzText(
                  subTitle!,
                  style: context.body2Regular.copyWith(color: context.scheme().mainText),
                ),
            ],
          ),
          const Spacer(),
          if (endIcon != null)
            BzGestureDetector(
                inkwellPadding: const EdgeInsets.all(8),
                onTap: () => onTapEndIcon != null ? onTapEndIcon!.call() : {},
                child: Icon(endIcon, size: 22))
        ],
      ),
    );
  }
}
