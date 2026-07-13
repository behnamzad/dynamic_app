import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';

class AvatarWidget extends StatelessWidget {
  final double? size;
  final double? fontSize;

  const AvatarWidget({super.key, this.size, this.fontSize});

  @override
  Widget build(BuildContext context) {
    String username = inject<UserManager>().currentUsername ?? '';
    final firstLetter = username.trim().isEmpty ? '-' : username.trim().characters.first.toUpperCase();

    return Container(
      width: size ?? 78,
      height: size ?? 78,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.scheme().primary.withValues(alpha: 0.12),
        border: Border.all(color: context.scheme().primary.withValues(alpha: 0.18), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Center(
          child: BzText(
            firstLetter,
            style: context.headline1Bold.copyWith(color: context.scheme().primary, fontSize: fontSize ?? 28),
          ),
        ),
      ),
    );
  }
}
