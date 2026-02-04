import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks List Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TasksListScreen(),
    );
  }
}

class TasksListScreen extends StatelessWidget {
  const TasksListScreen({super.key});

  // 1) Список данных для отображения
  final List<String> tasks = const [
    "Задача 1",
    "Задача 2",
    "Задача 3",
    "Задача 4",
    "Задача 5",
    "Задача 6",
    "Задача 7",
    "Задача 8",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Список задач'),
      ),
      body: ListView.separated(
        // 3) itemCount равен длине списка
        itemCount: tasks.length,
        // 6) Разделитель между элементами
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          );
        },
        // 4) itemBuilder возвращает ListTile для каждого элемента
        itemBuilder: (context, index) {
          return ListTile(
            // 5) Иконка слева от текста
            leading: const Icon(
              Icons.check_box_outline_blank,
              color: Colors.blue,
            ),
            // Текст задачи
            title: Text(
              tasks[index],
              style: const TextStyle(fontSize: 16),
            ),
            // Дополнительная иконка справа (опционально)
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            // 7) Обработка нажатия на элемент
            onTap: () {
              // Вывод в консоль
              print('Нажата: ${tasks[index]}');

              // Показываем SnackBar с названием задачи
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Вы выбрали: ${tasks[index]}'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
