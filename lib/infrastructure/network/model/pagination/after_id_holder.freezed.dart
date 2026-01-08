// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'after_id_holder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AfterIdHolder<T> {
  int get offset => throw _privateConstructorUsedError;
  int? get length => throw _privateConstructorUsedError;
  T get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AfterIdHolderCopyWith<T, AfterIdHolder<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AfterIdHolderCopyWith<T, $Res> {
  factory $AfterIdHolderCopyWith(
          AfterIdHolder<T> value, $Res Function(AfterIdHolder<T>) then) =
      _$AfterIdHolderCopyWithImpl<T, $Res, AfterIdHolder<T>>;
  @useResult
  $Res call({int offset, int? length, T data});
}

/// @nodoc
class _$AfterIdHolderCopyWithImpl<T, $Res, $Val extends AfterIdHolder<T>>
    implements $AfterIdHolderCopyWith<T, $Res> {
  _$AfterIdHolderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? length = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AfterIdHolderImplCopyWith<T, $Res>
    implements $AfterIdHolderCopyWith<T, $Res> {
  factory _$$AfterIdHolderImplCopyWith(_$AfterIdHolderImpl<T> value,
          $Res Function(_$AfterIdHolderImpl<T>) then) =
      __$$AfterIdHolderImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({int offset, int? length, T data});
}

/// @nodoc
class __$$AfterIdHolderImplCopyWithImpl<T, $Res>
    extends _$AfterIdHolderCopyWithImpl<T, $Res, _$AfterIdHolderImpl<T>>
    implements _$$AfterIdHolderImplCopyWith<T, $Res> {
  __$$AfterIdHolderImplCopyWithImpl(_$AfterIdHolderImpl<T> _value,
      $Res Function(_$AfterIdHolderImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? length = freezed,
    Object? data = freezed,
  }) {
    return _then(_$AfterIdHolderImpl<T>(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$AfterIdHolderImpl<T> extends _AfterIdHolder<T> {
  const _$AfterIdHolderImpl(
      {required this.offset, this.length, required this.data})
      : super._();

  @override
  final int offset;
  @override
  final int? length;
  @override
  final T data;

  @override
  String toString() {
    return 'AfterIdHolder<$T>(offset: $offset, length: $length, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AfterIdHolderImpl<T> &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.length, length) || other.length == length) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, offset, length, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AfterIdHolderImplCopyWith<T, _$AfterIdHolderImpl<T>> get copyWith =>
      __$$AfterIdHolderImplCopyWithImpl<T, _$AfterIdHolderImpl<T>>(
          this, _$identity);
}

abstract class _AfterIdHolder<T> extends AfterIdHolder<T> {
  const factory _AfterIdHolder(
      {required final int offset,
      final int? length,
      required final T data}) = _$AfterIdHolderImpl<T>;
  const _AfterIdHolder._() : super._();

  @override
  int get offset;
  @override
  int? get length;
  @override
  T get data;
  @override
  @JsonKey(ignore: true)
  _$$AfterIdHolderImplCopyWith<T, _$AfterIdHolderImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
