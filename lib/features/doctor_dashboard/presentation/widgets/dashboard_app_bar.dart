import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/auth_cubit.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100.0,
      floating: true,
      pinned: true,
      backgroundColor: context.colors.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: context.paddingHorizontalM.copyWith(bottom: 16),
        title: Text(
          context.loc.doctorDashboard,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colors.surface,
            fontSize: 18,
          ),
        ),
        background: Container(color: context.colors.primary),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.manage_accounts, color: context.colors.surface),
          onPressed: () => context.push('/doctor-profile'),
          tooltip: context.loc.editProfileTooltip,
        ),
        IconButton(
          icon: Icon(Icons.logout, color: context.colors.surface),
          onPressed: () {
            context.read<AuthCubit>().logout();

            context.go('/login');
          },
          tooltip: context.loc.menuLogout,
        ),
      ],
    );
  }
}
