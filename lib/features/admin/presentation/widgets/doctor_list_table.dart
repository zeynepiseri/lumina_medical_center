import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/app_image.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';

class DoctorListTable extends StatelessWidget {
  final List<AdminDoctorEntity> doctors;
  final VoidCallback onRefresh;

  const DoctorListTable({
    super.key,
    required this.doctors,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: context.radius.large.radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightBlue.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: context.radius.large.radius,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: context.width - 64),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppColors.slateGray.withValues(alpha: 0.05),
              ),
              dataRowMinHeight: 60.h,
              dataRowMaxHeight: 70.h,
              horizontalMargin: 24.w,
              columnSpacing: 24.w,
              columns: [
                DataColumn(
                  label: Text(
                    context.loc.fullNameLabel,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.midnightBlue,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    context.loc.specialtyLabel,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.midnightBlue,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    context.loc.rating,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.midnightBlue,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    context.loc.actions,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.midnightBlue,
                    ),
                  ),
                ),
              ],
              rows: doctors.map((doctor) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: doctor.imageUrl.isNotEmpty
                                ? AppImage(
                                    url: doctor.imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : CircleAvatar(
                                    backgroundColor: AppColors.midnightBlue
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      doctor.fullName.isNotEmpty
                                          ? doctor.fullName[0]
                                          : '?',
                                      style: const TextStyle(
                                        color: AppColors.midnightBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                          context.hSpaceS,
                          Flexible(
                            child: Text(
                              doctor.fullName,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(doctor.specialty)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.oldGold,
                            size: 18.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            doctor.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " (${doctor.reviewCount})",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.slateGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.secondary,
                            ),
                            tooltip: context.loc.edit,
                            onPressed: () async {
                              await context.push(
                                '/admin-dashboard/edit-doctor',
                                extra: doctor,
                              );
                              onRefresh();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
