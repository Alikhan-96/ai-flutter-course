# Урок 24: Implicit анимации во Flutter

## Основные темы

### Что такое анимация
Анимация - плавное изменение свойств виджета во времени:
- Позиция
- Размер
- Цвет
- Прозрачность
- И другие свойства

### Implicit vs Explicit анимации
- **Implicit** - автоматические, простые в использовании
- **Explicit** - полный контроль, требуют AnimationController

### AnimatedContainer
```dart
class AnimatedContainerDemo extends StatefulWidget {
  @override
  _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _expanded ? 200 : 100,
        height: _expanded ? 200 : 100,
        color: _expanded ? Colors.blue : Colors.red,
        child: Center(child: Text('Нажми')),
      ),
    );
  }
}
```

### AnimatedOpacity
```dart
AnimatedOpacity(
  duration: Duration(milliseconds: 500),
  opacity: _visible ? 1.0 : 0.0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.green,
  ),
)
```

### AnimatedAlign
```dart
AnimatedAlign(
  duration: Duration(milliseconds: 300),
  alignment: _alignRight ? Alignment.centerRight : Alignment.centerLeft,
  child: Container(
    width: 50,
    height: 50,
    color: Colors.purple,
  ),
)
```

### AnimatedPadding
```dart
AnimatedPadding(
  duration: Duration(milliseconds: 300),
  padding: _expanded
      ? EdgeInsets.all(50)
      : EdgeInsets.all(10),
  child: Container(color: Colors.orange),
)
```

### Duration и Curve
```dart
// Duration - длительность анимации
Duration(milliseconds: 300)  // 0.3 секунды
Duration(seconds: 1)         // 1 секунда

// Curve - характер анимации
Curves.linear        // Линейная
Curves.easeIn        // Медленный старт
Curves.easeOut       // Медленный финиш
Curves.easeInOut     // Медленный старт и финиш
Curves.bounceOut     // Отскок в конце
Curves.elasticOut    // Эластичный эффект
```

### Анимация состояний UI
```dart
class LoadingButton extends StatefulWidget {
  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: _isLoading ? 50 : 150,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _startLoading,
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text('Загрузить'),
      ),
    );
  }

  void _startLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() => _isLoading = false);
  }
}
```

### AnimatedDefaultTextStyle
```dart
AnimatedDefaultTextStyle(
  duration: Duration(milliseconds: 300),
  style: _highlighted
      ? TextStyle(fontSize: 24, color: Colors.red)
      : TextStyle(fontSize: 16, color: Colors.black),
  child: Text('Анимированный текст'),
)
```

### Полный пример
```dart
class ImplicitAnimationsDemo extends StatefulWidget {
  @override
  _ImplicitAnimationsDemoState createState() => _ImplicitAnimationsDemoState();
}

class _ImplicitAnimationsDemoState extends State<ImplicitAnimationsDemo> {
  bool _toggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Implicit Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              width: _toggled ? 200 : 100,
              height: _toggled ? 200 : 100,
              decoration: BoxDecoration(
                color: _toggled ? Colors.blue : Colors.orange,
                borderRadius: BorderRadius.circular(_toggled ? 100 : 10),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => _toggled = !_toggled),
              child: Text('Переключить'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Ключевые концепции
- Implicit анимации запускаются автоматически при изменении свойств
- `duration` определяет длительность
- `curve` определяет характер анимации
- setState() запускает анимацию

## Типичные ошибки
- Слишком длинная duration (раздражает пользователя)
- Слишком короткая duration (не заметна)
- Неподходящая curve для контекста
- Анимация без смысловой нагрузки
