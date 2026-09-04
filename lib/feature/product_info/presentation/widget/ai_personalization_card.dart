import 'package:dynamic_app/core/util/common_ui_imports.dart';

/// ظاهر مشترک بخش‌هایی که با تصمیم مدل هوش مصنوعی تغییر کرده‌اند.
class AiPersonalizationCard extends StatefulWidget {
  const AiPersonalizationCard({
    super.key,
    required this.title,
    this.description,
    required this.child,
    this.bgGradientColors,
  });

  final String title;
  final String? description;
  final Widget child;
  final List<Color>? bgGradientColors;

  @override
  State<AiPersonalizationCard> createState() => _AiPersonalizationCardState();
}

class _AiPersonalizationCardState extends State<AiPersonalizationCard> with SingleTickerProviderStateMixin {
  late final AnimationController _borderController;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(vsync: this, duration: const Duration(milliseconds: 4000));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations) {
      _borderController.stop();
      _borderController.value = 0.5;
    } else if (!_borderController.isAnimating) {
      _borderController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final Color primary = context.scheme().primary;
    final Color white = context.scheme().mainBackground1;
    final List<Color> iconColors = <Color>[context.scheme().link, const Color(0xFFB94CFF)];
    final List<Color> borderGradientColors =
        widget.bgGradientColors ?? [const Color(0xFF793BD7),  const Color(0xFF998EE3),const Color(0xFF3B89D7),];

    return TweenAnimationBuilder<double>(
      duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? content) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: Transform.scale(scale: 0.97 + (0.03 * value), child: content),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _borderController,
        builder: (BuildContext context, Widget? content) {
          final double progress = Curves.easeInOut.transform(_borderController.value);
          return Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              gradient: SweepGradient(
                center: Alignment.center,
                colors: borderGradientColors,
                transform: GradientRotation(progress * 6.283185307179586),
              ),
              borderRadius: BorderRadius.circular(20.5),
            ),
            child: content,
          );
        },
        child: Container(
          decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(19)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: -74,
                top: -65,
                child: Opacity(opacity: 0.06, child: as.hoshopLogo.svg(width: 260, height: 260)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            border: BoxBorder.all(width: 1.5, color: context.scheme().mainBackground1),
                            gradient: LinearGradient(
                              colors: iconColors,
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(padding: const EdgeInsets.all(7), child: as.hoshadOutlineIcon.svg()),
                        ),
                        const HGap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              BzText(
                                widget.title,
                                style: context.body1Bold.copyWith(color: context.scheme().titleText),
                              ),
                              if (widget.description != null) ...[
                                const VGap(4),
                                BzText(
                                  widget.description!,
                                  style: context.body4Medium.copyWith(color: context.scheme().subText, height: 1.5),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const VGap(16),
                    widget.child,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// زمانی نمایش داده می‌شود که مدل هنوز در حال آماده‌کردن نتیجه است.
class AiPersonalizationLoading extends StatefulWidget {
  const AiPersonalizationLoading({super.key});

  @override
  State<AiPersonalizationLoading> createState() => _AiPersonalizationLoadingState();
}

class _AiPersonalizationLoadingState extends State<AiPersonalizationLoading> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = context.scheme().primary;
    final Color blue = context.scheme().link;
    final bool disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Container(
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[primary, blue]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        decoration: BoxDecoration(color: context.scheme().mainBackground1, borderRadius: BorderRadius.circular(12.8)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return TweenAnimationBuilder<double>(
                    key: UniqueKey(),
                    duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 1400),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (BuildContext context, double progress, Widget? child) {
                      final double logoSize = 36 + (104 * progress);
                      final double startLeft = constraints.maxWidth - 48;
                      final double left = startLeft + ((-24 - startLeft) * progress);

                      return Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Positioned(
                            left: left,
                            top: (constraints.maxHeight - logoSize + 20) / 2,
                            child: Opacity(
                              opacity: 0.5 - (0.43 * progress),
                              child: as.hoshopLogo.svg(width: logoSize, height: logoSize),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      final double progress = _controller.value;
                      return Transform.translate(
                        offset: Offset(0, -3 * progress),
                        child: Transform.scale(
                          scale: 0.94 + (progress * 0.1),
                          child: Container(
                            width: 42,
                            height: 42,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(-2 + (progress * 4), -1),
                                end: Alignment(-1 + (progress * 4), 1),
                                colors: <Color>[primary, const Color(0xFFB94CFF), blue],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            child: as.hoshadOutlineIcon.svg(width: 30, height: 30),
                          ),
                        ),
                      );
                    },
                  ),
                  const HGap(10),
                  Expanded(
                    child: BzText(
                      ss.aiAnalyzingTitle,
                      style: context.body2Medium.copyWith(color: context.scheme().titleText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// قاب کوتاه مخصوص دکمه‌ای که مدل می‌خواهد بیشتر دیده شود.
class AiPersonalizationButton extends StatelessWidget {
  const AiPersonalizationButton({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color primary = context.scheme().primary;
    final Color blue = context.scheme().link;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[primary, blue]),
            borderRadius: BorderRadius.circular(17),
            boxShadow: <BoxShadow>[BoxShadow(color: primary.withValues(alpha: 0.35), blurRadius: 18, spreadRadius: 1)],
          ),
          child: child,
        ),
        PositionedDirectional(
          top: -12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[primary, blue]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.scheme().mainBackground1, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 13),
                const HGap(4),
                BzText(label, style: context.body5Bold.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
