# Урок 17: Provider - управление состоянием

## Основные темы

### Добавление зависимости
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
```

### ChangeNotifier - класс состояния
```dart
import 'package:flutter/foundation.dart';

class TasksProvider extends ChangeNotifier {
  List<String> _tasks = [];

  List<String> get tasks => _tasks;

  void addTask(String task) {
    _tasks.add(task);
    notifyListeners();  // Уведомляем слушателей
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void updateTask(int index, String newTask) {
    _tasks[index] = newTask;
    notifyListeners();
  }
}
```

### ChangeNotifierProvider - предоставление состояния
```dart
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TasksProvider(),
      child: MyApp(),
    ),
  );
}

// Несколько провайдеров
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TasksProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

### Чтение состояния - context.watch и context.read
```dart
class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // watch - подписывается на изменения, перестраивает виджет
    final tasks = context.watch<TasksProvider>().tasks;

    return Scaffold(
      appBar: AppBar(title: Text('Задачи (${tasks.length})')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index]),
            onLongPress: () {
              // read - однократное чтение без подписки
              context.read<TasksProvider>().removeTask(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // read для действий
          context.read<TasksProvider>().addTask('Новая задача');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Consumer - альтернативный способ
```dart
Consumer<TasksProvider>(
  builder: (context, provider, child) {
    return ListView.builder(
      itemCount: provider.tasks.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(provider.tasks[index]));
      },
    );
  },
)
```

### Полный пример приложения
```dart
class TasksProvider extends ChangeNotifier {
  List<String> _tasks = [];
  List<String> get tasks => _tasks;

  void addTask(String task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasksProvider = context.watch<TasksProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Мои задачи')),
      body: tasksProvider.tasks.isEmpty
          ? Center(child: Text('Нет задач'))
          : ListView.builder(
              itemCount: tasksProvider.tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.task),
                  title: Text(tasksProvider.tasks[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<TasksProvider>().removeTask(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TasksProvider>().addTask(
            'Задача ${tasksProvider.tasks.length + 1}',
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## Ключевые концепции
- **ChangeNotifier** - класс с методом notifyListeners()
- **ChangeNotifierProvider** - предоставляет состояние виджетам
- **context.watch** - подписка на изменения (в build)
- **context.read** - однократное чтение (в callbacks)
- **notifyListeners()** - уведомление об изменении

## Когда использовать Provider
- Средние и большие приложения
- Состояние, используемое несколькими виджетами
- Разделение логики и UI

## Типичные ошибки
- Использование watch в callbacks
- Забытый notifyListeners()
- Provider не найден (не обёрнут в ChangeNotifierProvider)
