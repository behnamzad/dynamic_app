/// تغییری که صفحه با توجه به احتمال خرید انجام می‌دهد.
enum PersonalizationAction {
  showAlternativeProducts,
  highlightReviewsAndSpecifications,
  highlightAddToCartButton;

  String get wireName => switch (this) {
    PersonalizationAction.showAlternativeProducts => 'show_alternative_products',
    PersonalizationAction.highlightReviewsAndSpecifications => 'highlight_reviews_and_specifications',
    PersonalizationAction.highlightAddToCartButton => 'highlight_add_to_cart_button',
  };
}
