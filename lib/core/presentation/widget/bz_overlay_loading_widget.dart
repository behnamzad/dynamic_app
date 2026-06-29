import 'package:dynamic_app/core/config/dimen.dart';
import 'package:dynamic_app/core/config/strings.dart';
import 'package:dynamic_app/core/presentation/widget/bz_text.dart';
import 'package:dynamic_app/core/util/extension/context_ext.dart';
import 'package:dynamic_app/core/style/app_theme.dart';
import 'package:flutter/material.dart';

class BzOverLayLoadingWidget extends StatelessWidget {
  final String? message;

  const BzOverLayLoadingWidget({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimen.popupRadius),
            color: context.scheme().mainBackground1),
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 16),
          child: Material(
            color: context.scheme().mainBackground1,
            child: Row(
              children: [
                Expanded(
                  child: BzText(
                    message ?? ss.pleaseWait,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.fade,
                    style: context.body1Regular.copyWith(color: context.scheme().titleText),
                  ),
                ),
                SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
