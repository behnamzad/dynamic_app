// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_base_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppBaseEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool isStartLoading, String? loadingMessage)
        changeLoading,
    required TResult Function(bool isStartLoading, String? loadingMessage)
        changeLoadingOverBottomSheet,
    required TResult Function(ThemeMode themeMode) changeTheme,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool isStartLoading, String? loadingMessage)?
        changeLoading,
    TResult? Function(bool isStartLoading, String? loadingMessage)?
        changeLoadingOverBottomSheet,
    TResult? Function(ThemeMode themeMode)? changeTheme,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool isStartLoading, String? loadingMessage)?
        changeLoading,
    TResult Function(bool isStartLoading, String? loadingMessage)?
        changeLoadingOverBottomSheet,
    TResult Function(ThemeMode themeMode)? changeTheme,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeLoading value) changeLoading,
    required TResult Function(_ChangeLoadingOverBottomSheet value)
        changeLoadingOverBottomSheet,
    required TResult Function(_ChangeTheme value) changeTheme,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeLoading value)? changeLoading,
    TResult? Function(_ChangeLoadingOverBottomSheet value)?
        changeLoadingOverBottomSheet,
    TResult? Function(_ChangeTheme value)? changeTheme,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeLoading value)? changeLoading,
    TResult Function(_ChangeLoadingOverBottomSheet value)?
        changeLoadingOverBottomSheet,
    TResult Function(_ChangeTheme value)? changeTheme,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppBaseEventCopyWith<$Res> {
  factory $AppBaseEventCopyWith(
          AppBaseEvent value, $Res Function(AppBaseEvent) then) =
      _$AppBaseEventCopyWithImpl<$Res, AppBaseEvent>;
}

/// @nodoc
class _$AppBaseEventCopyWithImpl<$Res, $Val extends AppBaseEvent>
    implements $AppBaseEventCopyWith<$Res> {
  _$AppBaseEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ChangeLoadingImplCopyWith<$Res> {
  factory _$$ChangeLoadingImplCopyWith(
          _$ChangeLoadingImpl value, $Res Function(_$ChangeLoadingImpl) then) =
      __$$ChangeLoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isStartLoading, String? loadingMessage});
}

/// @nodoc
class __$$ChangeLoadingImplCopyWithImpl<$Res>
    extends _$AppBaseEventCopyWithImpl<$Res, _$ChangeLoadingImpl>
    implements _$$ChangeLoadingImplCopyWith<$Res> {
  __$$ChangeLoadingImplCopyWithImpl(
      _$ChangeLoadingImpl _value, $Res Function(_$ChangeLoadingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isStartLoading = null,
    Object? loadingMessage = freezed,
  }) {
    return _then(_$ChangeLoadingImpl(
      isStartLoading: null == isStartLoading
          ? _value.isStartLoading
          : isStartLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMessage: freezed == loadingMessage
          ? _value.loadingMessage
          : loadingMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ChangeLoadingImpl implements _ChangeLoading {
  const _$ChangeLoadingImpl(
      {required this.isStartLoading, this.loadingMessage});

  @override
  final bool isStartLoading;
  @override
  final String? loadingMessage;

  @override
  String toString() {
    return 'AppBaseEvent.changeLoading(isStartLoading: $isStartLoading, loadingMessage: $loadingMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeLoadingImpl &&
            (identical(other.isStartLoading, isStartLoading) ||
                other.isStartLoading == isStartLoading) &&
            (identical(other.loadingMessage, loadingMessage) ||
                other.loadingMessage == loadingMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isStartLoading, loadingMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeLoadingImplCopyWith<_$ChangeLoadingImpl> get copyWith =>
      __$$ChangeLoadingImplCopyWithImpl<_$ChangeLoadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool isStartLoading, String? loadingMessage)
        changeLoading,
    required TResult Function(bool isStartLoading, String? loadingMessage)
        changeLoadingOverBottomSheet,
    required TResult Function(ThemeMode themeMode) changeTheme,
  }) {
    return changeLoading(isStartLoading, loadingMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool isStartLoading, String? loadingMessage)?
        changeLoading,
    TResult? Function(bool isStartLoading, String? loadingMessage)?
        changeLoadingOverBottomSheet,
    TResult? Function(ThemeMode themeMode)? changeTheme,
  }) {
    return changeLoading?.call(isStartLoading, loadingMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool isStartLoading, String? loadingMessage)?
        changeLoading,
    TResult Function(bool isStartLoading, String? loadingMessage)?
        changeLoadingOverBottomSheet,
    TResult Function(ThemeMode themeMode)? changeTheme,
    required TResult orElse(),
  }) {
    if (changeLoading != null) {
      return changeLoading(isStartLoading, loadingMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeLoading value) changeLoading,
    required TResult Function(_ChangeLoadingOverBottomSheet value)
        changeLoadingOverBottomSheet,
    required TResult Function(_ChangeTheme value) changeTheme,
  }) {
    return changeLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeLoading value)? changeLoading,
    TResult? Function(_ChangeLoadingOverBottomSheet value)?
        changeLoadingOverBottomSheet,
    TResult? Function(_ChangeTheme value)? changeTheme,
  }) {
    return changeLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeLoading value)? changeLoading,
    TResult Function(_ChangeLoadingOverBottomSheet value)?
        changeLoadingOverBottomSheet,
    TResult Function(_ChangeTheme value)? changeTheme,
    required TResult orElse(),
  }) {
    if (changeLoading != null) {
      return changeLoading(this);
    }
    return orElse();
  }
}

