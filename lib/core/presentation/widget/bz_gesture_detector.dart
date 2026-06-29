import 'package:dynamic_app/core/config/dimen.dart';
import 'package:flutter/material.dart';

class BzGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final VoidCallback? onLongPress;
  final EdgeInsets? inkwellPadding;
  final BorderRadius? borderRadius;
  final Color? materialColor;

  const BzGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.inkwellPadding,
    this.borderRadius,
    this.materialColor,
    this.onTapDown,
    this.onTapUp,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius ?? BorderRadius.circular(Dimen.buttonRadius),
      color: materialColor ?? Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(Dimen.buttonRadius),
        onTap: () {
          onTap != null ? onTap!() : {};
        },
        onTapDown: (_) {
          onTapDown != null ? onTapDown!() : {};
        },
        onLongPress: () {
          onLongPress != null ? onLongPress!() : {};
        },
        onTapUp: (_) {
          onTapUp != null ? onTapUp!() : {};
        },
        child: Padding(padding: inkwellPadding ?? const EdgeInsets.all(8.0), child: child),
      ),
    );
  }
}
