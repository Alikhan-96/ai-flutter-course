# Урок 13: Навигация между экранами

## Основные темы

### Navigator.push и Navigator.pop
```dart
// Переход на новый экран
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailsScreen()),
);

// Возврат на предыдущий экран
Navigator.pop(context);
```

### Передача данных между экранами
```dart
// Главный экран
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главная')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(
                  detailText: 'Привет из MainScreen',
                ),
              ),
            );
          },
          child: Text('Открыть детали'),
        ),
      ),
    );
  }
}

// Экран деталей с параметром
class DetailsScreen extends StatelessWidget {
  final String detailText;

  DetailsScreen({required this.detailText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Детали')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(detailText),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Именованные маршруты
```dart
// Определение маршрутов в MaterialApp
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => MainScreen(),
    '/details': (context) => DetailsScreen(),
    '/settings': (context) => SettingsScreen(),
  },
)

// Навигация по имени
Navigator.pushNamed(context, '/details');

// Передача аргументов
Navigator.pushNamed(
  context,
  '/details',
  arguments: {'id': 1, 'title': 'Заголовок'},
);

// Получение аргументов
final args = ModalRoute.of(context)!.settings.arguments as Map;
```

### Возврат данных с экрана
```dart
// Отправка данных при возврате
Navigator.pop(context, 'Результат');

// Получение результата
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SelectionScreen()),
);
print('Результат: $result');
```

### Структура с тремя экранами
```dart
// MainScreen -> DetailsScreen -> SettingsScreen
class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Детали')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            child: Text('Настройки'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Назад'),
          ),
        ],
      ),
    );
  }
}
```

## Ключевые концепции
- **Navigator** - управляет стеком экранов
- **push** - добавляет экран в стек
- **pop** - удаляет верхний экран из стека
- **MaterialPageRoute** - анимированный переход

## Типичные ошибки
- Вызов Navigator без context
- Забытый await при ожидании результата
- Попытка pop на пустом стеке