abstract class _ChangeLoading implements AppBaseEvent {
  const factory _ChangeLoading(
      {required final bool isStartLoading,
      final String? loadingMessage}) = _$ChangeLoadingImpl;

  bool get isStartLoading;
  String? get loadingMessage;
  @JsonKey(ignore: true)
  _$$ChangeLoadingImplCopyWith<_$ChangeLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChangeLoadingOverBottomSheetImplCopyWith<$Res> {
  factory _$$ChangeLoadingOverBottomSheetImplCopyWith(
          _$ChangeLoadingOverBottomSheetImpl value,
          $Res Function(_$ChangeLoadingOverBottomSheetImpl) then) =
      __$$ChangeLoadingOverBottomSheetImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isStartLoading, String? loadingMessage});
}

/// @nodoc
class __$$ChangeLoadingOverBottomSheetImplCopyWithImpl<$Res>
    extends _$AppBaseEventCopyWithImpl<$Res, _$ChangeLoadingOverBottomSheetImpl>
    implements _$$ChangeLoadingOverBottomSheetImplCopyWith<$Res> {
  __$$ChangeLoadingOverBottomSheetImplCopyWithImpl(
      _$ChangeLoadingOverBottomSheetImpl _value,
      $Res Function(_$ChangeLoadingOverBottomSheetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isStartLoading = null,
    Object? loadingMessage = freezed,
  }) {
    return _then(_$ChangeLoadingOverBottomSheetImpl(
      isStartLoading: null == isStartLoading
          ? _value.isStartLoading
          : isStartLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMessage: freezed == loadingMessage
          ? _value.loadingMessage
          : loadingMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ChangeLoadingOverBottomSheetImpl
    implements _ChangeLoadingOverBottomSheet {
  const _$ChangeLoadingOverBottomSheetImpl(
      {required this.isStartLoading, this.loadingMessage});

  @override
  final bool isStartLoading;
  @override
  final String? loadingMessage;

  @override
  String toString() {
    return 'AppBaseEvent.changeLoadingOverBottomSheet(isStartLoading: $isStartLoading, loadingMessage: $loadingMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeLoadingOverBottomSheetImpl &&
            (identical(other.isStartLoading, isStartLoading) ||
                other.isStartLoading == isStartLoading) &&
            (identical(other.loadingMessage, loadingMessage) ||
                other.loadingMessage == loadingMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isStartLoading, loadingMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeLoadingOverBottomSheetImplCopyWith<
          _$ChangeLoadingOverBottomSheetImpl>
      get copyWith => __$$ChangeLoadingOverBottomSheetImplCopyWithImpl<
          _$ChangeLoadingOverBottomSheetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool isStartLoading, String? loadingMessage)
        changeLoading,
    required TResult Function(bool isStartLoading, String? loadingMessage)
        changeLoadingOverBottomSheet,
    required TResult Function(ThemeMode themeMode) changeTheme,
  }) {
    return changeLoadingOverBottomSheet(isStartLoading, loadingMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool isStartLoading, String? loadingMessage)?
        changeLoading,
    TResult? Function(bool isStartLoading, String? loadingMessage)?
        changeLoadingOverBottomSheet,
    TResult? Function(ThemeMode themeMode)? changeTheme,
  }) {
    return changeLoadingOverBottomSheet?.call(isStartLoading, loadingMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool isStartLoading, String? loadingMessage)?
        changeLoading,
    TResult Function(bool isStartLoading, String? loadingMessage)?
        changeLoadingOverBottomSheet,
    TResult Function(ThemeMode themeMode)? changeTheme,
    required TResult orElse(),
  }) {
    if (changeLoadingOverBottomSheet != null) {
      return changeLoadingOverBottomSheet(isStartLoading, loadingMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeLoading value) changeLoading,
    required TResult Function(_ChangeLoadingOverBottomSheet value)
        changeLoadingOverBottomSheet,
    required TResult Function(_ChangeTheme value) changeTheme,
  }) {
    return changeLoadingOverBottomSheet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeLoading value)? changeLoading,
    TResult? Function(_ChangeLoadingOverBottomSheet value)?
        changeLoadingOverBottomSheet,
    TResult? Function(_ChangeTheme value)? changeTheme,
  }) {
    return changeLoadingOverBottomSheet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeLoading value)? changeLoading,
    TResult Function(_ChangeLoadingOverBottomSheet value)?
        changeLoadingOverBottomSheet,
    TResult Function(_ChangeTheme value)? changeTheme,
    required TResult orElse(),
  }) {
    if (changeLoadingOverBottomSheet != null) {
      return changeLoadingOverBottomSheet(this);
    }
    return orElse();
  }
}

