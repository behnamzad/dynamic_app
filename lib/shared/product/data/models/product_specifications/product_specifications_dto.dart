import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_specifications_dto.freezed.dart';
part 'product_specifications_dto.g.dart';

@freezed
class ProductSpecificationDto with _$ProductSpecificationDto {
  const factory ProductSpecificationDto({
    required int status,
    required List<SpecGroupDto> result,
  }) = _SpecsResponseDto;

  factory ProductSpecificationDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSpecificationDtoFromJson(json);
}

@freezed
class SpecGroupDto with _$SpecGroupDto {
  const factory SpecGroupDto({
    required String title,
    required List<SpecAttributeDto> attributes,
  }) = _SpecGroupDto;

  factory SpecGroupDto.fromJson(Map<String, dynamic> json) =>
      _$SpecGroupDtoFromJson(json);
}

@freezed
class SpecAttributeDto with _$SpecAttributeDto {
  const factory SpecAttributeDto({
    required String title,
    required List<String> values,
  }) = _SpecAttributeDto;

  factory SpecAttributeDto.fromJson(Map<String, dynamic> json) =>
      _$SpecAttributeDtoFromJson(json);
}