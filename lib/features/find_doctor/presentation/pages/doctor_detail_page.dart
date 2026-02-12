import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/core/widgets/fade_in_up.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_doctor_detail_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/bloc/doctor_detail_cubit.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/widgets/detail/doctor_detail_header.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/widgets/common/doctor_stats_card.dart';
import 'package:lumina_medical_center/injection_container.dart';

import '../widgets/detail/doctor_action_buttons.dart';
import '../widgets/detail/doctor_about_section.dart';
import '../widgets/detail/doctor_specialty_section.dart';
import '../widgets/detail/doctor_timeline_section.dart';

class DoctorDetailPage extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorDetailCubit(sl<GetDoctorDetailUseCase>()),
      child: _DoctorDetailView(doctor: doctor),
    );
  }
}

class _DoctorDetailView extends StatefulWidget {
  final DoctorEntity doctor;
  const _DoctorDetailView({required this.doctor});

  @override
  State<_DoctorDetailView> createState() => _DoctorDetailViewState();
}

class _DoctorDetailViewState extends State<_DoctorDetailView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double headerHeight = context.height * 0.40;
    final double statusBarHeight = MediaQuery.paddingOf(context).top;

    final double overlapAmount = context.spacing.xxl;

    return BaseScreen(
      topBarColor: context.colors.secondary,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                DoctorDetailHeader(
                  doctor: widget.doctor,
                  headerHeight: headerHeight,
                  statusBarHeight: statusBarHeight,
                ),
                Positioned(
                  top: headerHeight - overlapAmount,
                  left: context.spacing.l,
                  right: context.spacing.l,
                  child: FadeInUp(
                    delay: 200,
                    controller: _controller,
                    child: DoctorStatsCard(doctor: widget.doctor),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacing.xxxl + context.spacing.m),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    delay: 300,
                    controller: _controller,
                    child: DoctorActionButtons(doctor: widget.doctor),
                  ),
                  context.vSpaceXL,

                  FadeInUp(
                    delay: 400,
                    controller: _controller,
                    child: DoctorAboutSection(
                      biography: widget.doctor.biography,
                    ),
                  ),
                  context.vSpaceL,

                  if (widget.doctor.subSpecialties.isNotEmpty) ...[
                    FadeInUp(
                      delay: 500,
                      controller: _controller,
                      child: DoctorSpecialtySection(
                        mainSpecialty: widget.doctor.specialty,
                        subSpecialties: widget.doctor.subSpecialties,
                      ),
                    ),
                    context.vSpaceL,
                  ],

                  if (widget.doctor.professionalExperiences.isNotEmpty) ...[
                    FadeInUp(
                      delay: 600,
                      controller: _controller,
                      child: DoctorTimelineSection(
                        title: context.loc.careerPath,
                        items: widget.doctor.professionalExperiences,
                      ),
                    ),
                    context.vSpaceL,
                  ],

                  if (widget.doctor.educations.isNotEmpty) ...[
                    FadeInUp(
                      delay: 700,
                      controller: _controller,
                      child: DoctorTimelineSection(
                        title: context.loc.educationInformation,
                        items: widget.doctor.educations,
                      ),
                    ),
                  ],

                  SizedBox(height: context.spacing.xxxl * 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
