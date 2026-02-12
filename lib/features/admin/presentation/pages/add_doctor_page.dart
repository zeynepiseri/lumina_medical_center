import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_add_doctor/admin_add_doctor_cubit.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_add_doctor/admin_add_doctor_state.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/forms/shared/common_personal_form.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/forms/shared/common_professional_form.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/forms/shared/common_detail_lists_form.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/forms/shared/common_schedule_manager.dart';
import 'package:lumina_medical_center/injection_container.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/errors/failure_extension.dart';

class AddDoctorPage extends StatelessWidget {
  const AddDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddDoctorCubit>(),
      child: const _AddDoctorView(),
    );
  }
}

class _AddDoctorView extends StatefulWidget {
  const _AddDoctorView();

  @override
  State<_AddDoctorView> createState() => _AddDoctorViewState();
}

class _AddDoctorViewState extends State<_AddDoctorView> {
  final _nameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _specialtyCtrl = TextEditingController();
  final _diplomaCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _patientCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _passCtrl.dispose();
    _nationalIdCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _imgCtrl.dispose();
    _bioCtrl.dispose();
    _titleCtrl.dispose();
    _specialtyCtrl.dispose();
    _diplomaCtrl.dispose();
    _expCtrl.dispose();
    _patientCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddDoctorCubit>();

    return BlocConsumer<AddDoctorCubit, AddDoctorState>(
      listener: (context, state) {
        if (state.status == AddDoctorStatus.success) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: Text(context.loc.doctorAddedSuccess),
            autoCloseDuration: const Duration(seconds: 3),
          );
          Navigator.pop(context);
        } else if (state.status == AddDoctorStatus.failure) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            title: Text(context.loc.error),

            description: Text(
              state.failure?.toUserMessage(context) ??
                  context.loc.theUpdateFailed,
            ),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }

        if (_specialtyCtrl.text != state.specialty) {
          _specialtyCtrl.text = state.specialty;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              context.loc.addDoctorTitle,
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.midnightBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.midnightBlue),
          ),
          body: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 800.w),
              child: SingleChildScrollView(
                padding: context.pagePadding,
                child: Column(
                  children: [
                    BlocBuilder<AddDoctorCubit, AddDoctorState>(
                      buildWhen: (p, c) => p.gender != c.gender,
                      builder: (context, state) {
                        return CommonPersonalForm(
                          nameCtrl: _nameCtrl,
                          passwordCtrl: _passCtrl,
                          nationalIdCtrl: _nationalIdCtrl,
                          emailCtrl: _emailCtrl,
                          phoneCtrl: _phoneCtrl,
                          imgCtrl: _imgCtrl,
                          bioCtrl: _bioCtrl,
                          selectedGender: state.gender,
                          onGenderChanged: cubit.genderChanged,
                          onNameChanged: cubit.fullNameChanged,
                          onPasswordChanged: cubit.passwordChanged,
                          onNationalIdChanged: cubit.nationalIdChanged,
                          onEmailChanged: cubit.emailChanged,
                          onPhoneChanged: cubit.phoneNumberChanged,
                          onImgChanged: cubit.imageUrlChanged,
                          onBioChanged: cubit.biographyChanged,
                        );
                      },
                    ),

                    context.vSpaceM,

                    BlocBuilder<AddDoctorCubit, AddDoctorState>(
                      builder: (context, state) {
                        return CommonProfessionalForm(
                          titleCtrl: _titleCtrl,
                          specialtyCtrl: _specialtyCtrl,
                          diplomaCtrl: _diplomaCtrl,
                          expCtrl: _expCtrl,
                          patientCtrl: _patientCtrl,
                          isLoadingBranches: state.isLoadingBranches,
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
                          onDiplomaChanged: cubit.diplomaNoChanged,
                          onExpChanged: cubit.experienceChanged,
                          onPatientChanged: cubit.patientsChanged,
                        );
                      },
                    ),

                    context.vSpaceM,

                    BlocBuilder<AddDoctorCubit, AddDoctorState>(
                      buildWhen: (p, c) => p.schedules != c.schedules,
                      builder: (context, state) {
                        return CommonScheduleManager(
                          schedules: state.schedules,
                          onAddSchedule: cubit.addSchedule,
                          onRemoveSchedule: cubit.removeSchedule,
                        );
                      },
                    ),
                    context.vSpaceM,

                    BlocBuilder<AddDoctorCubit, AddDoctorState>(
                      builder: (context, state) {
                        return CommonDetailListsForm(
                          insurances: state.acceptedInsurances,
                          subSpecialties: state.subSpecialties,
                          experiences: state.professionalExperiences,
                          educations: state.educations,
                          onInsurancesChanged: cubit.insurancesChanged,
                          onSubSpecialtiesChanged: cubit.subSpecialtiesChanged,
                          onExperiencesChanged:
                              cubit.professionalExperiencesChanged,
                          onEducationsChanged: cubit.educationsChanged,
                        );
                      },
                    ),
                    context.vSpaceL,

                    SizedBox(
                      width: double.infinity,
                      height: context.layout.buttonHeight.h,
                      child: ElevatedButton(
                        onPressed: state.status == AddDoctorStatus.loading
                            ? null
                            : cubit.submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.midnightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: context.radius.medium.radius,
                          ),
                        ),
                        child: state.status == AddDoctorStatus.loading
                            ? SizedBox(
                                height: 24.h,
                                width: 24.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                context.loc.saveDoctorButton,
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
