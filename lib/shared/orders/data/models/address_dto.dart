class AddressDto {
  final String id;
  final String province;
  final String city;
  final String addressLine;
  final DateTime? createdAt;

  const AddressDto({
    required this.id,
    required this.province,
    required this.city,
    required this.addressLine,
    this.createdAt,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) => AddressDto(
    id: json['id']?.toString() ?? '',
    province: json['province']?.toString() ?? '',
    city: json['city']?.toString() ?? '',
    addressLine: json['address_line']?.toString() ?? '',
    createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
  );
}
