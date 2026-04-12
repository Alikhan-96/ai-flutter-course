import 'package:dio/dio.dart';

/// Конфигурируемый Dio-клиент с интерцепторами
class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        // Используем JSONPlaceholder для демонстрации
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Добавляем логирующий интерцептор
    dio.interceptors.add(LoggingInterceptor());

    // Добавляем retry интерцептор (опциональное задание)
    dio.interceptors.add(RetryInterceptor(dio));
  }

  Dio get client => dio;
}

/// Интерцептор для логирования запросов и ответов
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 REQUEST: ${options.method} ${options.uri}');
    print('Headers: ${options.headers}');
    if (options.data != null) {
      print('Body: ${options.data}');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📥 RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    print('Data: ${response.data}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('❌ ERROR: ${err.type} ${err.requestOptions.uri}');
    print('Message: ${err.message}');
    if (err.response != null) {
      print('Status: ${err.response?.statusCode}');
      print('Data: ${err.response?.data}');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    super.onError(err, handler);
  }
}

/// Интерцептор для автоматического retry при сетевых ошибках
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor(this.dio, {this.maxRetries = 2});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Retry только для сетевых ошибок и таймаутов
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retry_count'] ?? 0;

      if (retryCount < maxRetries) {
        print('🔄 Retry attempt ${retryCount + 1}/$maxRetries');

        err.requestOptions.extra['retry_count'] = retryCount + 1;

        // Задержка перед повторной попыткой
        await Future.delayed(Duration(seconds: retryCount + 1));

        try {
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          if (e is DioException) {
            return super.onError(e, handler);
          }
          return handler.reject(err);
        }
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
