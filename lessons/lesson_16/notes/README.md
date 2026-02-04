# Урок 16: SharedPreferences - локальное хранение данных

## Основные темы

### Добавление зависимости
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
```

### Базовые операции
```dart
import 'package:shared_preferences/shared_preferences.dart';

// Сохранение данных
Future<void> saveData() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt('counter', 42);
  await prefs.setString('username', 'Алия');
  await prefs.setBool('isDarkMode', true);
  await prefs.setDouble('rating', 4.5);
  await prefs.setStringList('tags', ['flutter', 'dart']);
}

// Чтение данных
Future<void> loadData() async {
  final prefs = await SharedPreferences.getInstance();

  int counter = prefs.getInt('counter') ?? 0;
  String username = prefs.getString('username') ?? '';
  bool isDark = prefs.getBool('isDarkMode') ?? false;
}

// Удаление данных
Future<void> removeData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('counter');
  // или очистить все
  await prefs.clear();
}
```

### Класс-модель с SharedPreferences
```dart
class CounterModel {
  int counter = 0;

  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('counter') ?? 0;
  }

  Future<void> saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
  }

  void increment() {
    counter++;
    saveCounter();
  }
}
```

### StatefulWidget с сохранением состояния
```dart
class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final counterModel = CounterModel();

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    await counterModel.loadCounter();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Счётчик')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${counterModel.counter}',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                counterModel.increment();
                setState(() {});
              },
              child: Text('Увеличить'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Сохранение настроек приложения
```dart
class SettingsService {
  static const _keyTheme = 'theme';
  static const _keyLanguage = 'language';
  static const _keyNotifications = 'notifications';

  Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, theme);
  }

  Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTheme) ?? 'light';
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotifications) ?? true;
  }
}
```

## Ключевые концепции
- **SharedPreferences** - простое хранилище ключ-значение
- Поддерживаемые типы: int, double, bool, String, List<String>
- Данные сохраняются между запусками приложения
- Асинхронные операции (async/await)

## Когда использовать
- Настройки пользователя (тема, язык)
- Простые данные (счётчики, флаги)
- Кэширование небольших данных

## Когда НЕ использовать
- Большие объёмы данных (используйте SQLite)
- Чувствительные данные (используйте flutter_secure_storage)
- Сложные структуры данных (используйте базу данных)

## Типичные ошибки
- Забытый await при асинхронных операциях
- Обращение до инициализации
- Хранение больших объёмов данных
