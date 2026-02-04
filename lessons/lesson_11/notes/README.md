# Урок 11: StatefulWidget и управление состоянием

## Основные темы

### Разница StatelessWidget и StatefulWidget
```dart
// StatelessWidget - без изменяемого состояния
class MyLabel extends StatelessWidget {
  final String text;
  MyLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

// StatefulWidget - с изменяемым состоянием
class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Text('$counter');
  }
}
```

### setState()
```dart
class _CounterPageState extends State<CounterPage> {
  int counter = 0;

  void _increment() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$counter',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _increment,
              child: Text('Увеличить'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Жизненный цикл StatefulWidget
```dart
class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Вызывается один раз при создании
    print('initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Вызывается после initState и при изменении зависимостей
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Вызывается при обновлении виджета родителем
  }

  @override
  void dispose() {
    // Вызывается при удалении виджета
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Пример счётчика с кнопками +/-
```dart
class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Счётчик')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Счётчик: $counter', style: TextStyle(fontSize: 32)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => counter--),
                  child: Text('-'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => setState(() => counter++),
                  child: Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## Ключевые концепции
- **setState()** - уведомляет Flutter о необходимости перестроить UI
- **initState()** - инициализация при создании виджета
- **dispose()** - очистка ресурсов при удалении виджета
- Состояние хранится в классе State, а не в Widget

## Типичные ошибки
- Вызов setState() после dispose()
- Забытый super.initState() / super.dispose()
- Изменение состояния без setState()
- Тяжёлые операции в build()
