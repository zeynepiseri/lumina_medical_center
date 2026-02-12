import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/data/models/doctor_model.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String userName;
  final String? userImageUrl;
  final List<BranchEntity> categories;
  final List<DoctorEntity> topDoctors;
  final AppointmentEntity? upcomingAppointment;
  final String? searchQuery;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.userName = '',
    this.userImageUrl,
    this.categories = const [],
    this.topDoctors = const [],
    this.upcomingAppointment,
    this.searchQuery,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? userName,
    String? userImageUrl,
    List<BranchEntity>? categories,
    List<DoctorEntity>? topDoctors,
    AppointmentEntity? upcomingAppointment,
    String? searchQuery,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      categories: categories ?? this.categories,
      topDoctors: topDoctors ?? this.topDoctors,
      upcomingAppointment: upcomingAppointment ?? this.upcomingAppointment,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userName,
    userImageUrl,
    categories,
    topDoctors,
    upcomingAppointment,
    searchQuery,
    errorMessage,
  ];
}
