import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import '../admin_form_section.dart';
import '../admin_text_field.dart';

class CommonPersonalForm extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController? passwordCtrl;
  final TextEditingController nationalIdCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController imgCtrl;
  final TextEditingController bioCtrl;
  final String selectedGender;
  final Function(String) onGenderChanged;
  final Function(String) onNameChanged;
  final Function(String)? onPasswordChanged;
  final Function(String) onNationalIdChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneChanged;
  final Function(String) onImgChanged;
  final Function(String) onBioChanged;

  const CommonPersonalForm({
    super.key,
    required this.nameCtrl,
    this.passwordCtrl,
    required this.nationalIdCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.imgCtrl,
    required this.bioCtrl,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onNameChanged,
    this.onPasswordChanged,
    required this.onNationalIdChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onImgChanged,
    required this.onBioChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminFormSection(
      title: context.loc.personalInformation,
      children: [
        AdminTextField(
          label: context.loc.fullNameLabel,
          controller: nameCtrl,
          onChanged: onNameChanged,
        ),

        if (passwordCtrl != null) ...[
          AdminTextField(
            label: context.loc.temporaryPassword,
            controller: passwordCtrl!,
            onChanged: onPasswordChanged,
          ),
        ],

        Row(
          children: [
            Expanded(
              child: AdminTextField(
                label: context.loc.nationalID,
                controller: nationalIdCtrl,
                isNumber: true,
                maxLength: 11,
                onChanged: onNationalIdChanged,
              ),
            ),
            context.hSpaceM,
            Expanded(child: _buildGenderDropdown(context)),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: AdminTextField(
                label: context.loc.email,
                controller: emailCtrl,
                onChanged: onEmailChanged,
              ),
            ),
            context.hSpaceM,
            Expanded(
              child: AdminTextField(
                label: context.loc.phoneNumber,
                controller: phoneCtrl,
                isNumber: true,
                onChanged: onPhoneChanged,
              ),
            ),
          ],
        ),
        AdminTextField(
          label: context.loc.imageUrlLabel,
          controller: imgCtrl,
          onChanged: onImgChanged,
        ),
        AdminTextField(
          label: context.loc.biographyLabel,
          controller: bioCtrl,
          maxLines: 3,
          onChanged: onBioChanged,
        ),
      ],
    );
  }

  Widget _buildGenderDropdown(BuildContext context) {
    const List<String> genderValues = ["Male", "Female"];

    final val = genderValues.contains(selectedGender) ? selectedGender : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.genderLabel,
          style: context.textTheme.labelMedium?.copyWith(
            color: AppColors.slateGray,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 6.h),
        DropdownButtonFormField<String>(
          value: val,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.slateGray.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: context.radius.medium.radius,
              borderSide: BorderSide.none,
            ),
            contentPadding: context.paddingAllM,
          ),
          hint: Text(
            context.loc.select,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.slateGray.withValues(alpha: 0.5),
            ),
          ),
          items: genderValues.map((g) {
            return DropdownMenuItem(
              value: g,
              child: Text(
                g == "Male" ? context.loc.genderMale : context.loc.genderFemale,
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onGenderChanged(val);
          },
        ),
        context.vSpaceM,
      ],
    );
  }
}
