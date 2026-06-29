import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String lastName;
  final String firstName;
  final String imgPath;
  final String email;

  const UserEntity(
      {required this.id, required this.lastName, required this.firstName, required this.imgPath, required this.email});

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, lastName, firstName, imgPath, email];
}
