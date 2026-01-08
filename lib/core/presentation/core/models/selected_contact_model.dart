import 'package:equatable/equatable.dart';

class SelectedContactModel extends Equatable {
  final String name;
  final String number;

  const SelectedContactModel(this.name, this.number);

  @override
  List<Object?> get props => [name, number];
}
