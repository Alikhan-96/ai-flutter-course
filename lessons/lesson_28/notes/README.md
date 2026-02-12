# День 28: HTTP-запросы с Dio

## Обзор

Dio — это мощный HTTP-клиент для Dart/Flutter с поддержкой интерцепторов, глобальной конфигурации, FormData, отмены запросов, загрузки файлов, тайм-аутов и многого другого.

## Основные возможности Dio

### 1. Установка

```yaml
dependencies:
  dio: ^5.4.0
```

### 2. Базовая настройка

```dart
final dio = Dio(
  BaseOptions(
    baseUrl: 'https://api.example.com',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    sendTimeout: Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ),
);
```

### 3. Типы запросов

```dart
// GET запрос
Response response = await dio.get('/posts');

// POST запрос
Response response = await dio.post('/posts', data: {
  'title': 'New Post',
  'body': 'Post content',
});

// PUT запрос
Response response = await dio.put('/posts/1', data: updatedData);

// DELETE запрос
Response response = await dio.delete('/posts/1');
```

## Интерцепторы (Interceptors)

Интерцепторы позволяют перехватывать и изменять запросы и ответы глобально.

### Логирование запросов и ответов

```dart
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST: ${options.method} ${options.uri}');
    print('Headers: ${options.headers}');
    print('Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE: ${response.statusCode}');
    print('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR: ${err.type}');
    print('Message: ${err.message}');
    super.onError(err, handler);
  }
}

// Добавление интерцептора
dio.interceptors.add(LoggingInterceptor());
```

### Retry Interceptor (повторные попытки)

```dart
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor(this.dio, {this.maxRetries = 2});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retry_count'] ?? 0;

      if (retryCount < maxRetries) {
        err.requestOptions.extra['retry_count'] = retryCount + 1;

        // Задержка перед повторной попыткой
        await Future.delayed(Duration(seconds: retryCount + 1));

        try {
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return super.onError(err, handler);
        }
      }
    }
    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError;
  }
}
```

## Обработка ошибок

### Типы ошибок DioException

```dart
String handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Превышено время ожидания';

    case DioExceptionType.connectionError:
      return 'Нет подключения к интернету';

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 400:
          return 'Неверный запрос (400)';
        case 401:
          return 'Требуется авторизация (401)';
        case 403:
          return 'Доступ запрещен (403)';
        case 404:
          return 'Ресурс не найден (404)';
        case 500:
          return 'Ошибка сервера (500)';
        default:
          return 'Ошибка сервера ($statusCode)';
      }

    case DioExceptionType.cancel:
      return 'Запрос отменен';

    default:
      return 'Неизвестная ошибка';
  }
}
```

### Использование в коде

```dart
try {
  final response = await dio.get('/posts');
  return ApiResult.success(response.data);
} on DioException catch (e) {
  return ApiResult.failure(handleError(e));
} catch (e) {
  return ApiResult.failure('Неизвестная ошибка: $e');
}
```

## Отмена запросов (CancelToken)

CancelToken позволяет отменить запрос до его завершения.

### Создание и использование

```dart
class MyWidgetState extends State<MyWidget> {
  CancelToken? _cancelToken;

  Future<void> loadData() async {
    // Создаем новый токен
    _cancelToken = CancelToken();

    try {
      final response = await dio.get(
        '/posts',
        cancelToken: _cancelToken,
      );
      // Обработка ответа
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        print('Запрос отменен');
      }
    }
  }

  void cancelRequest() {
    _cancelToken?.cancel('Отменено пользователем');
  }

  @override
  void dispose() {
    // Отменяем запрос при уничтожении виджета
    _cancelToken?.cancel('Виджет уничтожен');
    super.dispose();
  }
}
```

## Прогресс загрузки/отправки

### Отслеживание прогресса загрузки

```dart
await dio.get(
  '/large-file',
  onReceiveProgress: (received, total) {
    if (total != -1) {
      final progress = received / total;
      print('Загружено: ${(progress * 100).toStringAsFixed(0)}%');
    }
  },
);
```

### Отслеживание прогресса отправки

```dart
await dio.post(
  '/upload',
  data: formData,
  onSendProgress: (sent, total) {
    final progress = sent / total;
    print('Отправлено: ${(progress * 100).toStringAsFixed(0)}%');
  },
);
```

## Загрузка файлов

### Отправка файла через FormData

```dart
Future<void> uploadFile(String filePath) async {
  final fileName = filePath.split('/').last;

  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      filePath,
      filename: fileName,
    ),
    'description': 'File description',
  });

  try {
    final response = await dio.post(
      '/upload',
      data: formData,
      onSendProgress: (sent, total) {
        print('Прогресс: ${(sent / total * 100).toStringAsFixed(0)}%');
      },
    );
    print('Файл загружен: ${response.data}');
  } on DioException catch (e) {
    print('Ошибка загрузки: ${handleError(e)}');
  }
}
```

