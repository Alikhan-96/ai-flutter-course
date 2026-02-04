# Урок 26: Продвинутые анимации

## Основные темы

### Staggered анимации (последовательные)
```dart
class StaggeredAnimationDemo extends StatefulWidget {
  @override
  _StaggeredAnimationDemoState createState() => _StaggeredAnimationDemoState();
}

class _StaggeredAnimationDemoState extends State<StaggeredAnimationDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _width;
  late Animation<double> _height;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Interval определяет часть времени анимации
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.3),  // 0-30% времени
      ),
    );

    _width = Tween<double>(begin: 50, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.6),  // 30-60% времени
      ),
    );

    _height = Tween<double>(begin: 50, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1.0),  // 60-100% времени
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Container(
            width: _width.value,
            height: _height.value,
            color: Colors.blue,
          ),
        );
      },
    );
  }
}
```

### Hero анимации
```dart
// Экран списка
class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(index: index),
              ),
            );
          },
          child: Hero(
            tag: 'image-$index',  // Уникальный тег
            child: Image.network(
              'https://picsum.photos/200?random=$index',
              width: 100,
              height: 100,
            ),
          ),
        );
      },
    );
  }
}

// Экран деталей
class DetailScreen extends StatelessWidget {
  final int index;
  DetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'image-$index',  // Тот же тег
          child: Image.network(
            'https://picsum.photos/400?random=$index',
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}
```

### AnimatedList
```dart
class AnimatedListDemo extends StatefulWidget {
  @override
  _AnimatedListDemoState createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  final _listKey = GlobalKey<AnimatedListState>();
  final _items = <String>[];

  void _addItem() {
    final index = _items.length;
    _items.add('Item ${index + 1}');
    _listKey.currentState?.insertItem(index);
  }

  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation),
    );
  }

  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(title: Text(item)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_items[index], animation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### PageView с индикаторами
```dart
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                _buildPage('Добро пожаловать', Colors.blue),
                _buildPage('Возможности', Colors.green),
                _buildPage('Начать', Colors.orange),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.all(4),
                width: _currentPage == index ? 20 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String title, Color color) {
    return Container(
      color: color,
      child: Center(child: Text(title, style: TextStyle(fontSize: 24))),
    );
  }
}
```

### AnimatedSwitcher
```dart
AnimatedSwitcher(
  duration: Duration(milliseconds: 300),
  transitionBuilder: (child, animation) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: animation, child: child),
    );
  },
  child: _showFirst
      ? Icon(Icons.check, key: ValueKey(1), size: 50)
      : Icon(Icons.close, key: ValueKey(2), size: 50),
)
```

### Custom Page Transition
```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return DetailScreen();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 500),
  ),
);
```

### Lottie анимации
```yaml
# pubspec.yaml
dependencies:
  lottie: ^2.7.0
```

```dart
import 'package:lottie/lottie.dart';

// Из assets
Lottie.asset('assets/animations/loading.json')

// Из сети
Lottie.network('https://example.com/animation.json')

// С контролем
LottieBuilder.asset(
  'assets/loading.json',
  controller: _controller,
  onLoaded: (composition) {
    _controller.duration = composition.duration;
  },
)
```

## Ключевые концепции
- **Interval** - для последовательных анимаций
- **Hero** - анимация между экранами
- **AnimatedList** - анимированное добавление/удаление
- **PageRouteBuilder** - кастомные переходы
- **Lottie** - сложные векторные анимации

## Типичные ошибки
- Разные теги Hero на разных экранах
- Отсутствие ключей в AnimatedSwitcher
- Неправильные Interval значения (должны быть 0.0-1.0)
