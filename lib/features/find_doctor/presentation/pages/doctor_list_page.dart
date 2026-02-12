import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';

import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_doctors_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/injection_container.dart';

import '../bloc/doctor_bloc.dart';
import '../bloc/doctor_event.dart';
import '../bloc/doctor_state.dart';

import '../widgets/common/doctor_list_card.dart';

class DoctorListPage extends StatelessWidget {
  const DoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DoctorBloc(sl<GetDoctorsUseCase>())..add(LoadDoctors()),
      child: BaseScreen(
        topBarColor: context.colors.surface,
        backgroundColor: context.colors.surface,
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: context.paddingHorizontalM.copyWith(
                  top: context.spacing.s,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: context.colors.primary,
                        size: 20,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        context.loc.popularDoctors,
                        textAlign: TextAlign.center,
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            Expanded(
              child: BlocBuilder<DoctorBloc, DoctorState>(
                builder: (context, state) {
                  if (state is DoctorLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.colors.secondary,
                      ),
                    );
                  } else if (state is DoctorLoaded) {
                    if (state.doctors.isEmpty) {
                      return Center(child: Text(context.loc.doctorsListEmpty));
                    }
                    return AnimationLimiter(
                      child: ListView.builder(
                        padding: context.pagePadding.copyWith(bottom: 120),
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
                                  branchId: 'popular_list',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is DoctorError) {
                    return Center(
                      child: Text('${context.loc.error}: ${state.message}'),
                    );
                  }

                  return Center(child: Text(context.loc.doctorsListEmpty));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
