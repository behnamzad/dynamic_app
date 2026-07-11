import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/profile/presentation/profile_info_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = inject<UserManager>().currentUser;
    final username = user?.username?.isNotEmpty == true ? user!.username! : 'کاربر فروشگاه';
    final email = user?.email.isNotEmpty == true ? user!.email : 'ایمیل ثبت نشده';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BasePageWidget(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const VGap(18),
                _avatar(context, username),
                const VGap(12),
                BzText(
                  username,
                  textAlign: TextAlign.center,
                  style: context.headline2Bold.copyWith(color: context.scheme().titleText),
                ),
                const VGap(4),
                BzText(
                  email,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: context.body3Medium.copyWith(color: context.scheme().subText),
                ),
                const VGap(28),
                _ProfileMenuRow(
                  title: 'پروفایل',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileInfoPage()),
                    );
                  },
                ),
                const VGap(12),
                const _ProfileMenuRow(title: 'تنظیمات', icon: Icons.settings),
                const VGap(12),
                const _ProfileMenuRow(title: 'تماس با ما', icon: Icons.email),
                const VGap(12),
                const _ProfileMenuRow(title: 'اشتراک‌گذاری اپ', icon: Icons.share),
                const VGap(12),
                const _ProfileMenuRow(title: 'راهنما', icon: Icons.help),
                const Spacer(),
                BzGestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: BzText(
                      'خروج از حساب',
                      style: context.title2Bold.copyWith(color: context.scheme().error),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar(BuildContext context, String username) {
    final firstLetter = username.trim().isEmpty ? '-' : username.trim().characters.first.toUpperCase();

    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.scheme().primary.withValues(alpha: 0.12),
        border: Border.all(color: context.scheme().primary.withValues(alpha: 0.18), width: 1),
      ),
      child: Center(
        child: BzText(
          firstLetter,
          style: context.headline1Bold.copyWith(color: context.scheme().primary),
        ),
      ),
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _ProfileMenuRow({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BzGestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: context.scheme().mainBackground4,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 25, color: context.scheme().mainText),
            const HGap(12),
            Expanded(
              child: BzText(
                title,
                style: context.title2Bold.copyWith(color: context.scheme().mainText),
              ),
            ),
            Icon(Icons.chevron_left, size: 28, color: context.scheme().secondary),
          ],
        ),
      ),
    );
  }
}
