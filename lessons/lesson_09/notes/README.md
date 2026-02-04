# Урок 9: Начало работы с Flutter

## Основные темы

### Создание Flutter проекта
```bash
flutter create my_first_flutter_app
cd my_first_flutter_app
flutter run
```

### Структура main.dart
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(title: Text('Главная')),
        body: Center(
          child: Text('Hello, Flutter!'),
        ),
      ),
    );
  }
}
```

### Базовые виджеты
```dart
// MaterialApp - корневой виджет Material Design
MaterialApp(
  title: 'App Name',
  theme: ThemeData(primarySwatch: Colors.blue),
  home: HomePage(),
)

// Scaffold - базовая структура экрана
Scaffold(
  appBar: AppBar(title: Text('Заголовок')),
  body: Container(),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
)

// Center - центрирование содержимого
Center(
  child: Text('Центрированный текст'),
)

// Text - отображение текста
Text(
  'Привет!',
  style: TextStyle(fontSize: 24, color: Colors.blue),
)
```

### Hot Reload и Hot Restart
- **Hot Reload (r)** - сохраняет состояние, обновляет UI
- **Hot Restart (R)** - полный перезапуск, сбрасывает состояние

### Android-эмулятор
1. Открыть AVD Manager в Android Studio
2. Создать новое виртуальное устройство
3. Выбрать версию Android
4. Запустить эмулятор

## Ключевые концепции
- **Widget** - всё в Flutter является виджетом
- **build()** - метод, возвращающий UI виджета
- **BuildContext** - информация о позиции виджета в дереве
- **Material Design** - дизайн-система от Google

## Типичные ошибки
- Забытый `const` для статических виджетов
- Отсутствие `MaterialApp` в корне
- Неправильная структура вложенности виджетов
