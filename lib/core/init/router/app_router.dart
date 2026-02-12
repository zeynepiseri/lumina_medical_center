import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/layout/main_wrapper.dart';
import 'package:lumina_medical_center/features/admin/data/models/admin_doctor_model.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_event.dart';
import 'package:lumina_medical_center/features/admin/presentation/pages/add_doctor_page.dart';
import 'package:lumina_medical_center/features/admin/presentation/pages/admin_main_screen.dart';
import 'package:lumina_medical_center/features/admin/presentation/pages/admin_doctor_list_page.dart';
import 'package:lumina_medical_center/features/admin/presentation/pages/edit_doctor_page.dart';
import 'package:lumina_medical_center/features/admin/presentation/pages/manage_appointments_page.dart';
import 'package:lumina_medical_center/features/admin/presentation/pages/add_branch_page.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:lumina_medical_center/features/find_doctor/data/models/doctor_model.dart';
import 'package:lumina_medical_center/features/appointment/presentation/pages/doctor_appointment_detail_page.dart';
import 'package:lumina_medical_center/features/appointment/data/datasources/appointment_service.dart';
import 'package:lumina_medical_center/features/appointment/presentation/pages/my_appointments_page.dart';
import 'package:lumina_medical_center/features/auth/presentation/pages/login_page.dart';
import 'package:lumina_medical_center/features/auth/presentation/pages/register_page.dart';
import 'package:lumina_medical_center/features/auth/presentation/pages/welcome_page.dart';
import 'package:lumina_medical_center/features/branches/presentation/pages/branches_page.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/pages/doctor_profile_page.dart';

import 'package:lumina_medical_center/features/find_doctor/presentation/pages/doctor_detail_page.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/pages/doctor_list_page.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/pages/doctors_page.dart';
import 'package:lumina_medical_center/features/home/presentation/pages/home_page.dart';
import 'package:lumina_medical_center/features/profile/presentation/pages/profile_page.dart';
import 'package:lumina_medical_center/injection_container.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                sl<AdminDashboardBloc>()..add(LoadAdminDashboard()),
            child: const AdminMainScreen(),
          );
        },
        routes: [
          GoRoute(
            path: 'doctors',
            builder: (context, state) => const AdminDoctorListPage(),
          ),
          GoRoute(
            path: 'add-doctor',
            builder: (context, state) => const AddDoctorPage(),
          ),
          GoRoute(
            path: 'edit-doctor',
            builder: (context, state) {
              final doctor = state.extra as AdminDoctorModel;
              return EditDoctorPage(doctor: doctor);
            },
          ),
          GoRoute(
            path: 'manage-appointments',
            builder: (context, state) => const ManageAppointmentsPage(),
          ),
          GoRoute(
            path: 'add-branch',
            builder: (context, state) => const AddBranchPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/doctor-dashboard',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => DashboardBloc(sl<AppointmentService>()),
            child: const DoctorDashboardPage(),
          );
        },
      ),
      GoRoute(
        path: '/doctor-appointment-detail',
        builder: (context, state) {
          final appointment = state.extra as AppointmentEntity;
          return BlocProvider(
            create: (context) => sl<AppointmentActionBloc>(),
            child: DoctorAppointmentDetailPage(appointment: appointment),
          );
        },
      ),
      GoRoute(
        path: '/doctor-profile',
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                DoctorProfileBloc(getMyProfile: sl(), updateProfile: sl()),
            child: const DoctorProfilePage(),
          );
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainWrapper(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                path: 'doctors',
                builder: (context, state) => const DoctorListPage(),
              ),
              GoRoute(
                path: 'branches',
                builder: (context, state) => const BranchesPage(),
                routes: [
                  GoRoute(
                    path: 'filter/:branchId',
                    name: 'doctors_by_branch',
                    builder: (context, state) {
                      final branchId = state.pathParameters['branchId']!;
                      final branchName =
                          state.extra as String? ?? 'Specialists';

                      return DoctorsPage(
                        branchId: branchId,
                        branchName: branchName,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/appointments',
            builder: (context, state) => const MyAppointmentsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const PatientProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/doctor-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final doctor = state.extra as DoctorModel;
          return DoctorDetailPage(doctor: doctor);
        },
      ),
    ],
  );
}
