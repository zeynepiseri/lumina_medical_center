import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:lumina_medical_center/features/admin/presentation/pages/dashboard_screen.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_side_menu.dart';
import 'package:lumina_medical_center/injection_container.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_event.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminDashboardBloc>()..add(LoadAdminDashboard()),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: const AdminSideMenu(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (context.width >= 1100) const Expanded(child: AdminSideMenu()),
            Expanded(
              flex: 5,
              child: DashboardScreen(
                onMenuPressed: () {
                  if (!_scaffoldKey.currentState!.isDrawerOpen) {
                    _scaffoldKey.currentState!.openDrawer();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
