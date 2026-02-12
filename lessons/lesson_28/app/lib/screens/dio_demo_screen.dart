import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post.dart';
import '../services/api_service.dart';

/// Экран демонстрации возможностей Dio
class DioDemoScreen extends StatefulWidget {
  const DioDemoScreen({super.key});

  @override
  State<DioDemoScreen> createState() => _DioDemoScreenState();
}

class _DioDemoScreenState extends State<DioDemoScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _imagePicker = ImagePicker();

  List<Post> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  double _uploadProgress = 0.0;
  double _downloadProgress = 0.0;
  CancelToken? _cancelToken;

  @override
  void dispose() {
    // Отменяем запрос при уходе со страницы
    _cancelToken?.cancel('Страница закрыта');
    super.dispose();
  }

  /// Загрузить список постов
  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
      _downloadProgress = 0.0;
      _cancelToken = CancelToken();
    });

    final result = await _apiService.getPosts(
      cancelToken: _cancelToken,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          setState(() {
            _downloadProgress = received / total;
          });
        }
      },
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _cancelToken = null;

      if (result.isSuccess) {
        _posts = result.data ?? [];
        _successMessage = 'Загружено ${_posts.length} постов';
      } else {
        _errorMessage = result.error;
      }
    });
  }

  /// Создать новый пост
  Future<void> _createPost() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
      _uploadProgress = 0.0;
      _cancelToken = CancelToken();
    });

    final newPost = Post(
      id: 0,
      userId: 1,
      title: 'Новый пост ${DateTime.now().millisecondsSinceEpoch}',
      body: 'Это тестовый пост, созданный через Dio',
    );

    final result = await _apiService.createPost(
      newPost,
      cancelToken: _cancelToken,
      onSendProgress: (sent, total) {
        setState(() {
          _uploadProgress = sent / total;
        });
      },
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _cancelToken = null;

      if (result.isSuccess) {
        _successMessage = 'Пост создан: ${result.data?.title}';
        _posts.insert(0, result.data!);
      } else {
        _errorMessage = result.error;
      }
    });
  }

  /// Обновить пост
  Future<void> _updatePost(Post post) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
      _cancelToken = CancelToken();
    });

    final updatedPost = Post(
      id: post.id,
      userId: post.userId,
      title: '${post.title} (обновлено)',
      body: post.body,
    );

    final result = await _apiService.updatePost(
      post.id,
      updatedPost,
      cancelToken: _cancelToken,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _cancelToken = null;

      if (result.isSuccess) {
        _successMessage = 'Пост обновлен';
        final index = _posts.indexWhere((p) => p.id == post.id);
        if (index != -1) {
          _posts[index] = result.data!;
        }
      } else {
        _errorMessage = result.error;
      }
    });
  }

  /// Удалить пост
  Future<void> _deletePost(Post post) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
      _cancelToken = CancelToken();
    });

    final result = await _apiService.deletePost(
      post.id,
      cancelToken: _cancelToken,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _cancelToken = null;

      if (result.isSuccess) {
        _successMessage = 'Пост удален';
        _posts.removeWhere((p) => p.id == post.id);
      } else {
        _errorMessage = result.error;
      }
    });
  }

  /// Загрузить файл (опциональное задание)
  Future<void> _uploadFile() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
      _uploadProgress = 0.0;
      _cancelToken = CancelToken();
    });

    final result = await _apiService.uploadFile(
      image.path,
      cancelToken: _cancelToken,
      onSendProgress: (sent, total) {
        setState(() {
          _uploadProgress = sent / total;
        });
      },
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _cancelToken = null;

      if (result.isSuccess) {
        _successMessage = result.data;
      } else {
        _errorMessage = result.error;
      }
    });
  }

  /// Отменить текущий запрос
  void _cancelRequest() {
    _cancelToken?.cancel('Отменено пользователем');
    setState(() {
      _isLoading = false;
      _cancelToken = null;
      _errorMessage = 'Запрос отменен пользователем';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio HTTP Client Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Панель управления
          _buildControlPanel(),

          // Индикатор загрузки
          if (_isLoading) _buildLoadingIndicator(),

          // Сообщения
          if (_errorMessage != null) _buildErrorMessage(),
          if (_successMessage != null) _buildSuccessMessage(),

          // Список постов
          Expanded(
            child: _posts.isEmpty
                ? const Center(
                    child: Text('Нажмите "Загрузить посты"'),
                  )
                : ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      return _buildPostCard(_posts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _loadPosts,
                  icon: const Icon(Icons.download),
                  label: const Text('Загрузить посты'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _createPost,
                  icon: const Icon(Icons.add),
                  label: const Text('Создать пост'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _uploadFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Загрузить файл'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? _cancelRequest : null,
                  icon: const Icon(Icons.cancel),
                  label: const Text('Отменить'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 8),
          const Text('Загрузка...'),
          if (_uploadProgress > 0)
            Column(
              children: [
                const SizedBox(height: 8),
                LinearProgressIndicator(value: _uploadProgress),
                Text('Отправка: ${(_uploadProgress * 100).toInt()}%'),
              ],
            ),
          if (_downloadProgress > 0)
            Column(
              children: [
                const SizedBox(height: 8),
                LinearProgressIndicator(value: _downloadProgress),
                Text('Получение: ${(_downloadProgress * 100).toInt()}%'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => setState(() => _errorMessage = null),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _successMessage!,
              style: const TextStyle(color: Colors.green),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => setState(() => _successMessage = null),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          post.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          post.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CircleAvatar(
          child: Text('${post.id}'),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'update',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Обновить'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Удалить', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'update') {
              _updatePost(post);
            } else if (value == 'delete') {
              _deletePost(post);
            }
          },
        ),
      ),
    );
  }
}
