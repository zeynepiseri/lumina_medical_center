import 'package:flutter/material.dart';
import '../../../../../../core/init/theme/app_colors.dart';
import 'admin_text_field.dart';

class AdminChipEditor extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(List<String>) onChanged;

  const AdminChipEditor({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  State<AdminChipEditor> createState() => _AdminChipEditorState();
}

class _AdminChipEditorState extends State<AdminChipEditor> {
  final TextEditingController _controller = TextEditingController();

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final newList = List<String>.from(widget.items)..add(text);
      widget.onChanged(newList);
      _controller.clear();
    }
  }

  void _removeItem(int index) {
    final newList = List<String>.from(widget.items)..removeAt(index);
    widget.onChanged(newList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AdminTextField(
                label: widget.label,
                controller: _controller,
                isRequired: false,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: InkWell(
                onTap: _addItem,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.oldGold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: widget.items.asMap().entries.map((entry) {
            return Chip(
              backgroundColor: AppColors.midnightBlue.withOpacity(0.05),
              label: Text(
                entry.value,
                style: const TextStyle(
                  color: AppColors.midnightBlue,
                  fontSize: 12,
                ),
              ),
              deleteIcon: const Icon(
                Icons.close,
                size: 14,
                color: AppColors.midnightBlue,
              ),
              onDeleted: () => _removeItem(entry.key),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide.none,
              ),
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        ),
      ],
    );
  }
}
