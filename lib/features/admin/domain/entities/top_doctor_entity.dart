import 'package:equatable/equatable.dart';

class TopDoctorEntity extends Equatable {
  final String name;
  final String branch;
  final int appointmentCount;
  final String? imageUrl;
  final double rating;

  final String specialty;
  final double earnings;

  const TopDoctorEntity({
    required this.name,
    required this.branch,
    required this.appointmentCount,
    this.imageUrl,
    required this.rating,
    required this.specialty,
    required this.earnings,
  });

  @override
  List<Object?> get props => [
    name,
    branch,
    appointmentCount,
    imageUrl,
    rating,
    specialty,
    earnings,
  ];
}
