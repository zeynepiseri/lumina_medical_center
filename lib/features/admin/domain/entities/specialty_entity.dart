import 'package:equatable/equatable.dart';

class SpecialtyEntity extends Equatable {
  final int id;
  final String name;

  const SpecialtyEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
