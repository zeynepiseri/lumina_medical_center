import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/injection_container.dart';

import '../bloc/doctor_bloc.dart';
import '../bloc/doctor_event.dart';
import '../bloc/doctor_state.dart';

import '../widgets/common/doctor_list_card.dart';
import '../widgets/list/doctors_page_header.dart';
import '../widgets/common/doctors_empty_view.dart';

class DoctorsPage extends StatelessWidget {
  final String branchId;
  final String branchName;

  const DoctorsPage({
    super.key,
    required this.branchId,
    required this.branchName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DoctorBloc(sl())..add(LoadDoctors(branchId: branchId)),
      child: BaseScreen(
        topBarColor: context.colors.surface,
        backgroundColor: context.colors.surface,
        body: Column(
          children: [
            DoctorsPageHeader(branchName: branchName),

            Expanded(
              child: BlocBuilder<DoctorBloc, DoctorState>(
                builder: (context, state) {
                  if (state is DoctorLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.colors.secondary,
                      ),
                    );
                  } else if (state is DoctorError) {
                    return Center(
                      child: Text(
                        '${context.loc.error}: ${state.message}',
                        style: TextStyle(color: context.colors.error),
                      ),
                    );
                  } else if (state is DoctorLoaded) {
                    if (state.doctors.isEmpty) {
                      return const DoctorsEmptyView();
                    }

                    return AnimationLimiter(
                      child: ListView.builder(
                        padding: context.pagePadding.copyWith(bottom: 40),
                        itemCount: state.doctors.length,
                        itemBuilder: (context, index) {
                          final DoctorEntity doctor = state.doctors[index];

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: DoctorListCard(
                                  doctor: doctor,
                                  branchId: branchId,
                                ),
                              ),
                            ),
                          );
                        },
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
