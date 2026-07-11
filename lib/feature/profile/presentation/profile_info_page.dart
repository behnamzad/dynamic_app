import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';

class ProfileInfoPage extends StatelessWidget {
  const ProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = inject<UserManager>().currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BasePageWidget(
        appBar: const BzAppBar(title: 'اطلاعات کاربر'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(context, user?.username ?? 'کاربر فروشگاه'),
              const VGap(18),
              _InfoTile(title: 'ایمیل', value: user?.email ?? '-'),
              const VGap(10),
              _InfoTile(title: 'نام کاربری', value: user?.username ?? '-'),
              const VGap(10),
              _InfoTile(title: 'جنسیت', value: user?.gender.persianTitle ?? '-'),
              const VGap(10),
              _InfoTile(title: 'سن', value: user?.age?.toString() ?? '-'),
              const VGap(10),
              _InfoTile(title: 'شناسه کاربر', value: user?.id ?? '-'),
              const VGap(10),
              _InfoTile(title: 'وضعیت ایمیل', value: user?.isEmailVerified == true ? 'تأیید شده' : 'تأیید نشده'),
              const VGap(10),
              _InfoTile(title: 'آخرین ورود', value: _formatDate(user?.lastSignInAt)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, String username) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.scheme().mainBackground4,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: context.scheme().primary.withValues(alpha: 0.12),
            child: Icon(Icons.person, color: context.scheme().primary, size: 28),
          ),
          const HGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BzText(
                  username,
                  style: context.headline5Bold.copyWith(color: context.scheme().titleText),
                ),
                const VGap(4),
                BzText(
                  'اطلاعات حساب کاربری',
                  style: context.body3Medium.copyWith(color: context.scheme().subText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: context.scheme().mainBackground1,
        border: Border.all(color: context.scheme().boxBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BzText(
            title,
            style: context.body3Medium.copyWith(color: context.scheme().subText),
          ),
          const VGap(6),
          BzText(
            value,
            textDirection: title == 'ایمیل' || title == 'شناسه کاربر' ? TextDirection.ltr : TextDirection.rtl,
            style: context.title2Bold.copyWith(color: context.scheme().mainText),
          ),
        ],
      ),
    );
  }
}
