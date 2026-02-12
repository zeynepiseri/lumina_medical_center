import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/constants/api_constants.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/get_upcoming_appointment_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_top_doctors_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/network/api_client.dart';

// Features - Auth
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/user_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/repositories/user_repository.dart';
import 'features/auth/data/repositories/user_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/change_password_usecase.dart';
import 'features/auth/domain/usecases/get_user_role_usecase.dart';
import 'features/auth/domain/usecases/get_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/update_profile_photo_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/login/login_cubit.dart';
import 'features/auth/presentation/cubit/register/register_cubit.dart';
import 'features/auth/presentation/cubit/user/user_cubit.dart';

// Features - Admin
import 'features/admin/data/datasources/admin_service.dart';
import 'features/admin/data/repositories/admin_repository_impl.dart';
import 'features/admin/domain/repositories/admin_repository.dart';
import 'features/admin/domain/usecases/add_doctor_usecase.dart';
import 'features/admin/domain/usecases/admin_add_branch_usecase.dart';
import 'features/admin/domain/usecases/get_all_doctors_usecase.dart';
import 'features/admin/domain/usecases/get_all_specialties_usecase.dart';
import 'features/admin/domain/usecases/get_dashboard_stats_usecase.dart';
import 'features/admin/domain/usecases/get_doctor_by_id_usecase.dart';
import 'features/admin/domain/usecases/update_doctor_usecase.dart';
import 'features/admin/presentation/bloc/admin_add_branch/admin_add_branch_cubit.dart';
import 'features/admin/presentation/bloc/admin_add_doctor/admin_add_doctor_cubit.dart';
import 'features/admin/presentation/bloc/admin_appointment_management/appointment_management_cubit.dart';
import 'features/admin/presentation/bloc/admin_dashboard_bloc.dart';
import 'features/admin/presentation/bloc/admin_doctor_list/admin_doctor_list_cubit.dart';
import 'features/admin/presentation/bloc/admin_edit_doctor/admin_edit_doctor_cubit.dart';

// Features - Doctor Dashboard
import 'features/doctor_dashboard/data/datasources/doctor_profile_service.dart';
import 'features/doctor_dashboard/data/repositories/doctor_dashboard_repository_impl.dart';
import 'features/doctor_dashboard/domain/repositories/doctor_dashboard_repository.dart';
import 'features/doctor_dashboard/domain/usecases/get_my_profile_usecase.dart';
import 'features/doctor_dashboard/domain/usecases/update_my_profile_usecase.dart';

// Features - Appointment
import 'features/appointment/data/datasources/appointment_service.dart';
import 'features/appointment/data/repositories/appointment_repository_impl.dart';
import 'features/appointment/domain/repositories/appointment_repository.dart';
import 'features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'features/appointment/domain/usecases/create_appointment_usecase.dart';
import 'features/appointment/domain/usecases/get_all_appointments_usecase.dart';
import 'features/appointment/domain/usecases/get_booked_slots_usecase.dart';
import 'features/appointment/domain/usecases/get_my_appointments_usecase.dart';
import 'features/appointment/domain/usecases/reschedule_appointment_usecase.dart';
import 'features/appointment/domain/usecases/update_appointment_usecase.dart';
import 'features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'features/appointment/presentation/bloc/appointment_bloc.dart';
import 'features/appointment/presentation/bloc/booking/booking_bloc.dart';

// Features - Branches
import 'features/branches/data/datasources/branch_remote_data_source.dart';
import 'features/branches/data/repositories/branch_repository_impl.dart';
import 'features/branches/domain/repositories/branch_repository.dart';
import 'features/branches/domain/usecases/get_all_branches_usecase.dart';
import 'features/branches/presentation/bloc/branch_bloc.dart';

// Features - Find Doctor
import 'features/find_doctor/data/datasources/doctor_service.dart';
import 'features/find_doctor/data/repositories/doctor_repository.dart';
import 'features/find_doctor/domain/repositories/doctor_repository.dart';
import 'features/find_doctor/domain/usecases/get_doctor_detail_usecase.dart';
import 'features/find_doctor/domain/usecases/get_doctors_usecase.dart';
import 'features/find_doctor/presentation/bloc/doctor_bloc.dart';
import 'features/find_doctor/presentation/bloc/doctor_detail_cubit.dart';

// Features - Patient
import 'features/patient/data/datasources/patient_remote_datasource.dart';
import 'features/patient/data/repositories/patient_repository_impl.dart';
import 'features/patient/domain/repositories/patient_repository.dart';
import 'features/patient/domain/usecases/get_patient_profile_usecase.dart';
import 'features/patient/domain/usecases/update_patient_vitals_usecase.dart';
import 'features/patient/presentation/bloc/patient_bloc.dart';