abstract class _ChangeLoadingOverBottomSheet implements AppBaseEvent {
  const factory _ChangeLoadingOverBottomSheet(
      {required final bool isStartLoading,
      final String? loadingMessage}) = _$ChangeLoadingOverBottomSheetImpl;

  bool get isStartLoading;
  String? get loadingMessage;
  @JsonKey(ignore: true)
  _$$ChangeLoadingOverBottomSheetImplCopyWith<
          _$ChangeLoadingOverBottomSheetImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChangeThemeImplCopyWith<$Res> {
  factory _$$ChangeThemeImplCopyWith(
          _$ChangeThemeImpl value, $Res Function(_$ChangeThemeImpl) then) =
      __$$ChangeThemeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ThemeMode themeMode});
}

/// @nodoc
class __$$ChangeThemeImplCopyWithImpl<$Res>
    extends _$AppBaseEventCopyWithImpl<$Res, _$ChangeThemeImpl>
    implements _$$ChangeThemeImplCopyWith<$Res> {
  __$$ChangeThemeImplCopyWithImpl(
      _$ChangeThemeImpl _value, $Res Function(_$ChangeThemeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
  }) {
    return _then(_$ChangeThemeImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
    ));
  }
}

/// @nodoc

class _$ChangeThemeImpl implements _ChangeTheme {
  const _$ChangeThemeImpl({required this.themeMode});

  @override
  final ThemeMode themeMode;

