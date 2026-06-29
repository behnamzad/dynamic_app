import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String province;
  final String city;
  final String exactAddress;

  const AddressEntity({required this.province, required this.city, required this.exactAddress});

  @override
  List<Object?> get props => [province, city, exactAddress];
}
