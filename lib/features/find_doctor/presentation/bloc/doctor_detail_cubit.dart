import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/repositories/doctor_repository.dart';

import '../../domain/usecases/get_doctor_detail_usecase.dart';

enum DoctorDetailStatus { initial, loading, success, failure }

class DoctorDetailState extends Equatable {
  final DoctorDetailStatus status;
  final DoctorEntity? doctor;
  final bool isFavorite;
  final String? errorMessage;

  const DoctorDetailState({
    this.status = DoctorDetailStatus.initial,
    this.doctor,
    this.isFavorite = false,
    this.errorMessage,
  });

  DoctorDetailState copyWith({
    DoctorDetailStatus? status,
    DoctorEntity? doctor,
    bool? isFavorite,
    String? errorMessage,
  }) {
    return DoctorDetailState(
      status: status ?? this.status,
      doctor: doctor ?? this.doctor,
      isFavorite: isFavorite ?? this.isFavorite,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, doctor, isFavorite, errorMessage];
}

class DoctorDetailCubit extends Cubit<DoctorDetailState> {
  final GetDoctorDetailUseCase _getDoctorDetailUseCase;

  DoctorDetailCubit(this._getDoctorDetailUseCase)
    : super(const DoctorDetailState());

  Future<void> loadDoctor(int id) async {
    emit(state.copyWith(status: DoctorDetailStatus.loading));

    final result = await _getDoctorDetailUseCase(id);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DoctorDetailStatus.failure,
            errorMessage: failure.errorMessage,
          ),
        );
      },
      (doctor) {
        emit(
          state.copyWith(status: DoctorDetailStatus.success, doctor: doctor),
        );
      },
    );
  }

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }
}
