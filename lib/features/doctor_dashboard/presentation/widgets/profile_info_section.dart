import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';

class ProfileInfoSection extends StatefulWidget {
  final MyProfileEntity profile;
  final TextEditingController bioController;
  final TextEditingController expController;
  final Function(List<String>) onEducationsChanged;
  final Function(List<String>) onSubSpecialtiesChanged;

  const ProfileInfoSection({
    super.key,
    required this.profile,
    required this.bioController,
    required this.expController,
    required this.onEducationsChanged,
    required this.onSubSpecialtiesChanged,
  });

  @override
  State<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<ProfileInfoSection> {
  late List<String> _localEducations;
  late List<String> _localSubSpecialties;

  final TextEditingController _eduInputController = TextEditingController();
  final TextEditingController _subInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _localEducations = List.from(widget.profile.educations);
    _localSubSpecialties = List.from(widget.profile.subSpecialties);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context.loc.institutionalInfo,
          Icons.verified_user,
          context.colors.primary,
        ),
        context.vSpaceS,
        _buildReadOnlyField(context.loc.fullNameLabel, widget.profile.fullName),
        context.vSpaceS,
        Row(
          children: [
            Expanded(
              child: _buildReadOnlyField(
                context.loc.titleLabel,
                widget.profile.title,
              ),
            ),
            context.hSpaceS,
            Expanded(
              child: _buildReadOnlyField(
                context.loc.branchLabel,
                widget.profile.branchName,
              ),
            ),
          ],
        ),
        context.vSpaceS,
        Row(
          children: [
            Expanded(
              child: _buildReadOnlyField(
                context.loc.diplomaNo,
                widget.profile.diplomaNo,
              ),
            ),
            context.hSpaceS,
            Expanded(
              child: _buildReadOnlyField(
                context.loc.totalPatients,
                widget.profile.patientCount.toString(),
              ),
            ),
          ],
        ),

        context.vSpaceL,
        Divider(color: AppColors.slateGray.withValues(alpha: 0.2)),
        context.vSpaceL,

        _buildSectionHeader(
          context.loc.profileEditing,
          Icons.edit_note,
          AppColors.warning,
        ),
        context.vSpaceM,

        TextFormField(
          controller: widget.bioController,
          maxLines: 4,
          style: context.textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: context.loc.biographyLabel,
            border: OutlineInputBorder(
              borderRadius: context.radius.medium.radius,
            ),
            alignLabelWithHint: true,
          ),
        ),
        context.vSpaceM,
        TextFormField(
          controller: widget.expController,
          keyboardType: TextInputType.number,
          style: context.textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: context.loc.experienceYears,
            border: OutlineInputBorder(
              borderRadius: context.radius.medium.radius,
            ),
          ),
        ),

        context.vSpaceL,
        Divider(color: AppColors.slateGray.withValues(alpha: 0.2)),
        context.vSpaceL,

        _buildSectionHeader(
          context.loc.detailedInfo,
          Icons.school,
          AppColors.slateGray,
        ),
        context.vSpaceM,

        _buildEditableChipList(
          title: context.loc.educationHistory,
          hint: context.loc.addEducationHint,
          items: _localEducations,
          controller: _eduInputController,
          onChanged: (newList) {
            setState(() => _localEducations = newList);
            widget.onEducationsChanged(newList);
          },
        ),

        context.vSpaceL,
        _buildEditableChipList(
          title: context.loc.subSpecialties,
          hint: context.loc.addSubSpecialtyHint,
          items: _localSubSpecialties,
          controller: _subInputController,
          onChanged: (newList) {
            setState(() => _localSubSpecialties = newList);
            widget.onSubSpecialtiesChanged(newList);
          },
        ),
      ],
    );
  }

  Widget _buildEditableChipList({
    required String title,
    required String hint,
    required List<String> items,
    required TextEditingController controller,
    required Function(List<String>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.vSpaceS,
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 45.h,
                child: TextField(
                  controller: controller,
                  style: context.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: hint,
                    contentPadding: context.paddingHorizontalM,
                    border: OutlineInputBorder(
                      borderRadius: context.radius.medium.radius,
                    ),
                  ),
                  onSubmitted: (_) {
                    if (controller.text.isNotEmpty) {
                      final updatedList = List<String>.from(items)
                        ..add(controller.text);
                      onChanged(updatedList);
                      controller.clear();
                    }
                  },
                ),
              ),
            ),
            context.hSpaceS,
            IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final updatedList = List<String>.from(items)
                    ..add(controller.text);
                  onChanged(updatedList);
                  controller.clear();
                }
              },
              icon: Icon(
                Icons.add_circle,
                color: context.colors.primary,
                size: 32.sp,
              ),
            ),
          ],
        ),
        context.vSpaceS,
        Wrap(
          spacing: 8.w,
          runSpacing: 4.h,
          children: items.map((item) {
            return Chip(
              label: Text(item, style: context.textTheme.bodySmall),
              backgroundColor: AppColors.slateGray.withValues(alpha: 0.1),
              deleteIcon: Icon(Icons.close, size: 18.sp),
              onDeleted: () {
                final updatedList = List<String>.from(items)..remove(item);
                onChanged(updatedList);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: color),
        context.hSpaceS,
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.slateGray.withValues(alpha: 0.05),
        borderRadius: context.radius.medium.radius,
        border: Border.all(color: AppColors.slateGray.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.slateGray,
              fontWeight: FontWeight.bold,
            ),
          ),
          context.vSpaceXS,
          Text(
            value.isEmpty ? "-" : value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
