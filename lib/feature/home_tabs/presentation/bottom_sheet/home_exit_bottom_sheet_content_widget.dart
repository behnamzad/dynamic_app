import 'dart:io';

import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:flutter/services.dart';

class HomeExitBottomSheetContentWidget extends StatelessWidget {
  const HomeExitBottomSheetContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 0),
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(color: context.scheme().mainBackground3, borderRadius: BorderRadius.circular(100)),
          child: Icon(
            Icons.logout,
            color: context.scheme().mainText,
            size: 30,
          ),
        ),
        const SizedBox(height: 26),
        AdaText('ss.exitDes', style: context.title2Medium.copyWith(color: context.scheme().mainText)),
        const SizedBox(height: 36),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: AdaButton.outline(
                  text: ss.no,
                  onPressed: () => Navigator.pop(context),
                  borderColor: context.scheme().buttonBorder2,
                  textColor: context.scheme().titleText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdaButton.submit(
                  text: ss.yes,
                  onPressed: () {
                    _closeApp();
                  },
                  backgroundColor: context.scheme().primary,
                  textColor: context.scheme().mainButtonText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  _closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
      exit(0);
    } else if (Platform.isIOS) {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
  }
}
