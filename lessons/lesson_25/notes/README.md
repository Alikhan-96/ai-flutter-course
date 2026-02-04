# Урок 25: Explicit анимации во Flutter

## Основные темы

### Разница Implicit vs Explicit
- **Implicit**: Просто, автоматически, ограниченный контроль
- **Explicit**: Полный контроль, возможность паузы/реверса, сложнее

### AnimationController
```dart
class ExplicitAnimationDemo extends StatefulWidget {
  @override
  _ExplicitAnimationDemoState createState() => _ExplicitAnimationDemoState();
}

class _ExplicitAnimationDemoState extends State<ExplicitAnimationDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,  // SingleTickerProviderStateMixin
    );

    _animation = Tween<double>(begin: 0, end: 300).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();  // Важно!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: _animation.value,
              height: 50,
              color: Colors.blue,
            );
          },
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _controller.forward(),
              child: Text('Forward'),
            ),
            ElevatedButton(
              onPressed: () => _controller.reverse(),
              child: Text('Reverse'),
            ),
            ElevatedButton(
              onPressed: () => _controller.stop(),
              child: Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### Методы AnimationController
```dart
_controller.forward();   // Запустить вперёд
_controller.reverse();   // Запустить назад
_controller.stop();      // Остановить
_controller.reset();     // Сбросить в начало
_controller.repeat();    // Повторять бесконечно
_controller.repeat(reverse: true);  // Туда-обратно
```

### Tween - диапазон значений
```dart
// Числа
Tween<double>(begin: 0, end: 100)

// Цвета
ColorTween(begin: Colors.red, end: Colors.blue)

// Позиция
Tween<Offset>(
  begin: Offset.zero,
  end: Offset(1, 0),  // Сдвиг вправо
)

// Размер
SizeTween(
  begin: Size(100, 100),
  end: Size(200, 200),
)
```

### CurvedAnimation
```dart
_animation = CurvedAnimation(
  parent: _controller,
  curve: Curves.easeInOut,
);

// Разные кривые для forward и reverse
_animation = CurvedAnimation(
  parent: _controller,
  curve: Curves.easeIn,
  reverseCurve: Curves.easeOut,
);
```

### AnimatedBuilder
```dart
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: _controller.value * 2 * pi,
      child: child,
    );
  },
  child: Icon(Icons.refresh, size: 50),  // Не перестраивается
)
```

### Пример: Анимация смещения и масштаба
```dart
class ScaleAndMoveDemo extends StatefulWidget {
  @override
  _ScaleAndMoveDemoState createState() => _ScaleAndMoveDemoState();
}

class _ScaleAndMoveDemoState extends State<ScaleAndMoveDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.5, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.purple,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _controller.forward(),
              child: Text('Start'),
            ),
            ElevatedButton(
              onPressed: () => _controller.stop(),
              child: Text('Stop'),
            ),
            ElevatedButton(
              onPressed: () => _controller.reverse(),
              child: Text('Reverse'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Слушатели анимации
```dart
_controller.addListener(() {
  print('Value: ${_controller.value}');
});

_controller.addStatusListener((status) {
  if (status == AnimationStatus.completed) {
    print('Анимация завершена');
  }
});
```

## Ключевые концепции
- **AnimationController** - управляет анимацией
- **Tween** - определяет диапазон значений
- **CurvedAnimation** - добавляет кривую
- **AnimatedBuilder** - оптимизирует перестроение
- **vsync** - синхронизация с обновлением экрана

## Типичные ошибки
- Забытый dispose() для контроллера
- Отсутствие TickerProviderStateMixin
- Не тот mixin (Single vs multiple)
- Бесконечный repeat без остановки
