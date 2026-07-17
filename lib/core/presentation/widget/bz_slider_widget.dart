import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';

class BzSlider extends StatefulWidget {
  const BzSlider({
    super.key,
    required this.itemList,
    this.onPageChanged,
    this.controller,
    this.showIndicator = true,
    this.indicatorIntoSlider = false,
    this.enlargeFactor = 0.07,
    this.height,
    this.viewportFraction,
    this.indicatorMargin,
    this.aspectRatio,
    this.activeIndicatorColor,
    this.deActiveIndicatorColor,
    this.initialPage,
  });

  final List<Widget> itemList;
  final Function(int)? onPageChanged;
  final CarouselSliderController? controller;
  final bool showIndicator;
  final bool indicatorIntoSlider;
  final double enlargeFactor;
  final double? height;
  final double? aspectRatio;
  final double? viewportFraction;
  final EdgeInsets? indicatorMargin;
  final Color? activeIndicatorColor;
  final Color? deActiveIndicatorColor;
  final int? initialPage;

  @override
  State<BzSlider> createState() => _BzSliderState();
}

class _BzSliderState extends State<BzSlider> {
  late final CarouselSliderController _carouselController;

  int _currentAccountDeposit = 0;
  int duration = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = widget.controller ?? CarouselSliderController();
    _currentAccountDeposit = widget.initialPage ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.indicatorIntoSlider) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              initialPage: widget.initialPage ?? 0,
              autoPlay: widget.itemList.length > 1 ? true : false,
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayInterval: const Duration(seconds: 6),
              height: widget.height,
              aspectRatio: widget.aspectRatio ?? 16 / 9,
              enlargeCenterPage: true,
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              viewportFraction: widget.viewportFraction ??
                  (MediaQuery.of(context).size.width - 40) / MediaQuery.of(context).size.width,
              padEnds: true,
              clipBehavior: Clip.none,
              enlargeFactor: widget.enlargeFactor,
              enableInfiniteScroll: false,
              onPageChanged: (int index, CarouselPageChangedReason reason) {
                widget.onPageChanged?.call(index);
                setState(() {
                  _currentAccountDeposit = index;
                });
              },
            ),
            items: widget.itemList,
          ),
          if (widget.showIndicator && widget.itemList.length > 1)
            Positioned(
              bottom: 10,
              child: Container(
                height: 14,
                padding: const EdgeInsets.only(left: 2, right: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: context.scheme().secondary,
                ),
                child: _indicatorIconIntoSlider(context, widget.indicatorMargin),
              ),
            ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              initialPage: widget.initialPage ?? 0,
              autoPlay: widget.itemList.length > 1 ? true : false,
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayInterval: const Duration(seconds: 6),
              height: widget.height,
              aspectRatio: widget.aspectRatio ?? 16 / 9,
              enlargeCenterPage: true,
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              viewportFraction: widget.viewportFraction ??
                  (MediaQuery.of(context).size.width - 40) / MediaQuery.of(context).size.width,
              padEnds: true,
              clipBehavior: Clip.none,
              enlargeFactor: widget.enlargeFactor,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                widget.onPageChanged?.call(index);
                setState(() {
                  _currentAccountDeposit = index;
                });
              },
            ),
            items: widget.itemList,
          ),
          if (widget.showIndicator) _indicatorIcon(context, widget.indicatorMargin),
        ],
      );
    }
  }

  _indicatorIcon(BuildContext context, EdgeInsets? margin) {
    return Visibility(
      visible: widget.itemList.length > 1,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.itemList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: _currentAccountDeposit == entry.key ? 10 : 7,
                height: _currentAccountDeposit == entry.key ? 10 : 7,
                margin: margin ?? const EdgeInsets.only(right: 3, left: 3, top: 14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentAccountDeposit == entry.key
                      ? widget.activeIndicatorColor ?? context.scheme().primary
                      : widget.deActiveIndicatorColor ?? context.scheme().buttonBorder2,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  _indicatorIconIntoSlider(BuildContext context, EdgeInsets? margin) {
    return Visibility(
      visible: widget.itemList.length > 1,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.itemList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: _currentAccountDeposit == entry.key ? 6 : 6,
                height: _currentAccountDeposit == entry.key ? 6 : 6,
                margin: margin ?? const EdgeInsets.only(right: 3, left: 3, top: 14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentAccountDeposit == entry.key
                      ? widget.activeIndicatorColor ?? acs.mainButtonText.light
                      : widget.deActiveIndicatorColor ?? Colors.white.withValues(alpha: 0.5),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