### Выбор изображения с ImagePicker

```dart
final ImagePicker _picker = ImagePicker();

Future<void> pickAndUploadImage() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image != null) {
    await uploadFile(image.path);
  }
}
```

## Архитектура приложения

### Singleton паттерн для Dio клиента

```dart
class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(BaseOptions(/* ... */));
    dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.add(RetryInterceptor(dio));
  }

  Dio get client => dio;
}
```

### API Service с типизацией

```dart
class ApiResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResult.success(this.data) : error = null, isSuccess = true;
  ApiResult.failure(this.error) : data = null, isSuccess = false;
}

class ApiService {
  final Dio _dio = DioClient().client;

  Future<ApiResult<List<Post>>> getPosts({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get('/posts', cancelToken: cancelToken);
      final posts = (response.data as List)
          .map((json) => Post.fromJson(json))
          .toList();
      return ApiResult.success(posts);
    } on DioException catch (e) {
      return ApiResult.failure(handleError(e));
    }
  }
}
```

## Best Practices

### 1. Тайм-ауты
- Всегда устанавливайте `connectTimeout`, `receiveTimeout`, `sendTimeout`
- Типичные значения: 10-30 секунд

### 2. Обработка ошибок
- Обрабатывайте все типы `DioException`
- Показывайте понятные сообщения пользователю
- Различайте сетевые ошибки и ошибки сервера

### 3. Отмена запросов
- Отменяйте запросы в `dispose()` виджета
- Используйте один `CancelToken` на операцию
- Проверяйте `mounted` перед вызовом `setState()`

### 4. Интерцепторы
- Используйте для логирования в debug режиме
- Реализуйте retry для нестабильных сетей
- Добавляйте токены авторизации глобально

### 5. Загрузка файлов
- Показывайте прогресс для больших файлов
- Используйте `MultipartFile` для отправки
- Обрабатывайте ошибки загрузки отдельно

### 6. Производительность
- Переиспользуйте один экземпляр Dio (Singleton)
- Не создавайте новый Dio для каждого запроса
- Используйте `isolate` для больших JSON-ответов

## Сравнение с другими HTTP-клиентами

| Возможность | dio | http | http (with interceptor_http) |
|------------|-----|------|------------------------------|
| Интерцепторы | ✅ | ❌ | ✅ |
| CancelToken | ✅ | ❌ | ❌ |
| Progress tracking | ✅ | ❌ | ❌ |
| FormData/File upload | ✅ | ⚠️ (сложнее) | ⚠️ (сложнее) |
| Retry mechanism | ✅ | ❌ | ✅ |
| Тайм-ауты | ✅ | ✅ | ✅ |
| BaseURL | ✅ | ⚠️ (ручная) | ⚠️ (ручная) |

## Пример: Полный workflow

```dart
// 1. Настройка клиента (один раз при запуске)
final dioClient = DioClient();

// 2. Создание сервиса
final apiService = ApiService();

// 3. Использование в виджете
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  CancelToken? _cancelToken;
  bool _isLoading = false;
  List<Post> _posts = [];
  String? _error;

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _cancelToken = CancelToken();
    });

    final result = await apiService.getPosts(
      cancelToken: _cancelToken,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _cancelToken = null;

      if (result.isSuccess) {
        _posts = result.data ?? [];
      } else {
        _error = result.error;
      }
    });
  }

  @override
  void dispose() {
    _cancelToken?.cancel('Screen disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? CircularProgressIndicator()
          : _error != null
              ? Text('Error: $_error')
              : ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(_posts[index].title));
                  },
                ),
    );
  }
}
```

## Задание (Homework 28)

### Обязательные задачи:

1. ✅ Создать Dio-клиент с `baseUrl`, `timeouts` и логированием через `Interceptors`
2. ✅ Реализовать обработку ошибок с разными сообщениями для 400/401/500 и отсутствия сети
3. ✅ Реализовать отмену запроса (`CancelToken`) при уходе со страницы (`dispose`)

### Опциональные задачи:

4. ✅ Добавить retry на сетевые ошибки (1-2 попытки) и прогресс-индикатор загрузки
5. ✅ Реализовать загрузку файла/изображения с `onReceiveProgress`

## Полезные ссылки

- [Dio Documentation](https://pub.dev/packages/dio)
- [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) - тестовый API
- [HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
- [Image Picker Package](https://pub.dev/packages/image_picker)

## Заключение

Dio — это мощный и гибкий HTTP-клиент для Flutter, который предоставляет все необходимые возможности для работы с сетевыми запросами в реальных приложениях:

- 🔧 Гибкая настройка через интерцепторы
- 🚫 Отмена запросов для лучшего UX
- 📊 Отслеживание прогресса загрузки/отправки
- 🔄 Автоматические повторные попытки
- ⚠️ Детальная обработка ошибок
- 📁 Простая загрузка файлов

Правильное использование Dio повышает надежность и удобство работы с сетью в вашем приложении.
