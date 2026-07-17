import 'package:dynamic_app/core/style/app_theme.dart';
import 'package:dynamic_app/core/util/extension/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BzShimmerLoadingWidget extends StatelessWidget {
  final ShimmerDirection direction;
  final Color? baseColor;
  final Color? highlightColor;
  final double height;
  final double? width;
  final EdgeInsets? padding;
  final double borderRadius;
  final bool isLoading;
  final Widget child;

  const BzShimmerLoadingWidget({
    super.key,
    this.direction = ShimmerDirection.rtl,
    this.baseColor,
    this.highlightColor,
    required this.height,
    this.width,
    this.padding,
    this.borderRadius = 4,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            direction: direction,
            baseColor: baseColor ?? context.scheme().shimmerBaseColor,
            highlightColor: highlightColor ?? context.scheme().shimmerHighlightColor,
            child: Container(
              height: height,
              width: width,
              margin: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: context.scheme().mainBackground1,
              ),
            ),
          )
        : child;
  }
}
