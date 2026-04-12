import 'package:flutter/material.dart';

void main() {
  runApp(TaskApp(repository: DemoTasksRepository()));
}

class TaskApp extends StatelessWidget {
  const TaskApp({required this.repository, super.key});

  final TasksRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson 40: Widget Tests',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: TasksScreen(repository: repository),
    );
  }
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}

abstract class TasksRepository {
  Future<List<Task>> fetchTasks();

  Future<Task> addTask(String title);
}

class DemoTasksRepository implements TasksRepository {
  final List<Task> _tasks = <Task>[
    const Task(
      id: '1',
      title: 'Write widget tests',
      description: 'Check loading, success, error, add, and navigation flows.',
    ),
    const Task(
      id: '2',
      title: 'Use stable keys',
      description:
          'Find important widgets by key instead of fragile selectors.',
    ),
  ];

  @override
  Future<List<Task>> fetchTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List<Task>.from(_tasks);
  }

  @override
  Future<Task> addTask(String title) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      description: 'Created from the add task form.',
    );
    _tasks.add(task);
    return task;
  }
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({required this.repository, super.key});

  final TasksRepository repository;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Task> _tasks = const <Task>[];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tasks = await widget.repository.fetchTasks();
      if (!mounted) {
        return;
      }
      setState(() {
        _tasks = tasks;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load tasks: $error')));
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addTask() async {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title cannot be empty')),
      );
      return;
    }

    try {
      final task = await widget.repository.addTask(title);
      if (!mounted) {
        return;
      }
      setState(() {
        _tasks = <Task>[..._tasks, task];
        _errorMessage = null;
      });
      _controller.clear();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add task: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson 40: Widget Testing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('taskInput'),
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Task title',
              hintText: 'Enter a task title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  key: const Key('addTaskButton'),
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('loadTasksButton'),
                  onPressed: _loadTasks,
                  icon: const Icon(Icons.download),
                  label: const Text('Load tasks'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(key: Key('loadingIndicator')),
              ),
            )
          else if (_errorMessage != null)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: ListTile(
                key: const Key('errorMessage'),
                leading: const Icon(Icons.error_outline),
                title: const Text('Error occurred'),
                subtitle: Text(_errorMessage!),
              ),
            )
          else if (_tasks.isEmpty)
            const Card(
              child: ListTile(
                key: Key('emptyState'),
                leading: Icon(Icons.inbox_outlined),
                title: Text('No tasks yet'),
                subtitle: Text('Load tasks or add a new one to begin.'),
              ),
            )
          else
            ..._tasks.map(
              (task) => Card(
                child: ListTile(
                  key: Key('taskItem-${task.id}'),
                  leading: const Icon(Icons.checklist_outlined),
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => TaskDetailsScreen(task: task),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: ListTile(
            key: const Key('taskDetails'),
            leading: const Icon(Icons.description_outlined),
            title: Text(task.title),
            subtitle: Text(task.description),
          ),
        ),
      ),
    );
  }
}
