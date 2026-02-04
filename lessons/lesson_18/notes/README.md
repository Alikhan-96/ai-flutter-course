# Урок 18: Темы и адаптивный дизайн

## Основные темы

### Светлая и тёмная темы
```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        isDark: isDark,
        onThemeChanged: (value) {
          setState(() => isDark = value);
        },
      ),
    );
  }
}
```

### Кастомизация темы
```dart
final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  scaffoldBackgroundColor: Colors.grey[900],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[850],
  ),
);
```

### Переключатель темы
```dart
class HomePage extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  HomePage({required this.isDark, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
        actions: [
          Switch(
            value: isDark,
            onChanged: onThemeChanged,
          ),
          // Или IconButton
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => onThemeChanged(!isDark),
          ),
        ],
      ),
      body: Center(
        child: Text('Текущая тема: ${isDark ? "Тёмная" : "Светлая"}'),
      ),
    );
  }
}
```

### MediaQuery - размеры экрана
```dart
@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;
  final orientation = MediaQuery.of(context).orientation;

  return Scaffold(
    body: Center(
      child: Text('Ширина: $width, Высота: $height'),
    ),
  );
}
```

### Адаптивный layout
```dart
@override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  return Scaffold(
    body: width > 600
        ? _buildWideLayout()   // Планшет/десктоп
        : _buildNarrowLayout(), // Телефон
  );
}

Widget _buildWideLayout() {
  return Row(
    children: [
      Expanded(flex: 1, child: NavigationPanel()),
      Expanded(flex: 2, child: ContentPanel()),
    ],
  );
}

Widget _buildNarrowLayout() {
  return Column(
    children: [
      Expanded(child: ContentPanel()),
    ],
  );
}
```

### LayoutBuilder для адаптивности
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return GridView.count(
        crossAxisCount: 3,
        children: items.map((item) => ItemCard(item)).toList(),
      );
    } else {
      return ListView(
        children: items.map((item) => ItemTile(item)).toList(),
      );
    }
  },
)
```

### OrientationBuilder
```dart
OrientationBuilder(
  builder: (context, orientation) {
    return GridView.count(
      crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
      children: items.map((item) => ItemCard(item)).toList(),
    );
  },
)
```

## Ключевые концепции
- **ThemeData** - настройки темы приложения
- **ThemeMode** - light, dark, system
- **MediaQuery** - информация об экране
- **LayoutBuilder** - адаптация к доступному пространству
- **OrientationBuilder** - адаптация к ориентации

## Breakpoints (рекомендуемые)
- Телефон: < 600px
- Планшет: 600px - 900px
- Десктоп: > 900px

## Типичные ошибки
- Жёстко заданные размеры вместо адаптивных
- Забытый setState при смене темы
- MediaQuery в initState (context ещё не готов)
