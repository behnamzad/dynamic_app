class CategoryEntity {
  final int id;
  final String name;
  final String imageUrl;
  final bool aiSuggest;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.aiSuggest = false,
  });

  const CategoryEntity.empty()
    : id = 0,
      name = '',
      imageUrl = '',
      aiSuggest = false;

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      aiSuggest: json['aiSuggest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'aiSuggest': aiSuggest,
    };
  }

  CategoryEntity copyWith({
    int? id,
    String? name,
    String? imageUrl,
    bool? aiSuggest,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      aiSuggest: aiSuggest ?? this.aiSuggest,
    );
  }
}
