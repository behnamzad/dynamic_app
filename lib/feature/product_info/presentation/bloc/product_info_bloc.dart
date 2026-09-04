import 'dart:async';

import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/cart/domain/repository/cart_repository.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalization_action.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalization_decision.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalized_product_suggestion.dart';
import 'package:dynamic_app/shared/personalization/domain/manager/personalization_manager.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/shared/product/domain/repository/product_repo.dart';

part 'product_info_bloc.freezed.dart';
part 'product_info_event.dart';
part 'product_info_state.dart';

@injectable
class ProductInfoBloc extends Bloc<ProductInfoEvent, ProductInfoState> {
  static const String _recommendationStrategy = 'collaborative_purchase_probability';

  final ProductRepo _productRepo;
  final CartRepository _cartRepository;
  final CartManager _cartManager;
  final PersonalizationManager _personalizationManager;
  final Logger _logger;
  bool _personalizationEnabled = true;

  ProductInfoBloc(
    this._productRepo,
    this._cartRepository,
    this._cartManager,
    this._personalizationManager,
    this._logger,
  ) : super(ProductInfoState.initial()) {
    on<_Init>(_initialize);
    on<_GetProduct>(_loadProduct);
    on<_LoadPersonalization>(_loadPersonalization);
    on<_AddToCart>(_addToCart);
    on<_RemoveFromCart>(_removeFromCart);
  }

  void init({required int productId, required bool personalizationEnabled}) {
    _personalizationEnabled = personalizationEnabled;
    add(ProductInfoEvent.init(productId: productId));
  }

  // region Product loading

  void _initialize(_Init event, Emitter<ProductInfoState> emit) {
    emit(state.copyWith(status: ProductLoadStatus.loading, errorMessage: null));

    final ProductEntity? providedProduct = event.entity;
    if (providedProduct != null) {
      _showProduct(providedProduct, emit);
      return;
    }

    final int? productId = event.productId;
    if (productId != null) {
      add(ProductInfoEvent.getProduct(productId));
      return;
    }

    _showPageError(ss.productNotProvided, emit);
  }

  Future<void> _loadProduct(_GetProduct event, Emitter<ProductInfoState> emit) async {
    try {
      final Result<ProductEntity> result = await _productRepo.getProduct(id: event.productId);
      switch (result) {
        case Success<ProductEntity>(data: final ProductEntity product):
          _showProduct(product, emit);
        case Failure<ProductEntity>(error: final error):
          _showPageError(error.message, emit);
      }
    } catch (error, stackTrace) {
      _logger.w('Product loading failed', error: error, stackTrace: stackTrace);
      _showPageError(ss.generalError, emit);
    }
  }

  void _showProduct(ProductEntity product, Emitter<ProductInfoState> emit) {
    emit(
      _withoutPersonalization(
        status: PersonalizationStatus.initial,
        productStatus: ProductLoadStatus.loaded,
        product: product,
      ).copyWith(isInCart: _cartManager.containsProduct(product.id), errorMessage: null),
    );
    if (_personalizationEnabled) {
      add(ProductInfoEvent.loadPersonalization(product));
    }
  }

  void _showPageError(String message, Emitter<ProductInfoState> emit) {
    emit(state.copyWith(status: ProductLoadStatus.failed, errorMessage: message));
  }

  // endregion

  // region Personalization

  Future<void> _loadPersonalization(_LoadPersonalization event, Emitter<ProductInfoState> emit) async {
    emit(_withoutPersonalization(status: PersonalizationStatus.loading));

    try {
      final PersonalizationDecision decision = await _personalizationManager.decisionForProduct(event.product);

      switch (decision.action) {
        case PersonalizationAction.showAlternativeProducts:
          await _showAlternativeProducts(event.product, decision, emit);
        case PersonalizationAction.highlightReviewsAndSpecifications:
          _showDecision(decision, emit);
        case PersonalizationAction.highlightAddToCartButton:
          _showDecision(decision, emit);
      }
    } catch (error, stackTrace) {
      _logger.w('Product personalization is unavailable', error: error, stackTrace: stackTrace);
      emit(_withoutPersonalization(status: PersonalizationStatus.unavailable));
    }
  }

  Future<void> _showAlternativeProducts(
    ProductEntity product,
    PersonalizationDecision decision,
    Emitter<ProductInfoState> emit,
  ) async {
    List<PersonalizedProductSuggestion> suggestions;
    try {
      suggestions = await _personalizationManager.alternativeProductsFor(product);
    } catch (error, stackTrace) {
      _logger.w('Alternative products are unavailable', error: error, stackTrace: stackTrace);
      suggestions = const <PersonalizedProductSuggestion>[];
    }
    if (suggestions.isEmpty) {
      _showDecision(decision.withAction(PersonalizationAction.highlightReviewsAndSpecifications), emit);
      return;
    }

    _showDecision(decision, emit, suggestions: suggestions, recommendationStrategy: _recommendationStrategy);
  }

  void _showDecision(
    PersonalizationDecision decision,
    Emitter<ProductInfoState> emit, {
    List<PersonalizedProductSuggestion> suggestions = const <PersonalizedProductSuggestion>[],
    String? recommendationStrategy,
  }) {
    emit(
      state.copyWith(
        personalizationStatus: PersonalizationStatus.ready,
        personalizationDecision: decision,
        alternativeProductSuggestions: suggestions,
        recommendationStrategy: recommendationStrategy,
      ),
    );
  }

  ProductInfoState _withoutPersonalization({
    required PersonalizationStatus status,
    ProductLoadStatus? productStatus,
    ProductEntity? product,
  }) {
    return state.copyWith(
      status: productStatus ?? state.status,
      productEntity: product ?? state.productEntity,
      personalizationStatus: status,
      personalizationDecision: null,
      alternativeProductSuggestions: const <PersonalizedProductSuggestion>[],
      recommendationStrategy: null,
    );
  }

  // endregion

  // region Cart

  Future<void> _addToCart(_AddToCart event, Emitter<ProductInfoState> emit) async {
    _showCartLoading(emit);
    final Result<CartProductEntity> result = await _cartRepository.addProduct(
      entity: event.product,
      quantity: event.quantity,
      recommendationAttribution: event.recommendationAttribution,
    );
    switch (result) {
      case Success<CartProductEntity>():
        emit(state.copyWith(cartActionStatus: CartActionStatus.added, isInCart: true, errorMessage: null));
      case Failure<CartProductEntity>(error: final error):
        _showCartError(error.message, emit);
    }
  }

  Future<void> _removeFromCart(_RemoveFromCart event, Emitter<ProductInfoState> emit) async {
    _showCartLoading(emit);
    final Result<void> result = await _cartRepository.removeProduct(event.productId);
    switch (result) {
      case Success<void>():
        emit(
          state.copyWith(
            cartActionStatus: CartActionStatus.removed,
            isInCart: _cartManager.containsProduct(event.productId),
            errorMessage: null,
          ),
        );
      case Failure<void>(error: final error):
        _showCartError(error.message, emit);
    }
  }

  void _showCartLoading(Emitter<ProductInfoState> emit) {
    emit(state.copyWith(cartActionStatus: CartActionStatus.loading, errorMessage: null));
  }

  void _showCartError(String message, Emitter<ProductInfoState> emit) {
    emit(state.copyWith(cartActionStatus: CartActionStatus.failed, errorMessage: message));
  }

  // endregion
}
