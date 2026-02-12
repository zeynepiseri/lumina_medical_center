import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/app_image.dart';

import '../../../domain/entities/doctor_entity.dart';
import '../../bloc/doctor_detail_cubit.dart';

class DoctorDetailHeader extends StatelessWidget {
  final DoctorEntity doctor;
  final double headerHeight;
  final double statusBarHeight;
  final bool showFavorite;

  const DoctorDetailHeader({
    super.key,
    required this.doctor,
    required this.headerHeight,
    required this.statusBarHeight,
    this.showFavorite = true,
  });

  @override
  Widget build(BuildContext context) {
    final bottomCurveRadius = Radius.circular(context.radius.xxl);

    final double circleRadiusBig = context.spacing.xxl * 2;
    final double circleRadiusSmall = context.spacing.xxl;
    final double circleOffset = context.spacing.xxl;

    final double profileImageSize = context.spacing.xxxl + context.spacing.xl;

    return Container(
      height: headerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.primary,
            context.colors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: bottomCurveRadius,
          bottomRight: bottomCurveRadius,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -circleOffset,
            right: -circleOffset,
            child: CircleAvatar(
              radius: circleRadiusBig,
              backgroundColor: context.colors.surface.withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            bottom: circleOffset,
            left: -context.spacing.xl,
            child: CircleAvatar(
              radius: circleRadiusSmall,
              backgroundColor: context.colors.surface.withValues(alpha: 0.05),
            ),
          ),

          Positioned(
            top: statusBarHeight + context.spacing.xs,
            left: context.spacing.m,
            right: context.spacing.m,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGlassBtn(
                      context,
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => context.pop(),
                    ),

                    if (showFavorite)
                      BlocBuilder<DoctorDetailCubit, DoctorDetailState>(
                        builder: (context, state) {
                          return _buildGlassBtn(
                            context,
                            icon: state.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            onTap: () => context
                                .read<DoctorDetailCubit>()
                                .toggleFavorite(),
                            iconColor: state.isFavorite
                                ? context.colors.secondary
                                : context.colors.surface,
                          );
                        },
                      )
                    else
                      const SizedBox(width: 40),
                  ],
                ),
                context.vSpaceL,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'doctor_${doctor.id}',
                      child: Container(
                        width: profileImageSize,
                        height: profileImageSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            context.radius.xl,
                          ),
                          border: Border.all(
                            color: context.colors.surface,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.onSurface.withValues(
                                alpha: 0.25,
                              ),
                              blurRadius: context.radius.xl,
                              offset: Offset(0, context.spacing.s),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            context.radius.xl - 3,
                          ),
                          child: AppImage(
                            url: doctor.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    context.hSpaceM,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          context.vSpaceXS,
                          Text(
                            doctor.fullName,
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: context.colors.surface,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          context.vSpaceS,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.spacing.s,
                              vertical: context.spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.surface.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(
                                context.radius.medium,
                              ),
                            ),
                            child: Text(
                              "${doctor.title} • ${doctor.specialty}",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.surface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBtn(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final double btnSize = context.layout.buttonHeightSmall + 4;
    final color = iconColor ?? context.colors.surface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: btnSize,
        width: btnSize,
        decoration: BoxDecoration(
          color: context.colors.surface.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(context.radius.large),
          border: Border.all(
            color: context.colors.surface.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(icon, color: color, size: context.layout.iconMedium - 4),
      ),
    );
  }
}
