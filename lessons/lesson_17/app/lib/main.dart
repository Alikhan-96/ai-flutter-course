import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Оборачиваем MaterialApp в ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (_) => TasksProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Tasks App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TasksScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Класс TasksProvider, расширяющий ChangeNotifier
class TasksProvider extends ChangeNotifier {
  final List<String> _tasks = [];

  // Геттер для получения списка задач
  List<String> get tasks => List.unmodifiable(_tasks);

  // Метод добавления задачи
  void addTask(String task) {
    _tasks.add(task);
    notifyListeners();
  }

  // Метод удаления задачи по индексу
  void removeTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  // Дополнительно: метод для очистки всех задач
  void clearAll() {
    _tasks.clear();
    notifyListeners();
  }
}

// Экран со списком задач
class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Используем context.watch для подписки на изменения
    final tasksProvider = context.watch<TasksProvider>();
    final tasks = tasksProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Мои задачи (${tasks.length})'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (tasks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                // Используем context.read для действий
                context.read<TasksProvider>().clearAll();
              },
              tooltip: 'Очистить все',
            ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Нет задач',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Нажмите + чтобы добавить задачу',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(tasks[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Удаление задачи при нажатии
                        context.read<TasksProvider>().removeTask(index);
                      },
                    ),
                    // Удаление при долгом нажатии
                    onLongPress: () {
                      // Показываем диалог подтверждения
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Удалить задачу?'),
                          content: Text('Удалить "${tasks[index]}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<TasksProvider>().removeTask(index);
                                Navigator.pop(ctx);
                              },
                              child: const Text(
                                'Удалить',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      // FloatingActionButton для добавления новой задачи
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Показываем диалог для ввода задачи
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Новая задача'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Введите название задачи',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              context.read<TasksProvider>().addTask(value);
              Navigator.pop(ctx);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<TasksProvider>().addTask(controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
