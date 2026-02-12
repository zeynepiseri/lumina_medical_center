import 'package:equatable/equatable.dart';

class BranchEntity extends Equatable {
  final String id;
  final String name;
  final String shortName;
  final String imageUrl;

  const BranchEntity({
    required this.id,
    required this.name,
    required this.shortName,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, shortName, imageUrl];
}
