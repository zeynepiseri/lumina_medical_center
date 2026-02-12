import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import '../admin_form_section.dart';
import '../admin_text_field.dart';

class CommonProfessionalForm extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController specialtyCtrl;
  final TextEditingController diplomaCtrl;
  final TextEditingController expCtrl;
  final TextEditingController patientCtrl;
  final List<DropdownMenuItem<String>> branchItems;
  final String? selectedBranchId;
  final bool isLoadingBranches;
  final Function(String?) onBranchChanged;
  final Function(String) onTitleChanged;
  final Function(String) onSpecialtyChanged;
  final Function(String) onDiplomaChanged;
  final Function(String) onExpChanged;
  final Function(String) onPatientChanged;

  const CommonProfessionalForm({
    super.key,
    required this.titleCtrl,
    required this.specialtyCtrl,
    required this.diplomaCtrl,
    required this.expCtrl,
    required this.patientCtrl,
    required this.branchItems,
    this.selectedBranchId,
    this.isLoadingBranches = false,
    required this.onBranchChanged,
    required this.onTitleChanged,
    required this.onSpecialtyChanged,
    required this.onDiplomaChanged,
    required this.onExpChanged,
    required this.onPatientChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;

    return AdminFormSection(
      title: l10n.professionalInformation,
      children: [
        Row(
          children: [
            Expanded(
              child: AdminTextField(
                label: l10n.titleLabel,
                hint: l10n.titleHint,
                controller: titleCtrl,
                onChanged: onTitleChanged,
              ),
            ),
            context.hSpaceM,
            Expanded(
              child: AdminTextField(
                label: l10n.specialtyLabel,
                hint: l10n.specialtyHint,
                controller: specialtyCtrl,
                onChanged: onSpecialtyChanged,
              ),
            ),
          ],
        ),

        AdminTextField(
          label: l10n.diplomaNo,
          controller: diplomaCtrl,
          onChanged: onDiplomaChanged,
        ),

        if (isLoadingBranches)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: const LinearProgressIndicator(),
          )
        else
          _buildBranchDropdown(context, l10n),

        Row(
          children: [
            Expanded(
              child: AdminTextField(
                label: l10n.experienceYears,
                isNumber: true,
                controller: expCtrl,
                onChanged: onExpChanged,
              ),
            ),
            context.hSpaceM,
            Expanded(
              child: AdminTextField(
                label: l10n.totalPatients,
                controller: patientCtrl,
                onChanged: onPatientChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBranchDropdown(BuildContext context, dynamic l10n) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.branchLabel,
            style: context.textTheme.labelMedium?.copyWith(
              color: AppColors.slateGray,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 6.h),
          DropdownButtonFormField<String>(
            value: selectedBranchId,
            hint: Text(
              l10n.selectBranch,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.slateGray.withValues(alpha: 0.5),
              ),
            ),
            style: context.textTheme.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: context.radius.medium.radius,
                borderSide: BorderSide.none,
              ),
              contentPadding: context.paddingAllM,
            ),
            items: branchItems,
            onChanged: onBranchChanged,
          ),
        ],
      ),
    );
  }
}
