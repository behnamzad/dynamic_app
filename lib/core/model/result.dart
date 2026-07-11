import 'package:dynamic_app/core/exception/result_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
export 'package:dynamic_app/core/exception/result_exception.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;

  const factory Result.failure(ResultException error) = Failure<T>;
}
