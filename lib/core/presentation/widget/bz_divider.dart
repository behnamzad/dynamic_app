import 'package:dynamic_app/core/util/common_ui_imports.dart';

class BzDivider extends StatelessWidget {
  final double? thickness;
  final Color? color;

  const BzDivider({super.key, this.thickness, this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: thickness ?? Theme.of(context).dividerTheme.thickness,
      color: color ?? context.scheme().divider,
    );
  }
}
