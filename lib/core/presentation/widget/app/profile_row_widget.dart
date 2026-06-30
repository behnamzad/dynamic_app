import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/user/domain/entities/user_entity.dart';

class ProfileRowWidget extends StatelessWidget {
  final UserEntity entity;

  const ProfileRowWidget({super.key, required this.entity});

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
              BzText('سلام 😊', style: context.body3Regular),
              const VGap(2),
              BzText(entity.fullName, style: context.headline3Bold),
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
