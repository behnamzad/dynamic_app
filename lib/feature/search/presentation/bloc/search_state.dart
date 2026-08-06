part of 'search_bloc.dart';

enum SearchStatus {
  initial,
  loading,
  loaded,
  failed;

  bool get isInitial => this == SearchStatus.initial;

  bool get isLoading => this == SearchStatus.loading;

  bool get isLoaded => this == SearchStatus.loaded;

  bool get isFailed => this == SearchStatus.failed;
}

@freezed
class SearchState with _$SearchState {
  factory SearchState.initial({
    @Default(SearchStatus.initial) SearchStatus status,
    @Default('') String query,
    CategoryEntity? categoryEntity,
    BrandEntity? brandEntity,
    SearchResultEntity? result,
    String? errorMessage,
  }) = _Initial;
}
