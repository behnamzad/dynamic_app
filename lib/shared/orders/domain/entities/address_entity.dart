import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String province;
  final String city;
  final String addressLine;
  final DateTime? createdAt;

  const AddressEntity({
    required this.id,
    required this.province,
    required this.city,
    required this.addressLine,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, province, city, addressLine, createdAt];
}