  @override
  String toString() {
    return 'AppBaseEvent.changeTheme(themeMode: $themeMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeThemeImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, themeMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeThemeImplCopyWith<_$ChangeThemeImpl> get copyWith =>
      __$$ChangeThemeImplCopyWithImpl<_$ChangeThemeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool isStartLoading, String? loadingMessage)
        changeLoading,
    required TResult Function(bool isStartLoading, String? loadingMessage)
        changeLoadingOverBottomSheet,
    required TResult Function(ThemeMode themeMode) changeTheme,
  }) {
    return changeTheme(themeMode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool isStartLoading, String? loadingMessage)?
        changeLoading,
    TResult? Function(bool isStartLoading, String? loadingMessage)?
        changeLoadingOverBottomSheet,
    TResult? Function(ThemeMode themeMode)? changeTheme,
  }) {
    return changeTheme?.call(themeMode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool isStartLoading, String? loadingMessage)?
        changeLoading,
    TResult Function(bool isStartLoading, String? loadingMessage)?
        changeLoadingOverBottomSheet,
    TResult Function(ThemeMode themeMode)? changeTheme,
    required TResult orElse(),
  }) {
    if (changeTheme != null) {
      return changeTheme(themeMode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ChangeLoading value) changeLoading,
    required TResult Function(_ChangeLoadingOverBottomSheet value)
        changeLoadingOverBottomSheet,
    required TResult Function(_ChangeTheme value) changeTheme,
  }) {
    return changeTheme(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ChangeLoading value)? changeLoading,
    TResult? Function(_ChangeLoadingOverBottomSheet value)?
        changeLoadingOverBottomSheet,
    TResult? Function(_ChangeTheme value)? changeTheme,
  }) {
    return changeTheme?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ChangeLoading value)? changeLoading,
    TResult Function(_ChangeLoadingOverBottomSheet value)?
        changeLoadingOverBottomSheet,
    TResult Function(_ChangeTheme value)? changeTheme,
    required TResult orElse(),
  }) {
    if (changeTheme != null) {
      return changeTheme(this);
    }
    return orElse();
  }
}

abstract class _ChangeTheme implements AppBaseEvent {
  const factory _ChangeTheme({required final ThemeMode themeMode}) =
      _$ChangeThemeImpl;

