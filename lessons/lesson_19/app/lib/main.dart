import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GalleryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  // Список локальных изображений
  final List<String> localImages = const [
    'assets/images/pexels-blank-1868502_1280.jpg',
    'assets/images/publicdomainpictures-boss-2205_1280.jpg',
  ];

  // Список URL изображений из интернета
  final List<String> networkImages = const [
    'https://picsum.photos/400/400?random=1',
    'https://picsum.photos/400/400?random=2',
    'https://picsum.photos/400/400?random=3',
    'https://picsum.photos/400/400?random=4',
    'https://picsum.photos/400/400?random=5',
    'https://picsum.photos/400/400?random=6',
    'https://picsum.photos/400/400?random=7',
    'https://picsum.photos/400/400?random=8',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Галерея изображений'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Иконка в AppBar
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Галерея изображений')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок секции
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Сетевые изображения',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Одиночное изображение из сети
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Image.network():',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://picsum.photos/600/300',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: Icon(Icons.error, size: 50, color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Заголовок секции локальных изображений
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Локальные изображения',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Одиночное изображение из assets
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Image.asset():',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/pexels-blank-1868502_1280.jpg',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: Icon(Icons.error, size: 50, color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Секция с иконками
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Иконки (Icon):',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildIconWithLabel(Icons.image, 'Изображение', Colors.blue),
                          _buildIconWithLabel(Icons.photo_library, 'Галерея', Colors.green),
                          _buildIconWithLabel(Icons.camera_alt, 'Камера', Colors.orange),
                          _buildIconWithLabel(Icons.favorite, 'Избранное', Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Заголовок галереи
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Галерея (GridView)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // GridView с изображениями (локальные + сетевые)
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Локальные изображения
                  ...localImages.map((path) {
                    return _buildGalleryItem(context, path, isAsset: true);
                  }).toList(),
                  // Сетевые изображения
                  ...networkImages.map((url) {
                    return _buildGalleryItem(context, url, isAsset: false);
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithLabel(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildGalleryItem(BuildContext context, String imagePath, {required bool isAsset}) {
    return GestureDetector(
      onTap: () {
        // Открытие изображения на весь экран
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImage(imagePath: imagePath, isAsset: isAsset),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: isAsset
              ? Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      ),
                    );
                  },
                )
              : Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

// Экран полноэкранного изображения
class FullScreenImage extends StatelessWidget {
  final String imagePath;
  final bool isAsset;

  const FullScreenImage({
    Key? key,
    required this.imagePath,
    required this.isAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Просмотр'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: isAsset
              ? Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                )
              : Image.network(
                  imagePath,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
