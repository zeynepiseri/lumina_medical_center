import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import '../admin_chip_editor.dart';
import '../admin_form_section.dart';

class CommonDetailListsForm extends StatelessWidget {
  final List<String> insurances;
  final List<String> subSpecialties;
  final List<String> experiences;
  final List<String> educations;

  final Function(List<String>) onInsurancesChanged;
  final Function(List<String>) onSubSpecialtiesChanged;
  final Function(List<String>) onExperiencesChanged;
  final Function(List<String>) onEducationsChanged;

  const CommonDetailListsForm({
    super.key,
    required this.insurances,
    required this.subSpecialties,
    required this.experiences,
    required this.educations,
    required this.onInsurancesChanged,
    required this.onSubSpecialtiesChanged,
    required this.onExperiencesChanged,
    required this.onEducationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminFormSection(
      title: context.loc.detailListsSection,
      children: [
        AdminChipEditor(
          label: context.loc.contractedInsurances,
          items: insurances,
          onChanged: onInsurancesChanged,
        ),
        context.vSpaceS,
        AdminChipEditor(
          label: context.loc.subSpecialties,
          items: subSpecialties,
          onChanged: onSubSpecialtiesChanged,
        ),
        context.vSpaceS,
        AdminChipEditor(
          label: context.loc.professionalExperiences,
          items: experiences,
          onChanged: onExperiencesChanged,
        ),
        context.vSpaceS,
        AdminChipEditor(
          label: context.loc.educationInformation,
          items: educations,
          onChanged: onEducationsChanged,
        ),
      ],
    );
  }
}
