# Урок 1: Введение в Dart и Flutter

## Основные темы

### Установка Flutter SDK
- Скачивание Flutter SDK с официального сайта
- Настройка переменных окружения (PATH)
- Проверка установки: `flutter doctor`

### Выбор IDE
- **Android Studio** - полнофункциональная IDE с поддержкой эмуляторов
- **VS Code** - легковесный редактор с плагинами Flutter/Dart

### Структура Flutter проекта
```
project_name/
├── lib/           # Основной код приложения
│   └── main.dart  # Точка входа
├── android/       # Android-специфичные файлы
├── ios/           # iOS-специфичные файлы
├── web/           # Веб-поддержка
├── test/          # Тесты
├── pubspec.yaml   # Зависимости и метаданные
└── README.md      # Документация
```

### Первое приложение
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello, Flutter!'),
        ),
      ),
    );
  }
}
```

## Ключевые концепции
- **Hot Reload** - мгновенное обновление UI без перезапуска
- **Hot Restart** - полный перезапуск приложения
- **Widget** - базовый строительный блок UI

## Полезные команды
```bash
flutter create project_name  # Создание проекта
flutter run                  # Запуск приложения
flutter doctor               # Проверка окружения
```
