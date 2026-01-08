import 'package:dynamic_app/core/util/extension/context_ext.dart';
import 'package:flutter/material.dart';

class SizedCircularProgressIndicator extends StatelessWidget {
  const SizedCircularProgressIndicator({
    super.key,
    required this.width,
    required this.height,
    this.color,
    this.strokeWidth = 3,
  });

  final double width;
  final double height;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? context.scheme().primary),
      ),
    );
  }
}
