// tasks_tab.dart
// Demonstrates:
//  - StreamBuilder + watch() for reactive UI updates
//  - FutureBuilder + get() for one-time fetch (manual refresh required)
//  - Sorting by date / priority
//  - CRUD: add, edit (dialog), delete (swipe), toggle complete (checkbox)
import 'package:flutter/material.dart';

import '../database/database.dart';
import 'add_edit_task_dialog.dart';

// Priority display helpers
const _priorityLabels = ['Low', 'Medium', 'High'];
const _priorityColors = [Colors.green, Colors.orange, Colors.red];

class TasksTab extends StatefulWidget {
  final AppDatabase db;
  const TasksTab({super.key, required this.db});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  String _sortBy = 'date'; // 'date' or 'priority'
  bool _useStream = true; // true = watch(), false = get()

  // For get() mode: manually refreshed list
  List<TaskWithTag> _snapshotList = [];
  bool _snapshotLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshSnapshot();
  }

  Future<void> _refreshSnapshot() async {
    setState(() => _snapshotLoading = true);
    final result =
        await widget.db.getTasksWithTags(sortBy: _sortBy);
    if (mounted) {
      setState(() {
        _snapshotList = result;
        _snapshotLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: _useStream ? _buildStreamList() : _buildFutureList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_tasks',
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => AddEditTaskDialog(db: widget.db),
          );
          // Refresh snapshot if in get() mode (stream mode auto-refreshes)
          if (!_useStream) _refreshSnapshot();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOOLBAR
  // ---------------------------------------------------------------------------

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          // Sort toggle
          const Text('Sort:', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          ChoiceChip(
            label: const Text('Date'),
            selected: _sortBy == 'date',
            onSelected: (_) => _setSortBy('date'),
          ),
          const SizedBox(width: 4),
          ChoiceChip(
            label: const Text('Priority'),
            selected: _sortBy == 'priority',
            onSelected: (_) => _setSortBy('priority'),
          ),
          const Spacer(),
          // watch() vs get() toggle
          const Text('Mode:', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          ChoiceChip(
            label: const Text('watch()'),
            selected: _useStream,
            onSelected: (_) => setState(() => _useStream = true),
            tooltip: 'Reactive stream — auto-updates UI',
          ),
          const SizedBox(width: 4),
          ChoiceChip(
            label: const Text('get()'),
            selected: !_useStream,
            onSelected: (_) {
              setState(() => _useStream = false);
              _refreshSnapshot();
            },
            tooltip: 'One-time fetch — manual refresh needed',
          ),
          if (!_useStream)
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: _refreshSnapshot,
              tooltip: 'Refresh (get() mode requires manual refresh)',
            ),
        ],
      ),
    );
  }

  void _setSortBy(String value) {
    setState(() => _sortBy = value);
    if (!_useStream) _refreshSnapshot();
  }

  // ---------------------------------------------------------------------------
  // STREAM LIST — watch() reactive
  // ---------------------------------------------------------------------------

  Widget _buildStreamList() {
    return StreamBuilder<List<TaskWithTag>>(
      stream: widget.db.watchTasksWithTags(sortBy: _sortBy),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildList(snapshot.data ?? [],
            subtitle: 'watch() — updates automatically');
      },
    );
  }

  // ---------------------------------------------------------------------------
  // FUTURE LIST — get() one-shot
  // ---------------------------------------------------------------------------

  Widget _buildFutureList() {
    if (_snapshotLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildList(_snapshotList,
        subtitle: 'get() — tap ↺ to refresh manually');
  }

  // ---------------------------------------------------------------------------
  // SHARED LIST WIDGET
  // ---------------------------------------------------------------------------

  Widget _buildList(List<TaskWithTag> items, {required String subtitle}) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.task_alt, size: 64, color: Colors.grey),
            const SizedBox(height: 8),
            const Text('No tasks yet.\nTap + to add one.',
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (ctx, i) => _buildTaskTile(ctx, items[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskTile(BuildContext ctx, TaskWithTag twt) {
    final task = twt.task;
    final tag = twt.tag;
    final priority = task.priority.clamp(0, 2);

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: ctx,
              builder: (_) => AlertDialog(
                title: const Text('Delete task?'),
                content: Text('"${task.title}" will be permanently deleted.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete')),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) async {
        await widget.db.deleteTask(task.id);
        if (!_useStream) _refreshSnapshot();
      },
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) async {
              await widget.db.toggleComplete(task);
              if (!_useStream) _refreshSnapshot();
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration:
                  task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description?.isNotEmpty == true)
                Text(task.description!,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(
                children: [
                  // Priority badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _priorityColors[priority].withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: _priorityColors[priority], width: 0.8),
                    ),
                    child: Text(
                      _priorityLabels[priority],
                      style: TextStyle(
                          fontSize: 11, color: _priorityColors[priority]),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Tag chip
                  if (tag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(tag.colorValue).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: Color(tag.colorValue), width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(tag.colorValue),
                          ),
                          const SizedBox(width: 4),
                          Text(tag.name,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(tag.colorValue))),
                        ],
                      ),
                    ),
                  // Due date
                  if (task.dueDate != null) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.calendar_today,
                      size: 11,
                      color: task.dueDate!.isBefore(DateTime.now()) &&
                              !task.isCompleted
                          ? Colors.red
                          : Colors.grey,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${task.dueDate!.day}/${task.dueDate!.month}',
                      style: TextStyle(
                        fontSize: 11,
                        color: task.dueDate!.isBefore(DateTime.now()) &&
                                !task.isCompleted
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
              // Notes (v2 migration field)
              if (task.notes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '📝 ${task.notes}',
                    style:
                        const TextStyle(fontSize: 11, color: Colors.blueGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () async {
              await showDialog(
                context: ctx,
                builder: (_) =>
                    AddEditTaskDialog(db: widget.db, existing: task),
              );
              if (!_useStream) _refreshSnapshot();
            },
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
