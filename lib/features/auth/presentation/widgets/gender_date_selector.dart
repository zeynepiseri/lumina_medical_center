import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class GenderDateSelector extends StatelessWidget {
  final String? gender;
  final DateTime? birthDate;
  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<DateTime?> onDateChanged;

  const GenderDateSelector({
    super.key,
    required this.gender,
    required this.birthDate,
    required this.onGenderChanged,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final genderItems = [
      MapEntry("Male", context.loc.genderMale),
      MapEntry("Female", context.loc.genderFemale),
    ];

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: gender,
            decoration: _inputDecoration(context, context.loc.genderLabel),
            items: genderItems
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: onGenderChanged,
          ),
        ),
        context.hSpaceM,
        Expanded(
          child: InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) onDateChanged(date);
            },
            child: Container(
              height: context.layout.inputHeight,
              padding: context.paddingHorizontalM,
              decoration: BoxDecoration(
                color: context.colors.surface,
                border: Border.all(color: context.colors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(context.radius.xxl),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    birthDate == null
                        ? context.loc.birthDateLabel
                        : "${birthDate!.day}.${birthDate!.month}.${birthDate!.year}",
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: birthDate == null
                          ? context.colors.primary.withOpacity(0.7)
                          : context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: context.colors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: context.colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.radius.xxl),
        borderSide: BorderSide(color: context.colors.primary, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.radius.xxl),
        borderSide: BorderSide(color: context.colors.primary, width: 1.5),
      ),
      contentPadding: context.paddingHorizontalM.copyWith(top: 16, bottom: 16),
    );
  }
}
