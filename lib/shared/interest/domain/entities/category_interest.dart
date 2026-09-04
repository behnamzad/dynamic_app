class CategoryInterest {
  const CategoryInterest({
    required this.categoryId,
    required this.categoryName,
    required this.totalScore,
    required this.recentScore,
  });

  final String categoryId;
  final String categoryName;
  final double totalScore;

  /// امتیاز رفتارهای ۳۰ روز اخیر.
  final double recentScore;
}
