import 'package:json_annotation/json_annotation.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse {
  final int status;
  final List<CategoryDto> result;

  CategoryResponse({required this.status, required this.result});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}

@JsonSerializable()
class CategoryDto {
  final int id;
  final String title;

  @JsonKey(name: 'url')
  final UrlDto? url;

  @JsonKey(name: 'plp_url')
  final UrlDto? plpUrl;

  final int? rowNumber;
  final String? icon;

  @JsonKey(name: 'column_number')
  final int? columnNumber;

  final String? image;

  final List<CategoryDto>? children;

  CategoryDto({
    required this.id,
    required this.title,
    this.url,
    this.plpUrl,
    this.rowNumber,
    this.icon,
    this.columnNumber,
    this.image,
    this.children,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}

@JsonSerializable()
class UrlDto {
  final String? url;
  final String? page;

  final Map<String, dynamic>? params;

  @JsonKey(name: 'queries')
  final Map<String, dynamic>? queries;

  UrlDto({this.url, this.page, this.params, this.queries});

  factory UrlDto.fromJson(Map<String, dynamic> json) => _$UrlDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UrlDtoToJson(this);
}
