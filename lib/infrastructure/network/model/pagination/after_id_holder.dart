import 'package:freezed_annotation/freezed_annotation.dart';

part 'after_id_holder.freezed.dart';
part 'after_id_holder.g.dart';

@freezed
@JsonSerializable(genericArgumentFactories: true)
class AfterIdHolder<T> with _$AfterIdHolder<T> {
  const AfterIdHolder._();

  const factory AfterIdHolder({
    required int offset,
    int? length,
    required T data,
  }) = _AfterIdHolder<T>;

  factory AfterIdHolder.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$AfterIdHolderFromJson(json, fromJsonT);
  }
}
