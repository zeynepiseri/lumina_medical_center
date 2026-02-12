import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/app_image.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/top_doctor_entity.dart';

class TopDoctorsTable extends StatelessWidget {
  final List<TopDoctorEntity> doctors;

  const TopDoctorsTable({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: context.radius.large.radius,
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(
              alpha: context.opacity.faint,
            ),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: context.paddingAllM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.topDoctorsTitle,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.midnightBlue,
            ),
          ),
          context.vSpaceM,
          SizedBox(
            height: 300.h,
            child: DataTable2(
              columnSpacing: 12.w,
              horizontalMargin: 12.w,
              minWidth: 500.w,
              columns: [
                DataColumn2(
                  label: Text(context.loc.doctorColumn),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(context.loc.specialtyLabel),
                  size: ColumnSize.M,
                ),
                DataColumn2(label: Text(context.loc.rating), fixedWidth: 80.w),
                DataColumn2(
                  label: Text(context.loc.earnings),
                  size: ColumnSize.S,
                  numeric: true,
                ),
              ],
              rows: doctors.map((doc) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: doc.imageUrl != null
                                ? AppImage(
                                    url: doc.imageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 16,
                                    color: AppColors.slateGray,
                                  ),
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              doc.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(doc.specialty)),
                    DataCell(
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16.w,
                            color: AppColors.ratingStar,
                          ),
                          SizedBox(width: 4.w),
                          Text(doc.rating.toString()),
                        ],
                      ),
                    ),
                    DataCell(Text("\$${doc.earnings}")),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
