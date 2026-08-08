import 'package:dynamic_app/core/config/configs.dart';
import 'package:dynamic_app/core/local/user/user.dart';
import 'package:dynamic_app/core/presentation/widget/app/avatar_widget.dart';
import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/behavior/data/datasource/behavior_local_data_source.dart';

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
          const AvatarWidget(size: 58, fontSize: 24),
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
            onLongPress: inject<Configs>().allowToDeleteLocalLogs
                ? () async {
                    int deletedRow = await inject<BehaviorLocalDataSource>().deleteAllEvents();
                    inject<Logger>().e('deletedRow => $deletedRow');
                  }
                : () {},
            child: as.hoshopLogo.svg(height: 64, width: 64),
          ),
        ],
      ),
    );
  }
}
