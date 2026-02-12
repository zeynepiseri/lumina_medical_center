import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

import 'package:lumina_medical_center/features/admin/data/models/admin_doctor_model.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_edit_doctor/admin_edit_doctor_cubit.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_edit_doctor/admin_edit_doctor_state.dart';

import 'package:lumina_medical_center/features/admin/presentation/widgets/forms/shared/common_personal_form.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/forms/shared/common_professional_form.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/forms/shared/common_detail_lists_form.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/forms/shared/common_schedule_manager.dart';

import 'package:lumina_medical_center/injection_container.dart';
import 'package:toastification/toastification.dart';

class EditDoctorPage extends StatelessWidget {
  final AdminDoctorEntity doctor;

  const EditDoctorPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<EditDoctorCubit>()
            ..loadInitialData(doctor.id.toString(), initialDoctor: doctor),
      child: _EditDoctorView(doctor: doctor),
    );
  }
}

class _EditDoctorView extends StatefulWidget {
  final AdminDoctorEntity doctor;

  const _EditDoctorView({required this.doctor});

  @override
  State<_EditDoctorView> createState() => _EditDoctorViewState();
}

class _EditDoctorViewState extends State<_EditDoctorView> {
  final _nameCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _specialtyCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _patientCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _diplomaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final d = widget.doctor;
    _nameCtrl.text = d.fullName;
    _titleCtrl.text = d.title;
    _specialtyCtrl.text = d.specialty;
    _imgCtrl.text = d.imageUrl;
    _bioCtrl.text = d.biography;
    _expCtrl.text = d.experience.toString();
    _patientCtrl.text = d.patientCount.toString();
    _emailCtrl.text = d.email;
    _nationalIdCtrl.text = d.nationalId;
    _phoneCtrl.text = d.phoneNumber;
    _diplomaCtrl.text = d.diplomaNo;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _specialtyCtrl.dispose();
    _imgCtrl.dispose();
    _bioCtrl.dispose();
    _expCtrl.dispose();
    _patientCtrl.dispose();
    _emailCtrl.dispose();
    _nationalIdCtrl.dispose();
    _phoneCtrl.dispose();
    _diplomaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.width > 900;

    return BlocConsumer<EditDoctorCubit, EditDoctorState>(
      listenWhen: (previous, current) {
        return previous.status != current.status ||
            previous.isLoadingData != current.isLoadingData ||
            previous.specialty != current.specialty;
      },
      listener: (context, state) {
        if (state.status == EditDoctorStatus.success) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: Text(context.loc.doctorUpdateSuccess),
            autoCloseDuration: const Duration(seconds: 3),
          );
          Navigator.pop(context, true);
        } else if (state.status == EditDoctorStatus.failure) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            title: Text(context.loc.error),
            description: Text(
              state.errorMessage ?? context.loc.theUpdateFailed,
            ),
          );
        }

        if (!state.isLoadingData) {
          if (state.specialty.isNotEmpty &&
              _specialtyCtrl.text != state.specialty) {
            _specialtyCtrl.text = state.specialty;
          }
        }
      },
      builder: (context, state) {
        if (state.isLoadingData) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F9FD),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final cubit = context.read<EditDoctorCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FD),
          appBar: AppBar(
            title: Text(
              context.loc.editDoctorTitle,
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.midnightBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.midnightBlue),
          ),
          body: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1000.w),
              padding: context.pagePadding,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Wrap(
                      spacing: 24.w,
                      runSpacing: 24.h,
                      children: [
                        SizedBox(
                          width: isDesktop ? 460.w : double.infinity,
                          child: Column(
                            children: [
                              CommonPersonalForm(
                                nameCtrl: _nameCtrl,
                                passwordCtrl: null,
                                nationalIdCtrl: _nationalIdCtrl,
                                emailCtrl: _emailCtrl,
                                phoneCtrl: _phoneCtrl,
                                imgCtrl: _imgCtrl,
                                bioCtrl: _bioCtrl,
                                selectedGender: state.gender,
                                onGenderChanged: cubit.genderChanged,
                                onNameChanged: cubit.fullNameChanged,
                                onNationalIdChanged: cubit.nationalIdChanged,
                                onEmailChanged: cubit.emailChanged,
                                onPhoneChanged: cubit.phoneChanged,
                                onImgChanged: cubit.imageUrlChanged,
                                onBioChanged: cubit.biographyChanged,
                              ),
                              context.vSpaceM,
                              CommonProfessionalForm(
                                titleCtrl: _titleCtrl,
                                specialtyCtrl: _specialtyCtrl,
                                diplomaCtrl: _diplomaCtrl,
                                expCtrl: _expCtrl,
                                patientCtrl: _patientCtrl,
                                isLoadingBranches: false,
                                selectedBranchId: state.selectedBranchId,
                                branchItems: state.branches
                                    .map(
                                      (b) => DropdownMenuItem(
                                        value: b.id.toString(),
                                        child: Text(b.name),
                                      ),
                                    )
                                    .toList(),
                                onBranchChanged: cubit.branchChanged,
                                onTitleChanged: cubit.titleChanged,
                                onSpecialtyChanged: cubit.specialtyChanged,
                                onDiplomaChanged: cubit.diplomaChanged,
                                onExpChanged: cubit.experienceChanged,
                                onPatientChanged: cubit.patientsChanged,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: isDesktop ? 460.w : double.infinity,
                          child: Column(
                            children: [
                              CommonDetailListsForm(
                                insurances: state.acceptedInsurances,
                                subSpecialties: state.subSpecialties,
                                experiences: state.professionalExperiences,
                                educations: state.educations,
                                onInsurancesChanged: cubit.updateInsurances,
                                onSubSpecialtiesChanged:
                                    cubit.updateSubSpecialties,
                                onExperiencesChanged: cubit.updateExperiences,
                                onEducationsChanged: cubit.updateEducations,
                              ),
                              context.vSpaceM,
                              CommonScheduleManager(
                                schedules: state.schedules,
                                onAddSchedule: cubit.addSchedule,
                                onRemoveSchedule: cubit.removeSchedule,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    context.vSpaceXL,

                    SizedBox(
                      width: double.infinity,
                      height: context.layout.buttonHeight.h,
                      child: ElevatedButton(
                        onPressed: state.status == EditDoctorStatus.loading
                            ? null
                            : cubit.submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.midnightBlue,
                          foregroundColor: Colors.white,
                          elevation: 10,
                          shadowColor: AppColors.midnightBlue.withValues(
                            alpha: 0.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: context.radius.medium.radius,
                          ),
                        ),
                        child: state.status == EditDoctorStatus.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                context.loc.updateDoctorButton,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                    context.vSpaceXXL,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
