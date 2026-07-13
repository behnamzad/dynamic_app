import 'package:dynamic_app/core/local/user/user.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';

class ProfileRowWidget extends StatelessWidget {
  final AppUser user;

  const ProfileRowWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          //image
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              borderRadius: Dimen.defaultBorderRadius,
              color: context.scheme().success,
            ),
          ),
          const HGap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BzText('${ss.hello} 😊', style: context.body3Regular),
              const VGap(2),
              BzText(user.username, style: context.headline3Bold),
            ],
          ),
          const Spacer(),
          BzGestureDetector(
            materialColor: context.scheme().mainBackground2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.settings,
                size: 24,
                color: context.scheme().profileIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
