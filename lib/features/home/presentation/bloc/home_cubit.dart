import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/usecases/get_all_branches_usecase.dart';

import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_top_doctors_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/get_upcoming_appointment_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTopDoctorsUseCase _getTopDoctorsUseCase;
  final GetUpcomingAppointmentUseCase _getUpcomingAppointmentUseCase;
  final GetUserUseCase _getUserUseCase;
  final GetAllBranchesUseCase _getAllBranchesUseCase;

  List<DoctorEntity> _allDoctors = [];

  HomeCubit({
    required GetTopDoctorsUseCase getTopDoctorsUseCase,
    required GetUpcomingAppointmentUseCase getUpcomingAppointmentUseCase,
    required GetUserUseCase getUserUseCase,
    required GetAllBranchesUseCase getAllBranchesUseCase,
  }) : _getTopDoctorsUseCase = getTopDoctorsUseCase,
       _getUpcomingAppointmentUseCase = getUpcomingAppointmentUseCase,
       _getUserUseCase = getUserUseCase,
       _getAllBranchesUseCase = getAllBranchesUseCase,
       super(const HomeState());

  Future<void> loadHomeData() async {
    if (isClosed) return;
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final results = await Future.wait([
        _getTopDoctorsUseCase(),
        _getUpcomingAppointmentUseCase(),
        _getUserUseCase(),
        _getAllBranchesUseCase(),
      ]);

      final doctorsResult = results[0] as dynamic;
      final appointmentResult = results[1] as dynamic;
      final userResult = results[2] as dynamic;
      final branchesResult = results[3] as dynamic;

      if (doctorsResult.isLeft() || branchesResult.isLeft()) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: "Veri yüklenemedi",
          ),
        );
        return;
      }

      List<DoctorEntity> doctors = [];
      doctorsResult.fold((l) => null, (r) => doctors = r);
      _allDoctors = doctors;

      AppointmentEntity? nextApp;
      appointmentResult.fold((l) => null, (r) => nextApp = r);

      String userName = "Welcome";
      String? userImage;
      userResult.fold((l) => null, (r) {
        userName = r.fullName;
        userImage = r.imageUrl;
      });

      List<BranchEntity> categories = [];
      branchesResult.fold((l) => null, (r) => categories = r);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          userName: userName,
          userImageUrl: userImage,
          categories: categories,
          topDoctors: doctors,
          upcomingAppointment: nextApp,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void search(String query) {
    if (state.status == HomeStatus.success) {
      final filteredDoctors = query.isEmpty
          ? _allDoctors
          : _allDoctors.where((doc) {
              final name = doc.fullName.toLowerCase();
              final searchLower = query.toLowerCase();
              return name.contains(searchLower);
            }).toList();

      emit(state.copyWith(topDoctors: filteredDoctors, searchQuery: query));
    }
  }

  void clearSearch() {
    if (state.status == HomeStatus.success) {
      emit(state.copyWith(topDoctors: _allDoctors, searchQuery: ''));
    }
  }
}
