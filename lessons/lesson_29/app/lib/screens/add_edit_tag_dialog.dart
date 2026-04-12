// add_edit_tag_dialog.dart
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../database/database.dart';

/// Predefined color palette for tags
const _colors = <Color>[
  Color(0xFF2196F3), // Blue
  Color(0xFF4CAF50), // Green
  Color(0xFFF44336), // Red
  Color(0xFFFF9800), // Orange
  Color(0xFF9C27B0), // Purple
  Color(0xFF00BCD4), // Cyan
  Color(0xFFFFEB3B), // Yellow
  Color(0xFF795548), // Brown
];

class AddEditTagDialog extends StatefulWidget {
  final AppDatabase db;
  final Tag? existing; // null = add mode, non-null = edit mode

  const AddEditTagDialog({super.key, required this.db, this.existing});

  @override
  State<AddEditTagDialog> createState() => _AddEditTagDialogState();
}

class _AddEditTagDialogState extends State<AddEditTagDialog> {
  late final TextEditingController _nameCtrl;
  late int _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameCtrl =
        TextEditingController(text: widget.existing?.name ?? '');
    _selectedColor =
        widget.existing?.colorValue ?? _colors.first.toARGB32();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    if (widget.existing == null) {
      await widget.db.insertTag(TagsCompanion.insert(
        name: name,
        colorValue: Value(_selectedColor),
      ));
    } else {
      await widget.db.updateTag(widget.existing!.copyWith(
        name: name,
        colorValue: _selectedColor,
      ));
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Tag' : 'New Tag'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Tag name',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Color', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _colors.map((color) {
              final selected = color.toARGB32() == _selectedColor;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color.toARGB32()),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(color: Colors.black, width: 3)
                        : null,
                  ),
                  child: selected
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
