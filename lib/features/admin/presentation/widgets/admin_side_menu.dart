import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class AdminSideMenu extends StatelessWidget {
  const AdminSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.midnightBlue,
      child: ListView(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.health_and_safety,
                color: AppColors.oldGold,
                size: 32,
              ),
              const SizedBox(width: 10),
              Text(
                context.loc.luminaAdmin,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _DrawerListTile(
            title: context.loc.menuDashboard,
            icon: Icons.dashboard,
            press: () => context.go('/admin-dashboard'),
            isActive: true,
          ),

          _DrawerListTile(
            title: context.loc.menuDoctors,
            icon: Icons.people,
            press: () => context.push('/admin-dashboard/doctors'),
          ),

          _DrawerListTile(
            title: context.loc.menuAppointments,
            icon: Icons.calendar_today,
            press: () => context.push('/admin-dashboard/manage-appointments'),
          ),

          _DrawerListTile(
            title: context.loc.menuAddBranch,
            icon: Icons.domain_add,
            press: () => context.push('/admin-dashboard/add-branch'),
          ),

          const Divider(color: AppColors.alto),

          _DrawerListTile(
            title: context.loc.menuSettings,
            icon: Icons.settings,
            press: () {},
          ),

          _DrawerListTile(
            title: context.loc.menuLogout,
            icon: Icons.logout,
            press: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback press;
  final bool isActive;

  const _DrawerListTile({
    required this.title,
    required this.icon,
    required this.press,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 10.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      leading: Icon(
        icon,
        color: isActive ? AppColors.oldGold : AppColors.white,
        size: 18,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? AppColors.oldGold : AppColors.white,
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
