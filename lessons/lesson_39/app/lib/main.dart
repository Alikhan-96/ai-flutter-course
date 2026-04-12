import 'package:flutter/material.dart';

import 'data/repositories/in_memory_tasks_repository.dart';
import 'domain/entities/task.dart';
import 'domain/usecases/add_task_usecase.dart';

void main() {
  runApp(const Lesson39App());
}

class Lesson39App extends StatelessWidget {
  const Lesson39App({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = InMemoryTasksRepository();
    final addTaskUseCase = AddTaskUseCase(repository);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson 39: Unit Testing',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: Lesson39HomePage(
        repository: repository,
        addTaskUseCase: addTaskUseCase,
      ),
    );
  }
}

class Lesson39HomePage extends StatefulWidget {
  const Lesson39HomePage({
    required this.repository,
    required this.addTaskUseCase,
    super.key,
  });

  final InMemoryTasksRepository repository;
  final AddTaskUseCase addTaskUseCase;

  @override
  State<Lesson39HomePage> createState() => _Lesson39HomePageState();
}

class _Lesson39HomePageState extends State<Lesson39HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Task> _tasks = <Task>[];

  @override
  void initState() {
    super.initState();
    _reloadTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _reloadTasks() async {
    final tasks = await widget.repository.getTasks();

    if (!mounted) {
      return;
    }

    setState(() {
      _tasks
        ..clear()
        ..addAll(tasks);
    });
  }

  Future<void> _addTask() async {
    final draft = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _controller.text,
      isDone: false,
      createdAt: DateTime.now().toUtc(),
    );

    try {
      await widget.addTaskUseCase(draft);
      _controller.clear();
      await _reloadTasks();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task added successfully')));
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonChecks = <String>[
      'TaskDto -> Task mapper with reusable fixtures',
      'Task -> TaskDto reverse mapper',
      'AddTaskUseCase tested with a fake repository',
      'Error scenario with expected message',
      'Coverage command for key lesson files',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lesson 39: Unit Testing Practice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This lesson now implements the lecture homework directly: '
                'pure mapper tests, a use case with repository abstraction, '
                'fixtures, and a repeatable coverage command.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Homework checklist',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...lessonChecks.map(
                    (check) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(check),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a task through the use case',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task title',
                      hintText: 'Write something testable',
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _addTask,
                    icon: const Icon(Icons.add_task),
                    label: const Text('Add task'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stored tasks',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (_tasks.isEmpty)
                    const Text(
                      'No tasks yet. Try adding one to exercise AddTaskUseCase.',
                    )
                  else
                    ..._tasks.map(
                      (task) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          task.isDone
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                        ),
                        title: Text(task.title),
                        subtitle: Text(
                          'Created: ${task.createdAt.toLocal().toIso8601String()}',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
