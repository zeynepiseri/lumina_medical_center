import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class EditVitalsDialog extends StatefulWidget {
  final double? height;
  final double? weight;
  final String? bloodType;
  final Function(double? height, double? weight, String? bloodType) onSave;

  const EditVitalsDialog({
    super.key,
    this.height,
    this.weight,
    this.bloodType,
    required this.onSave,
  });

  @override
  State<EditVitalsDialog> createState() => _EditVitalsDialogState();
}

class _EditVitalsDialogState extends State<EditVitalsDialog> {
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String? _selectedBloodType;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(
      text: widget.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.weight?.toString() ?? '',
    );
    _selectedBloodType = widget.bloodType;
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.large),
      ),
      child: Padding(
        padding: context.paddingAllL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.editVitalsTitle,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
            context.vSpaceL,
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: context.loc.heightLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.radius.medium),
                ),
                prefixIcon: const Icon(Icons.height),
              ),
            ),
            context.vSpaceM,
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: context.loc.weightLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.radius.medium),
                ),
                prefixIcon: const Icon(Icons.monitor_weight_outlined),
              ),
            ),
            context.vSpaceM,
            DropdownButtonFormField<String>(
              value: _selectedBloodType,
              decoration: InputDecoration(
                labelText: context.loc.bloodTypeLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.radius.medium),
                ),
                prefixIcon: const Icon(Icons.bloodtype),
              ),
              items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-']
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedBloodType = val),
            ),
            context.vSpaceL,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.loc.cancel),
                ),
                context.hSpaceS,
                ElevatedButton(
                  onPressed: () {
                    final height = double.tryParse(_heightController.text);
                    final weight = double.tryParse(_weightController.text);
                    widget.onSave(height, weight, _selectedBloodType);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.radius.medium,
                      ),
                    ),
                  ),
                  child: Text(context.loc.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
