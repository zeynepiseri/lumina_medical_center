import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:lumina_medical_center/injection_container.dart';
import '../../../../core/errors/failure_extension.dart';
import '../../../../features/profile/presentation/bloc/upload_bloc/upload_bloc.dart';
import '../../../profile/presentation/widgets/patient_menu_tile.dart';
import '../widgets/patient_header.dart';
import '../widgets/patient_vitals_card.dart';
import '../widgets/patient_info_card.dart';
import '../widgets/edit_vitals_dialog.dart';

class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PatientBloc>(
          create: (_) =>
              sl<PatientBloc>()..add(const LoadCurrentProfileEvent()),
        ),
        BlocProvider<UploadBloc>(create: (_) => sl<UploadBloc>()),
      ],
      child: const _PatientProfileView(),
    );
  }
}

class _PatientProfileView extends StatelessWidget {
  const _PatientProfileView();

  void _handleLogout(BuildContext context) {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      topBarColor: context.colors.surface,
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: context.paddingHorizontalM.copyWith(
                top: context.spacing.s,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.loc.myProfile,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout_rounded,
                      color: context.colors.error,
                    ),
                    onPressed: () => _handleLogout(context),
                    tooltip: context.loc.menuLogout,
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocListener<UploadBloc, UploadState>(
                listener: (context, uploadState) {
                  if (uploadState is UploadSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.loc.updatePhotoSuccess),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    context.read<PatientBloc>().add(
                      const LoadCurrentProfileEvent(),
                    );
                  } else if (uploadState is UploadFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(uploadState.errorMessage),
                        backgroundColor: context.colors.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: BlocBuilder<PatientBloc, PatientState>(
                  builder: (context, state) {
                    if (state is PatientLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: context.colors.secondary,
                        ),
                      );
                    } else if (state is PatientError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${context.loc.error}: ${state.failure.toUserMessage(context)}",
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<PatientBloc>().add(
                                  const LoadCurrentProfileEvent(),
                                );
                              },
                              child: const Text("Try Again"),
                            ),
                          ],
                        ),
                      );
                    } else if (state is PatientLoaded) {
                      final patient = state.patient;
                      return SingleChildScrollView(
                        padding: context.pagePadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: PatientHeader(
                                imageUrl: patient.imageUrl,
                                fullName: patient.fullName,
                              ),
                            ),
                            context.vSpaceL,

                            PatientVitalsCard(
                              patient: patient,
                              onEditTap: () => showDialog(
                                context: context,
                                builder: (_) => EditVitalsDialog(
                                  height: patient.height,
                                  weight: patient.weight,
                                  bloodType: patient.bloodType,
                                  onSave: (h, w, b) {
                                    context.read<PatientBloc>().add(
                                      UpdatePatientVitalsEvent(
                                        height: h,
                                        weight: w,
                                        bloodType: b,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            context.vSpaceL,

                            Text(
                              context.loc.quickActions,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colors.primary,
                              ),
                            ),
                            context.vSpaceS,
                            PatientMenuTile(
                              title: context.loc.myAppointments,
                              icon: Icons.calendar_month_rounded,
                              iconColor: context.colors.secondary,
                              onTap: () => context.go('/appointments'),
                            ),
                            PatientMenuTile(
                              title: context.loc.menuPrescriptions,
                              icon: Icons.medication_rounded,
                              iconColor: Colors.teal,
                              onTap: () {},
                            ),
                            PatientMenuTile(
                              title: context.loc.menuMedicalRecords,
                              icon: Icons.folder_shared_rounded,
                              iconColor: Colors.blueAccent,
                              onTap: () {},
                            ),

                            context.vSpaceL,

                            PatientInfoCard(
                              title: context.loc.allergiesLabel,
                              items: patient.allergies,
                              icon: Icons.warning_amber_rounded,
                              iconColor: AppColors.warning,
                            ),
                            context.vSpaceM,
                            PatientInfoCard(
                              title: context.loc.chronicDiseasesLabel,
                              items: patient.chronicDiseases,
                              icon: Icons.medical_services_outlined,
                              iconColor: context.colors.error,
                            ),

                            context.vSpaceL,

                            Text(
                              context.loc.accountSettings,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colors.primary,
                              ),
                            ),
                            context.vSpaceS,
                            PatientMenuTile(
                              title: context.loc.menuInsurance,
                              icon: Icons.card_membership_rounded,
                              iconColor: Colors.indigo,
                              onTap: () {},
                            ),
                            PatientMenuTile(
                              title: context.loc.menuLogout,
                              icon: Icons.logout_rounded,
                              isDestructive: true,
                              onTap: () => _handleLogout(context),
                            ),

                            const SizedBox(height: 100),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
