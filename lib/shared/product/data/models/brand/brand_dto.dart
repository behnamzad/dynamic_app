class BrandDto {
  final int id;
  final String titleFa;
  final String titleEn;
  final String image;

  const BrandDto({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    required this.image,
  });

  factory BrandDto.fromJson(Map<String, dynamic> json) => BrandDto(
    id: _int(json['id']),
    titleFa: _string(json['title_fa']),
    titleEn: _string(json['title_en']),
    image: _string(json['image']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_fa': titleFa,
    'title_en': titleEn,
    'image': image,
  };
}

int _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

String _string(Object? value) => value?.toString() ?? '';