// Features - Profile
import 'features/profile/data/datasources/profile_file_service.dart';
import 'features/profile/presentation/bloc/upload_bloc/upload_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() {
    final baseUrl = NetworkConstants.apiBaseUrl;
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ),
    );
    return dio;
  });

  sl.registerLazySingleton(() => ApiClient(sl(), sl()));

  // 2. Data Sources (Services)
  sl.registerLazySingleton<AdminService>(() => AdminServiceImpl(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton(() => ProfileFileService(sl(), sl()));
  sl.registerLazySingleton(() => DoctorService(sl()));
  sl.registerLazySingleton(() => AppointmentService(sl()));
  sl.registerLazySingleton<BranchRemoteDataSource>(
    () => BranchRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(sl()),
  );
  // Doctor Dashboard Service
  sl.registerLazySingleton(() => DoctorProfileService(sl()));

  // 3. Repositories
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(sl()));
  sl.registerLazySingleton<DoctorRepository>(() => DoctorRepositoryImpl(sl()));
  // Doctor Dashboard Repository
  sl.registerLazySingleton<DoctorDashboardRepository>(
    () => DoctorDashboardRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<BranchRepository>(
    () => BranchRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // 4. Use Cases
  sl.registerLazySingleton(() => GetDoctorsUseCase(sl()));
  sl.registerLazySingleton(() => GetDoctorDetailUseCase(sl()));

  // Admin UseCases
  sl.registerLazySingleton(() => AddDoctorUseCase(sl()));
  sl.registerLazySingleton(() => GetAllSpecialtiesUseCase(sl()));
  sl.registerLazySingleton(() => GetAllBranchesUseCase(sl()));
  sl.registerLazySingleton(() => AdminAddBranchUseCase(sl()));
  sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetAllDoctorsUseCase(sl()));
  sl.registerLazySingleton(() => GetDoctorByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDoctorUseCase(sl()));

  // Doctor Dashboard UseCases
  sl.registerLazySingleton(() => GetMyProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMyProfileUseCase(sl()));

  // Appointment UseCases
  sl.registerLazySingleton(() => GetAllAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => CancelAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => RescheduleAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => GetMyAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => GetBookedSlotsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAppointmentUseCase(sl()));

  // Auth & User UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetUserRoleUseCase(sl()));

  sl.registerLazySingleton(() => GetUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfilePhotoUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));

  // Patient UseCases
  sl.registerLazySingleton(() => GetPatientProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePatientVitalsUseCase(sl()));

  // 5. BLoCs / Cubits

  // Appointment BLoCs
  sl.registerFactory(
    () => AppointmentBloc(
      getMyAppointmentsUseCase: sl(),
      cancelAppointmentUseCase: sl(),
    ),
  );

  // UserCubit
  sl.registerFactory(
    () => UserCubit(getUserUseCase: sl(), updateProfilePhotoUseCase: sl()),
  );

  sl.registerFactory(
    () => BookingBloc(
      getBookedSlotsUseCase: sl(),
      createAppointmentUseCase: sl(),
      updateAppointmentUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => AppointmentActionBloc(
      cancelAppointmentUseCase: sl(),
      rescheduleAppointmentUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => AppointmentManagementCubit(
      getAllAppointmentsUseCase: sl(),
      getAllDoctorsUseCase: sl(),
      cancelAppointmentUseCase: sl(),
    ),
  );

  // Admin BLoCs
  if (sl.isRegistered<AdminDashboardBloc>()) {
    sl.unregister<AdminDashboardBloc>();
  }
  sl.registerFactory(() => AdminDashboardBloc(sl()));

  if (sl.isRegistered<AddDoctorCubit>()) {
    sl.unregister<AddDoctorCubit>();
  }
  sl.registerFactory(
    () => AddDoctorCubit(addDoctorUseCase: sl(), getAllBranchesUseCase: sl()),
  );

  if (sl.isRegistered<AdminAddBranchCubit>()) {
    sl.unregister<AdminAddBranchCubit>();
  }
  sl.registerFactory(() => AdminAddBranchCubit(addBranchUseCase: sl()));

  if (sl.isRegistered<AdminDoctorListCubit>()) {
    sl.unregister<AdminDoctorListCubit>();
  }
  sl.registerFactory(() => AdminDoctorListCubit(sl()));

  if (sl.isRegistered<EditDoctorCubit>()) {
    sl.unregister<EditDoctorCubit>();
  }
  sl.registerFactory(
    () => EditDoctorCubit(
      getDoctorByIdUseCase: sl(),
      getAllBranchesUseCase: sl(),
      updateDoctorUseCase: sl(),
    ),
  );

  // BranchBloc
  sl.registerFactory(() => BranchBloc(getAllBranchesUseCase: sl()));

  // Auth BLoCs
  if (sl.isRegistered<LoginCubit>()) {
    sl.unregister<LoginCubit>();
  }
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));

  if (sl.isRegistered<RegisterCubit>()) {
    sl.unregister<RegisterCubit>();
  }
  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));

  if (sl.isRegistered<AuthCubit>()) {
    sl.unregister<AuthCubit>();
  }
  sl.registerFactory(
    () => AuthCubit(getUserRoleUseCase: sl(), logoutUseCase: sl()),
  );

  // Other BLoCs
  sl.registerFactory(() => UploadBloc(sl(), sl()));

  sl.registerFactory(
    () => PatientBloc(getPatientProfile: sl(), updatePatientVitals: sl()),
  );

  sl.registerFactory(() => DoctorBloc(sl()));
  sl.registerFactory(() => DoctorDetailCubit(sl()));
  sl.registerLazySingleton(() => GetTopDoctorsUseCase(sl()));
  sl.registerLazySingleton(() => GetUpcomingAppointmentUseCase(sl()));
}
