import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/core/presentation/widget/app/avatar_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/profile/presentation/profile_info_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = inject<UserManager>().currentUser;
    final username = user?.username?.isNotEmpty == true ? user!.username! : ss.storeUser;
    final email = user?.email.isNotEmpty == true ? user!.email : ss.emailNotRegistered;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BasePageWidget(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const VGap(18),
                const AvatarWidget(),
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
                  title: ss.profile,
                  icon: Icons.person,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileInfoPage()));
                  },
                ),
                const VGap(12),
                _ProfileMenuRow(title: ss.setting, icon: Icons.settings),
                const VGap(12),
                _ProfileMenuRow(title: ss.contactUs, icon: Icons.email),
                const VGap(12),
                _ProfileMenuRow(title: ss.shareApp, icon: Icons.share),
                const VGap(12),
                _ProfileMenuRow(title: ss.help, icon: Icons.help),
                const Spacer(),
                BzGestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: BzText(ss.logout, style: context.title2Bold.copyWith(color: context.scheme().error)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _ProfileMenuRow({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BzGestureDetector(
      onTap: onTap ?? () {},
      inkwellPadding: const EdgeInsets.symmetric(vertical: 4),
      materialColor: context.scheme().mainBackground4,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(icon, size: 24, color: context.scheme().mainText),
            const HGap(12),
            Expanded(
              child: BzText(title, style: context.body1Bold.copyWith(color: context.scheme().mainText)),
            ),
            Icon(Icons.chevron_right, size: 28, color: context.scheme().secondary),
          ],
        ),
      ),
    );
  }
}
