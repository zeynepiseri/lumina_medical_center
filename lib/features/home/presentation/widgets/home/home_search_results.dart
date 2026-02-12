import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/find_doctor/data/models/doctor_model.dart';
import 'package:lumina_medical_center/features/home/presentation/bloc/home_cubit.dart';

import 'package:lumina_medical_center/features/home/presentation/widgets/doctor/doctor_list_tile.dart';

import '../../../../find_doctor/domain/entities/doctor_entity.dart';

class HomeSearchResults extends StatelessWidget {
  final String query;
  final List<DoctorEntity> doctors;

  const HomeSearchResults({
    super.key,
    required this.doctors,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.slateGray.withValues(alpha: 0.5),
            ),
            context.vSpaceM,
            Text(
              'No doctors found for "$query"',
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.slateGray,
              ),
            ),
            context.vSpaceM,
            TextButton(
              onPressed: () => context.read<HomeCubit>().clearSearch(),
              child: const Text("Clear Search"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: context.paddingHorizontalM.copyWith(top: context.spacing.s),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: context.spacing.s),

          child: DoctorListTile(doctor: doctors[index]),
        );
      },
    );
  }
}
