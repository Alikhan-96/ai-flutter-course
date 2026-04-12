import 'package:flutter/material.dart';

import '../viewmodels/task_view_model.dart';

class TaskDashboardPage extends StatefulWidget {
  const TaskDashboardPage({
    required this.viewModel,
    super.key,
  });

  final TaskViewModel viewModel;

  @override
  State<TaskDashboardPage> createState() => _TaskDashboardPageState();
}

class _TaskDashboardPageState extends State<TaskDashboardPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_handleUpdate);
    widget.viewModel.loadTasks();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_handleUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 36: Clean Architecture + MVVM'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This sample keeps data, domain, and presentation separated. '
                'Constructor injection wires the dependencies, use cases keep '
                'the domain layer small, and the ViewModel exposes state to the UI.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Add review task',
              hintText: 'Example: Review Dio interceptors',
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              await vm.addTask(_controller.text);
              _controller.clear();
            },
            child: const Text('Add task via use case'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _TopicChip(label: 'BLoC'),
              _TopicChip(label: 'DI'),
              _TopicChip(label: 'Dio'),
              _TopicChip(label: 'Drift'),
              _TopicChip(label: 'Animations'),
            ],
          ),
          const SizedBox(height: 16),
          if (vm.error != null)
            Text(
              vm.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          if (vm.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Column(
              key: ValueKey(vm.tasks.length),
              children: vm.tasks
                  .map(
                    (task) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.account_tree_outlined),
                        title: Text(task.title),
                        subtitle: const Text(
                          'Created through ViewModel -> UseCase -> Repository',
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.check, size: 18),
      label: Text(label),
    );
  }
}
