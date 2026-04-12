// add_edit_task_dialog.dart
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../database/database.dart';

class AddEditTaskDialog extends StatefulWidget {
  final AppDatabase db;
  final Task? existing; // null = add mode, non-null = edit mode

  const AddEditTaskDialog({super.key, required this.db, this.existing});

  @override
  State<AddEditTaskDialog> createState() => _AddEditTaskDialogState();
}

class _AddEditTaskDialogState extends State<AddEditTaskDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _notesCtrl;

  late int _priority;
  DateTime? _dueDate;
  int? _tagId;

  List<Tag> _allTags = [];

  static const _priorityLabels = ['Low', 'Medium', 'High'];
  static const _priorityColors = [Colors.green, Colors.orange, Colors.red];

  @override
  void initState() {
    super.initState();
    final t = widget.existing;
    _titleCtrl = TextEditingController(text: t?.title ?? '');
    _descCtrl = TextEditingController(text: t?.description ?? '');
    _notesCtrl = TextEditingController(text: t?.notes ?? '');
    _priority = t?.priority ?? 0;
    _dueDate = t?.dueDate;
    _tagId = t?.tagId;
    _loadTags();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadTags() async {
    final tags = await widget.db.getAllTags();
    if (mounted) setState(() => _allTags = tags);
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    if (widget.existing == null) {
      await widget.db.insertTask(TasksCompanion.insert(
        title: title,
        description: Value(_descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim()),
        priority: Value(_priority),
        dueDate: Value(_dueDate),
        tagId: Value(_tagId),
        notes: Value(_notesCtrl.text.trim()),
      ));
    } else {
      await widget.db.updateTask(widget.existing!.copyWith(
        title: title,
        description: Value(_descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim()),
        priority: _priority,
        dueDate: Value(_dueDate),
        tagId: Value(_tagId),
        notes: _notesCtrl.text.trim(),
      ));
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Task' : 'New Task'),
      scrollable: true,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            // Notes (added in schema v2 via migration)
            TextField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notes (v2 field)',
                border: OutlineInputBorder(),
                helperText: 'Added via schema migration v1→v2',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            // Priority
            const Text('Priority', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 4),
            SegmentedButton<int>(
              segments: List.generate(
                3,
                (i) => ButtonSegment(
                  value: i,
                  label: Text(_priorityLabels[i]),
                  icon: Icon(Icons.circle,
                      color: _priorityColors[i], size: 12),
                ),
              ),
              selected: {_priority},
              onSelectionChanged: (s) =>
                  setState(() => _priority = s.first),
            ),
            const SizedBox(height: 12),

            // Tag selector
            const Text('Tag', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 4),
            DropdownButtonFormField<int?>(
              initialValue: _tagId,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem(value: null, child: Text('— None —')),
                ..._allTags.map((tag) => DropdownMenuItem(
                      value: tag.id,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: Color(tag.colorValue),
                          ),
                          const SizedBox(width: 8),
                          Text(tag.name),
                        ],
                      ),
                    )),
              ],
              onChanged: (v) => setState(() => _tagId = v),
            ),
            const SizedBox(height: 12),

            // Due date
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? 'No due date'
                        : 'Due: ${_dueDate!.year}-'
                            '${_dueDate!.month.toString().padLeft(2, '0')}-'
                            '${_dueDate!.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickDueDate,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text('Pick'),
                ),
                if (_dueDate != null)
                  IconButton(
                    onPressed: () => setState(() => _dueDate = null),
                    icon: const Icon(Icons.clear, size: 16),
                    tooltip: 'Clear',
                  ),
              ],
            ),
          ],
        ),
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
