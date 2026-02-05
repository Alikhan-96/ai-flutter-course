import 'package:flutter/material.dart';

// Homework 23: Использование ИИ для проектирования приложения
// Демонстрация идей и архитектуры, предложенных ИИ

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Design Ideas',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const AIDesignDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AIDesignDemo extends StatelessWidget {
  const AIDesignDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ИИ для проектирования'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Секция 1: Генерация идей
          _buildSection(
            context,
            'Генерация идей',
            Icons.lightbulb,
            Colors.amber,
            [
              'Трекер привычек с напоминаниями',
              'Планировщик расписания занятий',
              'Приложение для заметок с категориями',
              'Калькулятор GPA/среднего балла',
              'Поиск учебных материалов',
            ],
          ),

          const SizedBox(height: 16),

          // Секция 2: Структура экранов
          _buildSection(
            context,
            'Структура экранов',
            Icons.phone_android,
            Colors.blue,
            [
              'Главный экран (список элементов)',
              'Экран создания/редактирования',
              'Экран просмотра деталей',
              'Экран настроек',
              'Экран поиска/фильтрации',
            ],
          ),

          const SizedBox(height: 16),

          // Секция 3: Рекомендуемые пакеты
          _buildSection(
            context,
            'Рекомендуемые пакеты',
            Icons.extension,
            Colors.green,
            [
              'provider - управление состоянием',
              'hive/sqflite - локальная база данных',
              'flutter_local_notifications - уведомления',
              'intl - форматирование дат',
              'shared_preferences - настройки',
            ],
          ),

          const SizedBox(height: 16),

          // Секция 4: Архитектура
          _buildSection(
            context,
            'Архитектура проекта',
            Icons.folder,
            Colors.orange,
            [
              'lib/models/ - модели данных',
              'lib/screens/ - UI экраны',
              'lib/providers/ - состояние',
              'lib/services/ - бизнес-логика',
              'lib/widgets/ - переиспользуемые виджеты',
            ],
          ),

          const SizedBox(height: 16),

          // Секция 5: Улучшения UI
          _buildSection(
            context,
            'Улучшения UI',
            Icons.brush,
            Colors.pink,
            [
              'Добавить отступы (EdgeInsets)',
              'Использовать Card для группировки',
              'Добавить тени (BoxShadow)',
              'Использовать иконки',
              'Применить ThemeData для единого стиля',
            ],
          ),

          const SizedBox(height: 24),

          // Кнопка "Применить знания"
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Используйте эти идеи в своём проекте!'),
                  backgroundColor: Colors.purple,
                ),
              );
            },
            icon: const Icon(Icons.rocket_launch),
            label: const Text('Создать свой проект'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<String> items,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: color, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