  ThemeMode get themeMode;
  @JsonKey(ignore: true)
  _$$ChangeThemeImplCopyWith<_$ChangeThemeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppBaseState {
  OverlayLoadingStatus get overlayLoadingStatus =>
      throw _privateConstructorUsedError;
  ThemeStatus get themeStatus => throw _privateConstructorUsedError;
  String? get loadingMessage => throw _privateConstructorUsedError;
  int? get salt => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppBaseStateCopyWith<AppBaseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppBaseStateCopyWith<$Res> {
  factory $AppBaseStateCopyWith(
          AppBaseState value, $Res Function(AppBaseState) then) =
      _$AppBaseStateCopyWithImpl<$Res, AppBaseState>;
  @useResult
  $Res call(
      {OverlayLoadingStatus overlayLoadingStatus,
      ThemeStatus themeStatus,
      String? loadingMessage,
      int? salt,
      ThemeMode themeMode});
}

/// @nodoc
class _$AppBaseStateCopyWithImpl<$Res, $Val extends AppBaseState>
    implements $AppBaseStateCopyWith<$Res> {
  _$AppBaseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overlayLoadingStatus = null,
    Object? themeStatus = null,
    Object? loadingMessage = freezed,
    Object? salt = freezed,
    Object? themeMode = null,
  }) {
    return _then(_value.copyWith(
      overlayLoadingStatus: null == overlayLoadingStatus
          ? _value.overlayLoadingStatus
          : overlayLoadingStatus // ignore: cast_nullable_to_non_nullable
              as OverlayLoadingStatus,
      themeStatus: null == themeStatus
          ? _value.themeStatus
          : themeStatus // ignore: cast_nullable_to_non_nullable
              as ThemeStatus,
      loadingMessage: freezed == loadingMessage
          ? _value.loadingMessage
          : loadingMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      salt: freezed == salt
          ? _value.salt
          : salt // ignore: cast_nullable_to_non_nullable
              as int?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppBaseStateImplCopyWith<$Res>
    implements $AppBaseStateCopyWith<$Res> {
  factory _$$AppBaseStateImplCopyWith(
          _$AppBaseStateImpl value, $Res Function(_$AppBaseStateImpl) then) =
      __$$AppBaseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OverlayLoadingStatus overlayLoadingStatus,
      ThemeStatus themeStatus,
      String? loadingMessage,
      int? salt,
      ThemeMode themeMode});
}

/// @nodoc
class __$$AppBaseStateImplCopyWithImpl<$Res>
    extends _$AppBaseStateCopyWithImpl<$Res, _$AppBaseStateImpl>
    implements _$$AppBaseStateImplCopyWith<$Res> {
  __$$AppBaseStateImplCopyWithImpl(
      _$AppBaseStateImpl _value, $Res Function(_$AppBaseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overlayLoadingStatus = null,
    Object? themeStatus = null,
    Object? loadingMessage = freezed,
    Object? salt = freezed,
    Object? themeMode = null,
  }) {
    return _then(_$AppBaseStateImpl(
      overlayLoadingStatus: null == overlayLoadingStatus
          ? _value.overlayLoadingStatus
          : overlayLoadingStatus // ignore: cast_nullable_to_non_nullable
              as OverlayLoadingStatus,
      themeStatus: null == themeStatus
          ? _value.themeStatus
          : themeStatus // ignore: cast_nullable_to_non_nullable
              as ThemeStatus,
      loadingMessage: freezed == loadingMessage
          ? _value.loadingMessage
          : loadingMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      salt: freezed == salt
          ? _value.salt
          : salt // ignore: cast_nullable_to_non_nullable
              as int?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
    ));
  }
}

/// @nodoc

class _$AppBaseStateImpl implements _AppBaseState {
  const _$AppBaseStateImpl(
      {this.overlayLoadingStatus = OverlayLoadingStatus.stopLoading,
      this.themeStatus = ThemeStatus.initialDefaultTheme,
      this.loadingMessage,
      this.salt,
      this.themeMode = ThemeMode.system});

  @override
  @JsonKey()
  final OverlayLoadingStatus overlayLoadingStatus;
  @override
  @JsonKey()
  final ThemeStatus themeStatus;
  @override
  final String? loadingMessage;
  @override
  final int? salt;
  @override
  @JsonKey()
  final ThemeMode themeMode;

  @override
  String toString() {
    return 'AppBaseState(overlayLoadingStatus: $overlayLoadingStatus, themeStatus: $themeStatus, loadingMessage: $loadingMessage, salt: $salt, themeMode: $themeMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppBaseStateImpl &&
            (identical(other.overlayLoadingStatus, overlayLoadingStatus) ||
                other.overlayLoadingStatus == overlayLoadingStatus) &&
            (identical(other.themeStatus, themeStatus) ||
                other.themeStatus == themeStatus) &&
            (identical(other.loadingMessage, loadingMessage) ||
                other.loadingMessage == loadingMessage) &&
            (identical(other.salt, salt) || other.salt == salt) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, overlayLoadingStatus,
      themeStatus, loadingMessage, salt, themeMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppBaseStateImplCopyWith<_$AppBaseStateImpl> get copyWith =>
      __$$AppBaseStateImplCopyWithImpl<_$AppBaseStateImpl>(this, _$identity);
}

abstract class _AppBaseState implements AppBaseState {
  const factory _AppBaseState(
      {final OverlayLoadingStatus overlayLoadingStatus,
      final ThemeStatus themeStatus,
      final String? loadingMessage,
      final int? salt,
      final ThemeMode themeMode}) = _$AppBaseStateImpl;

  @override
  OverlayLoadingStatus get overlayLoadingStatus;
  @override
  ThemeStatus get themeStatus;
  @override
  String? get loadingMessage;
  @override
  int? get salt;
  @override
  ThemeMode get themeMode;
  @override
  @JsonKey(ignore: true)
  _$$AppBaseStateImplCopyWith<_$AppBaseStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
