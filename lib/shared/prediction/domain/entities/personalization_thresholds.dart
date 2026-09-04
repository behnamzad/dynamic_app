/// مرزهای سه حالت UI که همراه مدل منتشر می‌شوند.
class PersonalizationThresholds {
  const PersonalizationThresholds({required this.alternativeProductsMax, required this.informationHighlightMax});

  static const PersonalizationThresholds fallback = PersonalizationThresholds(
    alternativeProductsMax: 0.025,
    informationHighlightMax: 0.05,
  );

  final double alternativeProductsMax;
  final double informationHighlightMax;
}
