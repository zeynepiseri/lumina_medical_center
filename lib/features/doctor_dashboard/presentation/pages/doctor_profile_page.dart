import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_event.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_state.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/widgets/profile_info_section.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/widgets/schedule_manager_section.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _bioController;
  late final TextEditingController _expController;

  List<WorkSchedule> _schedules = [];
  List<String> _subSpecialties = [];
  List<String> _educations = [];

  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController();
    _expController = TextEditingController();

    context.read<DoctorProfileBloc>().add(LoadProfileEvent());
  }

  @override
  void dispose() {
    _bioController.dispose();
    _expController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, ProfileState state) {
    if (state is ProfileUpdateSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.profileUpdateSuccess),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (state is ProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: context.colors.error,
        ),
      );
    } else if (state is ProfileLoaded && !_isDataLoaded) {
      final profile = state.profile;
      _bioController.text = profile.biography;
      _expController.text = profile.experience.toString();

      _schedules = List.from(profile.schedules);
      _subSpecialties = List.from(profile.subSpecialties);
      _educations = List.from(profile.educations);

      setState(() => _isDataLoaded = true);
    }
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      context.read<DoctorProfileBloc>().add(
        UpdateProfileEvent(
          biography: _bioController.text,
          experience: int.tryParse(_expController.text) ?? 0,
          schedules: _schedules,
          subSpecialties: _subSpecialties,
          educations: _educations,
        ),
      );
    }
  }

  void _onAddSchedule(WorkSchedule newSchedule) {
    setState(() => _schedules.add(newSchedule));
  }

  void _onRemoveSchedule(int index) {
    setState(() => _schedules.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.profileAndHours),
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.surface,
        titleTextStyle: context.textTheme.titleLarge?.copyWith(
          color: context.colors.surface,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: BlocConsumer<DoctorProfileBloc, ProfileState>(
        listener: _onStateChanged,
        builder: (context, state) {
          if (state is ProfileLoading && !_isDataLoaded) {
            return Center(
              child: CircularProgressIndicator(color: context.colors.secondary),
            );
          }

          if (state is ProfileLoaded ||
              state is ProfileUpdating ||
              state is ProfileUpdateSuccess ||
              _isDataLoaded) {
            MyProfileEntity? profile;
            if (state is ProfileLoaded) {
              profile = state.profile;
            } else if (state is ProfileUpdating ||
                state is ProfileUpdateSuccess ||
                state is ProfileError) {}

            final displayProfile = (state is ProfileLoaded)
                ? state.profile
                : null;

            if (displayProfile == null && !_isDataLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: context.pagePadding,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: context.spacing.l),
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.lock_reset,
                          color: context.colors.error,
                        ),
                        label: Text(
                          context.loc.changePassword,
                          style: context.textTheme.labelLarge?.copyWith(
                            color: context.colors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: context.paddingVerticalM,
                          side: BorderSide(color: context.colors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              context.radius.medium,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (displayProfile != null)
                      ProfileInfoSection(
                        profile: displayProfile,
                        bioController: _bioController,
                        expController: _expController,
                        onEducationsChanged: (list) => _educations = list,
                        onSubSpecialtiesChanged: (list) =>
                            _subSpecialties = list,
                      ),

                    context.vSpaceXL,
                    const Divider(),
                    context.vSpaceM,

                    ScheduleManagerSection(
                      schedules: _schedules,
                      onAddSchedule: _onAddSchedule,
                      onRemoveSchedule: _onRemoveSchedule,
                    ),

                    context.vSpaceXXL,

                    SizedBox(
                      width: double.infinity,
                      height: context.layout.buttonHeight,
                      child: ElevatedButton(
                        onPressed: state is ProfileUpdating
                            ? null
                            : _onSavePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.secondary,
                          foregroundColor: context.colors.surface,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              context.radius.large,
                            ),
                          ),
                        ),
                        child: state is ProfileUpdating
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: context.colors.surface,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                context.loc.saveChanges,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: context.colors.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    context.vSpaceL,
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.loc.profileLoadFailed),
                TextButton(
                  onPressed: () =>
                      context.read<DoctorProfileBloc>().add(LoadProfileEvent()),
                  child: Text(context.loc.tryAgain),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
