# Урок 10: Базовые виджеты Flutter

## Основные темы

### Виджет Text
```dart
Text(
  'Добро пожаловать во Flutter!',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  textAlign: TextAlign.center,
)
```

### Виджет Image
```dart
// Изображение из интернета
Image.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)

// Изображение из assets
Image.asset('assets/images/logo.png')

// С placeholder при загрузке
Image.network(
  'https://example.com/image.jpg',
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return CircularProgressIndicator();
  },
)
```

### Виджет ElevatedButton
```dart
ElevatedButton(
  onPressed: () {
    print('Кнопка нажата!');
  },
  child: Text('Нажми меня'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  ),
)
```

### Виджет Column
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text('Первый элемент'),
    SizedBox(height: 20),
    Text('Второй элемент'),
    SizedBox(height: 20),
    ElevatedButton(
      onPressed: () {},
      child: Text('Кнопка'),
    ),
  ],
)
```

### Виджет Padding
```dart
Padding(
  padding: EdgeInsets.all(16.0),
  child: Text('Текст с отступами'),
)

// Разные отступы
Padding(
  padding: EdgeInsets.only(
    left: 10,
    right: 10,
    top: 20,
    bottom: 5,
  ),
  child: Container(),
)

// Симметричные отступы
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
  child: Container(),
)
```

### Виджет Center
```dart
Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Центрированный контент'),
      Image.network('https://example.com/image.jpg'),
      ElevatedButton(
        onPressed: () {},
        child: Text('Кнопка'),
      ),
    ],
  ),
)
```

### Полный пример экрана
```dart
Scaffold(
  appBar: AppBar(title: Text('Мой экран')),
  body: Center(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Добро пожаловать!'),
          SizedBox(height: 20),
          Image.network('https://picsum.photos/200'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => print('Нажато!'),
            child: Text('Нажми'),
          ),
        ],
      ),
    ),
  ),
)
```

## Ключевые концепции
- **Column** - вертикальное расположение
- **Row** - горизонтальное расположение
- **SizedBox** - пустое пространство между виджетами
- **EdgeInsets** - настройка отступов

## Типичные ошибки
- Забытый SizedBox между элементами Column/Row
- Неправильное использование fit для Image
- Column внутри Column без ограничения высоты
