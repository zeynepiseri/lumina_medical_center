import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/presentation/bloc/branch_bloc.dart';
import 'package:lumina_medical_center/features/branches/presentation/bloc/branch_event.dart';
import 'package:lumina_medical_center/features/branches/presentation/bloc/branch_state.dart';
import 'package:lumina_medical_center/features/branches/presentation/extensions/branch_ui_extension.dart';
import 'package:lumina_medical_center/injection_container.dart';

class BranchesPage extends StatelessWidget {
  const BranchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BranchBloc>()..add(LoadBranchesEvent()),
      child: BaseScreen(
        topBarColor: AppColors.primary,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.spacing.l,
                context.spacing.l,
                context.spacing.l,
                context.spacing.s,
              ),
              child: Text(
                "All Departments",
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.midnightBlue,
                ),
              ),
            ),

            Expanded(
              child: BlocBuilder<BranchBloc, BranchState>(
                builder: (context, state) {
                  if (state is BranchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BranchLoaded) {
                    return GridView.builder(
                      padding: context.paddingAllM,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: context.spacing.m,
                        mainAxisSpacing: context.spacing.m,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: state.branches.length,
                      itemBuilder: (context, index) {
                        final branch = state.branches[index];
                        return _BranchCard(branch: branch);
                      },
                    );
                  } else if (state is BranchError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.error,
                            size: context.layout.iconLarge * 1.5,
                          ),
                          context.vSpaceS,
                          Text(
                            state.message,
                            style: context.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final BranchEntity branch;

  const _BranchCard({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: context.radius.large.radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightBlue.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: context.radius.large.radius,
          onTap: () {
            context.goNamed(
              'doctors_by_branch',
              pathParameters: {'branchId': branch.id},
              extra: branch.name,
            );
          },
          child: Padding(
            padding: context.paddingAllM,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  padding: context.paddingAllM,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: context.opacity.faint,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(branch.iconPath, fit: BoxFit.contain),
                ),
                context.vSpaceM,

                Text(
                  branch.name,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
