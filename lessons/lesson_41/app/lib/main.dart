import 'package:flutter/material.dart';

void main() {
  runApp(Lesson41App(dependencies: AppDependencies.demo()));
}

class Lesson41App extends StatelessWidget {
  const Lesson41App({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson 41: Mock and Integration Tests',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: Lesson41HomePage(
        controller: TasksController(dependencies.repository),
      ),
    );
  }
}

class AppDependencies {
  const AppDependencies({
    required this.apiClient,
    required this.database,
    required this.repository,
  });

  final ApiClient apiClient;
  final LocalDatabase database;
  final TasksRepository repository;

  factory AppDependencies.demo() {
    final apiClient = FakeApiClient();
    final database = InMemoryLocalDatabase();

    return AppDependencies(
      apiClient: apiClient,
      database: database,
      repository: TasksRepository(apiClient: apiClient, database: database),
    );
  }

  factory AppDependencies.test({
    FakeApiClient? apiClient,
    InMemoryLocalDatabase? database,
  }) {
    final resolvedApiClient = apiClient ?? FakeApiClient();
    final resolvedDatabase = database ?? InMemoryLocalDatabase();

    return AppDependencies(
      apiClient: resolvedApiClient,
      database: resolvedDatabase,
      repository: TasksRepository(
        apiClient: resolvedApiClient,
        database: resolvedDatabase,
      ),
    );
  }
}

class Task {
  const Task({required this.id, required this.title});

  final String id;
  final String title;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(id: json['id'].toString(), title: json['title'].toString());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'title': title};
  }
}

abstract class ApiClient {
  Future<void> login({required String email, required String password});

  Future<List<Map<String, dynamic>>> getTasks();

  Future<Map<String, dynamic>> addTask(String title);

  Future<void> logout();
}

abstract class LocalDatabase {
  Future<void> saveSession(String email);

  Future<void> cacheTasks(List<Task> tasks);

  Future<List<Task>> getCachedTasks();

  Future<void> clear();
}

class FakeApiClient implements ApiClient {
  FakeApiClient({
    List<Map<String, dynamic>> initialTasks = const <Map<String, dynamic>>[
      <String, dynamic>{'id': '1', 'title': 'Review mocked repository'},
      <String, dynamic>{'id': '2', 'title': 'Write integration scenario'},
    ],
  }) : _tasks = List<Map<String, dynamic>>.from(initialTasks);

  final List<Map<String, dynamic>> _tasks;

  int loginCalls = 0;
  int getTasksCalls = 0;
  int addTaskCalls = 0;
  int logoutCalls = 0;

  @override
  Future<Map<String, dynamic>> addTask(String title) async {
    addTaskCalls++;
    final task = <String, dynamic>{
      'id': (_tasks.length + 1).toString(),
      'title': title,
    };
    _tasks.add(task);
    return task;
  }

  @override
  Future<List<Map<String, dynamic>>> getTasks() async {
    getTasksCalls++;
    return List<Map<String, dynamic>>.from(_tasks);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    loginCalls++;

    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
  }
}

class InMemoryLocalDatabase implements LocalDatabase {
  String? savedSessionEmail;
  List<Task> cachedTasks = const <Task>[];

  @override
  Future<void> cacheTasks(List<Task> tasks) async {
    cachedTasks = List<Task>.from(tasks);
  }

  @override
  Future<void> clear() async {
    savedSessionEmail = null;
    cachedTasks = const <Task>[];
  }

  @override
  Future<List<Task>> getCachedTasks() async {
    return List<Task>.from(cachedTasks);
  }

  @override
  Future<void> saveSession(String email) async {
    savedSessionEmail = email;
  }
}

class TasksRepository {
  TasksRepository({required this.apiClient, required this.database});

  final ApiClient apiClient;
  final LocalDatabase database;

  Future<void> login({required String email, required String password}) async {
    await apiClient.login(email: email, password: password);
    await database.saveSession(email);
  }

  Future<List<Task>> getTasks() async {
    try {
      final json = await apiClient.getTasks();
      final tasks = json.map(Task.fromJson).toList();
      await database.cacheTasks(tasks);
      return tasks;
    } catch (_) {
      return database.getCachedTasks();
    }
  }

  Future<Task> addTask(String title) async {
    final json = await apiClient.addTask(title);
    final task = Task.fromJson(json);
    final cached = await database.getCachedTasks();
    await database.cacheTasks(<Task>[...cached, task]);
    return task;
  }

  Future<void> logout() async {
    await apiClient.logout();
    await database.clear();
  }
}

class TasksController extends ChangeNotifier {
  TasksController(this._repository);

  final TasksRepository _repository;

  bool isAuthenticated = false;
  bool isLoading = false;
  String? errorMessage;
  List<Task> tasks = const <Task>[];

  Future<void> login({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.login(email: email, password: password);
      isAuthenticated = true;
      await loadTasks();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTasks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      tasks = await _repository.getTasks();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      errorMessage = 'Task title cannot be empty';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final task = await _repository.addTask(trimmedTitle);
      tasks = <Task>[...tasks, task];
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    isAuthenticated = false;
    tasks = const <Task>[];
    errorMessage = null;
    notifyListeners();
  }
}

class Lesson41HomePage extends StatefulWidget {
  const Lesson41HomePage({required this.controller, super.key});

  final TasksController controller;

  @override
  State<Lesson41HomePage> createState() => _Lesson41HomePageState();
}

class _Lesson41HomePageState extends State<Lesson41HomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 41: Mock + Integration'),
        actions: [
          if (controller.isAuthenticated)
            TextButton(
              key: const Key('logoutButton'),
              onPressed: controller.isLoading ? null : controller.logout,
              child: const Text('Logout'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!controller.isAuthenticated) ...[
            TextField(
              key: const Key('email'),
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('password'),
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const Key('loginButton'),
              onPressed: controller.isLoading
                  ? null
                  : () => controller.login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
              child: const Text('Login'),
            ),
          ] else ...[
            TextField(
              key: const Key('taskInput'),
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const Key('addButton'),
              onPressed: controller.isLoading
                  ? null
                  : () async {
                      await controller.addTask(_taskController.text);
                      _taskController.clear();
                    },
              child: const Text('Add'),
            ),
            const SizedBox(height: 16),
            if (controller.tasks.isEmpty && !controller.isLoading)
              const ListTile(
                key: Key('emptyTasks'),
                leading: Icon(Icons.inbox_outlined),
                title: Text('No tasks yet'),
              )
            else
              ...controller.tasks.map(
                (task) => ListTile(
                  key: Key('task-${task.id}'),
                  leading: const Icon(Icons.task_alt),
                  title: Text(task.title),
                ),
              ),
          ],
          if (controller.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Center(
                child: CircularProgressIndicator(key: Key('loading')),
              ),
            ),
          if (controller.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                controller.errorMessage!,
                key: const Key('errorText'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}
