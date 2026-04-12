import 'package:flutter/material.dart';

void main() {
  runApp(const Lesson35App());
}

class Lesson35App extends StatelessWidget {
  const Lesson35App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson 35: MVC and MVP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const ArchitecturePatternsPage(),
    );
  }
}

class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    this.completed = false,
  });

  final String id;
  final String title;
  final bool completed;

  TaskItem copyWith({String? id, String? title, bool? completed}) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

class ErrorHandler {
  String normalize(Object error) {
    return switch (error) {
      StateError() => 'Cannot complete the action because the task list is empty.',
      FormatException() => 'Please enter a task title before saving.',
      _ => 'Unexpected error: $error',
    };
  }
}

class TaskRepository {
  final List<TaskItem> _items = [
    const TaskItem(id: '1', title: 'Review MVC pattern'),
    const TaskItem(id: '2', title: 'Implement MVP presenter'),
  ];

  List<TaskItem> load() => List<TaskItem>.from(_items);

  List<TaskItem> add(String title) {
    if (title.trim().isEmpty) {
      throw const FormatException('Title is empty');
    }

    _items.add(
      TaskItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
      ),
    );
    return load();
  }

  List<TaskItem> toggle(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index < 0) {
      throw StateError('Task not found');
    }

    _items[index] = _items[index].copyWith(completed: !_items[index].completed);
    return load();
  }
}

class ArchitecturePatternsPage extends StatelessWidget {
  const ArchitecturePatternsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lesson 35: MVC and MVP'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'MVC'),
              Tab(text: 'MVP'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TaskMvcScreen(),
            TaskMvpScreen(),
          ],
        ),
      ),
    );
  }
}

class TaskController {
  TaskController({
    required this.repository,
    required this.errorHandler,
    required this.onStateChanged,
  });

  final TaskRepository repository;
  final ErrorHandler errorHandler;
  final VoidCallback onStateChanged;

  List<TaskItem> tasks = const [];
  String? error;

  void loadTasks() {
    _perform(() => tasks = repository.load());
  }

  void addTask(String title) {
    _perform(() => tasks = repository.add(title));
  }

  void toggleTask(String id) {
    _perform(() => tasks = repository.toggle(id));
  }

  void _perform(VoidCallback action) {
    try {
      error = null;
      action();
    } catch (errorValue) {
      error = errorHandler.normalize(errorValue);
    } finally {
      onStateChanged();
    }
  }
}

class TaskMvcScreen extends StatefulWidget {
  const TaskMvcScreen({super.key});

  @override
  State<TaskMvcScreen> createState() => _TaskMvcScreenState();
}

class _TaskMvcScreenState extends State<TaskMvcScreen> {
  final _controller = TextEditingController();
  late final TaskController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TaskController(
      repository: TaskRepository(),
      errorHandler: ErrorHandler(),
      onStateChanged: () => setState(() {}),
    )..loadTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PatternScaffold(
      patternName: 'MVC',
      subtitle:
          'The StatefulWidget talks to a controller directly. Business logic lives outside the UI, but the view still knows about controller state.',
      error: _taskController.error,
      tasks: _taskController.tasks,
      inputController: _controller,
      onAdd: () => _taskController.addTask(_controller.text),
      onToggle: _taskController.toggleTask,
    );
  }
}

abstract class TaskViewContract {
  void renderTasks(List<TaskItem> tasks);
  void showError(String message);
}

class TaskPresenter {
  TaskPresenter({
    required this.repository,
    required this.errorHandler,
  });

  final TaskRepository repository;
  final ErrorHandler errorHandler;
  TaskViewContract? _view;

  void attach(TaskViewContract view) {
    _view = view;
  }

  void loadTasks() {
    try {
      _view?.renderTasks(repository.load());
    } catch (error) {
      _view?.showError(errorHandler.normalize(error));
    }
  }

  void addTask(String title) {
    try {
      _view?.renderTasks(repository.add(title));
    } catch (error) {
      _view?.showError(errorHandler.normalize(error));
    }
  }

  void toggleTask(String id) {
    try {
      _view?.renderTasks(repository.toggle(id));
    } catch (error) {
      _view?.showError(errorHandler.normalize(error));
    }
  }
}

class TaskMvpScreen extends StatefulWidget {
  const TaskMvpScreen({super.key});

  @override
  State<TaskMvpScreen> createState() => _TaskMvpScreenState();
}

class _TaskMvpScreenState extends State<TaskMvpScreen>
    implements TaskViewContract {
  final _controller = TextEditingController();
  late final TaskPresenter _presenter;
  List<TaskItem> _tasks = const [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _presenter = TaskPresenter(
      repository: TaskRepository(),
      errorHandler: ErrorHandler(),
    )..attach(this);
    _presenter.loadTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PatternScaffold(
      patternName: 'MVP',
      subtitle:
          'The widget implements a view contract while the presenter owns the interaction logic. This makes UI behavior easier to reason about and test.',
      error: _error,
      tasks: _tasks,
      inputController: _controller,
      onAdd: () => _presenter.addTask(_controller.text),
      onToggle: _presenter.toggleTask,
    );
  }

  @override
  void renderTasks(List<TaskItem> tasks) {
    setState(() {
      _tasks = tasks;
      _error = null;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _error = message;
    });
  }
}

class PatternScaffold extends StatelessWidget {
  const PatternScaffold({
    super.key,
    required this.patternName,
    required this.subtitle,
    required this.error,
    required this.tasks,
    required this.inputController,
    required this.onAdd,
    required this.onToggle,
  });

  final String patternName;
  final String subtitle;
  final String? error;
  final List<TaskItem> tasks;
  final TextEditingController inputController;
  final VoidCallback onAdd;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('$patternName: $subtitle'),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: inputController,
                decoration: const InputDecoration(
                  labelText: 'New task',
                  hintText: 'Add homework item',
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {
                onAdd();
                inputController.clear();
              },
              child: const Text('Add'),
            ),
          ],
        ),
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
        const SizedBox(height: 16),
        ...tasks.map(
          (task) => Card(
            child: CheckboxListTile(
              value: task.completed,
              title: Text(task.title),
              onChanged: (_) => onToggle(task.id),
            ),
          ),
        ),
      ],
    );
  }
}
