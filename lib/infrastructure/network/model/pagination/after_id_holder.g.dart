// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'after_id_holder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AfterIdHolder<T> _$AfterIdHolderFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    AfterIdHolder<T>(
      offset: (json['offset'] as num).toInt(),
      length: (json['length'] as num?)?.toInt(),
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$AfterIdHolderToJson<T>(
  AfterIdHolder<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'offset': instance.offset,
      'length': instance.length,
      'data': toJsonT(instance.data),
    };
