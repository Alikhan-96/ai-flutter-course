import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Шаг 2: Модель данных для Post
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // Конструктор для создания объекта из JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

// Шаг 3-4: Асинхронная функция для получения данных
Future<List<Post>> fetchPosts() async {
  try {
    // Выполняем GET-запрос
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    // Проверяем успешность запроса
    if (response.statusCode == 200) {
      // Декодируем JSON
      final List<dynamic> jsonData = jsonDecode(response.body);

      // Преобразуем в список объектов Post
      return jsonData.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось загрузить посты. Код: ${response.statusCode}');
    }
  } catch (e) {
    // Пробрасываем исключение для обработки в UI
    throw Exception('Ошибка сети: $e');
  }
}

// Шаг 5-8: StatefulWidget для отображения постов
class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  // Список постов
  List<Post> posts = [];

  // Флаг загрузки
  bool isLoading = true;

  // Сообщение об ошибке
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Вызываем загрузку данных при инициализации
    loadPosts();
  }

  // Метод загрузки постов с обработкой ошибок
  Future<void> loadPosts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedPosts = await fetchPosts();

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список постов'),
        backgroundColor: Colors.blue,
        actions: [
          // Кнопка обновления
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadPosts,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  // Метод для построения тела страницы
  Widget _buildBody() {
    // Шаг 6: Показываем индикатор загрузки
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Шаг 8: Показываем ошибку, если она есть
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Ошибка загрузки',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: loadPosts,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    // Шаг 7: Показываем список постов
    if (posts.isEmpty) {
      return const Center(
        child: Text('Нет доступных постов'),
      );
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                '${post.id}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Можно добавить переход на детальную страницу
              _showPostDetail(post);
            },
          ),
        );
      },
    );
  }

  // Дополнительно: показ детальной информации о посте
  void _showPostDetail(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Пост #${post.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Заголовок:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(post.title),
              const SizedBox(height: 16),
              const Text(
                'Содержание:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(post.body),
              const SizedBox(height: 16),
              Text('User ID: ${post.userId}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}
