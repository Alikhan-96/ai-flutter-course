import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Булево поле для отслеживания текущей темы
  bool isDark = false;

  // Определяем светлую тему
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16),
    ),
  );

  // Определяем тёмную тему
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
    ),
    cardTheme: CardThemeData(
      color: Colors.grey[800],
      elevation: 4,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme & Adaptive UI',
      // Используем обе темы
      theme: lightTheme,
      darkTheme: darkTheme,
      // Выбираем themeMode в зависимости от isDark
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        isDark: isDark,
        onThemeChanged: (value) {
          setState(() {
            isDark = value;
          });
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const HomePage({
    Key? key,
    required this.isDark,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Определяем ширину экрана для адаптивности
    final width = MediaQuery.of(context).size.width;
    final isWideScreen = width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Тема и адаптивность'),
        actions: [
          // Переключатель темы в AppBar
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => onThemeChanged(!isDark),
            tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
          ),
          // Switch для переключения темы
          Switch(
            value: isDark,
            onChanged: onThemeChanged,
          ),
        ],
      ),
      body: Padding(
        // Увеличенные отступы на широком экране
        padding: EdgeInsets.all(isWideScreen ? 32 : 16),
        child: isWideScreen
            ? _buildWideLayout(context)
            : _buildNarrowLayout(context),
      ),
    );
  }

  // Layout для широкого экрана (планшет/десктоп)
  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Левая панель - информация
        Expanded(
          flex: 1,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Информация',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoItem(
                    context,
                    Icons.palette,
                    'Тема',
                    isDark ? 'Тёмная' : 'Светлая',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    context,
                    Icons.screen_rotation,
                    'Режим',
                    'Широкий экран',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    context,
                    Icons.aspect_ratio,
                    'Ширина',
                    '${MediaQuery.of(context).size.width.toInt()} px',
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Правая панель - контент
        Expanded(
          flex: 2,
          child: _buildContentCards(context),
        ),
      ],
    );
  }

  // Layout для узкого экрана (телефон)
  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Информационная карточка
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Информация',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    context,
                    Icons.palette,
                    'Тема',
                    isDark ? 'Тёмная' : 'Светлая',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoItem(
                    context,
                    Icons.phone_android,
                    'Режим',
                    'Мобильный',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildContentCards(context),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text('$label: '),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildContentCards(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'title': 'Главная', 'subtitle': 'Описание главной'},
      {'icon': Icons.settings, 'title': 'Настройки', 'subtitle': 'Настройте приложение'},
      {'icon': Icons.person, 'title': 'Профиль', 'subtitle': 'Ваш профиль'},
      {'icon': Icons.info, 'title': 'О приложении', 'subtitle': 'Информация'},
    ];

    return Column(
      children: items.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(item['icon'] as IconData),
            title: Text(item['title'] as String),
            subtitle: Text(item['subtitle'] as String),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Нажато: ${item['title']}')),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
