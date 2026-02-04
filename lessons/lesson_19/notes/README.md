# Урок 19: Работа с изображениями и Assets

## Основные темы

### Настройка assets в pubspec.yaml
```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    # или конкретные файлы
    - assets/images/logo.png
    - assets/images/background.jpg
```

### Структура папок
```
project/
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── photo1.jpg
│   │   └── photo2.jpg
│   └── icons/
│       └── app_icon.png
├── lib/
│   └── main.dart
└── pubspec.yaml
```

### Локальные изображения
```dart
// Image.asset для локальных файлов
Image.asset(
  'assets/images/logo.png',
  width: 200,
  height: 200,
  fit: BoxFit.contain,
)

// С обработкой ошибок
Image.asset(
  'assets/images/photo.jpg',
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error, size: 50);
  },
)
```

### Сетевые изображения
```dart
// Image.network для изображений из интернета
Image.network(
  'https://picsum.photos/400/300',
  width: 400,
  height: 300,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.broken_image, size: 50);
  },
)
```

### Иконки
```dart
// Встроенные Material Icons
Icon(
  Icons.favorite,
  size: 30,
  color: Colors.red,
)

// Иконка в кнопке
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () {},
)
```

### GridView - сетка изображений
```dart
GridView.count(
  crossAxisCount: 2,  // 2 колонки
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
  padding: EdgeInsets.all(8),
  children: [
    _buildImageCard('assets/images/photo1.jpg'),
    _buildImageCard('assets/images/photo2.jpg'),
    _buildImageCard('assets/images/photo3.jpg'),
    _buildImageCard('assets/images/photo4.jpg'),
  ],
)

Widget _buildImageCard(String path) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.asset(
      path,
      fit: BoxFit.cover,
    ),
  );
}
```

### GridView.builder для динамических данных
```dart
final List<String> imageUrls = [
  'https://picsum.photos/200/200?random=1',
  'https://picsum.photos/200/200?random=2',
  'https://picsum.photos/200/200?random=3',
  'https://picsum.photos/200/200?random=4',
];

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemCount: imageUrls.length,
  itemBuilder: (context, index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrls[index],
        fit: BoxFit.cover,
      ),
    );
  },
)
```

### Полный пример галереи
```dart
class GalleryScreen extends StatelessWidget {
  final List<String> images = [
    'https://picsum.photos/300/300?random=1',
    'https://picsum.photos/300/300?random=2',
    'https://picsum.photos/300/300?random=3',
    'https://picsum.photos/300/300?random=4',
    'https://picsum.photos/300/300?random=5',
    'https://picsum.photos/300/300?random=6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Галерея'),
        leading: Icon(Icons.image),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: images.map((url) {
            return Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                url,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
```

## Ключевые концепции
- **Image.asset** - локальные изображения
- **Image.network** - изображения из интернета
- **BoxFit** - как изображение заполняет контейнер
- **GridView** - сетка элементов
- **ClipRRect** - скругление углов

## BoxFit варианты
- **cover** - заполняет, может обрезать
- **contain** - вписывает полностью
- **fill** - растягивает до размера
- **fitWidth** - подгоняет по ширине
- **fitHeight** - подгоняет по высоте

## Типичные ошибки
- Не прописан путь в pubspec.yaml
- Забытый flutter pub get после изменения assets
- Неправильный путь к файлу
