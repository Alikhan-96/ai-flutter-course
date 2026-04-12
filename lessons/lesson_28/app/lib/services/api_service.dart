import 'package:dio/dio.dart';
import '../models/post.dart';
import 'dio_client.dart';

/// Результат API запроса с типизированными ошибками
class ApiResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResult.success(this.data)
      : error = null,
        isSuccess = true;

  ApiResult.failure(this.error)
      : data = null,
        isSuccess = false;
}

/// Сервис для работы с API
class ApiService {
  final Dio _dio = DioClient().client;

  /// Получить список постов с возможностью отмены
  Future<ApiResult<List<Post>>> getPosts({
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        '/posts',
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      final List<dynamic> jsonList = response.data;
      final posts = jsonList.map((json) => Post.fromJson(json)).toList();

      return ApiResult.success(posts);
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Неизвестная ошибка: $e');
    }
  }

  /// Получить пост по ID
  Future<ApiResult<Post>> getPost(
    int id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        '/posts/$id',
        cancelToken: cancelToken,
      );

      final post = Post.fromJson(response.data);
      return ApiResult.success(post);
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Неизвестная ошибка: $e');
    }
  }

  /// Создать новый пост
  Future<ApiResult<Post>> createPost(
    Post post, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        '/posts',
        data: post.toJson(),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      final newPost = Post.fromJson(response.data);
      return ApiResult.success(newPost);
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Неизвестная ошибка: $e');
    }
  }

  /// Обновить пост
  Future<ApiResult<Post>> updatePost(
    int id,
    Post post, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        '/posts/$id',
        data: post.toJson(),
        cancelToken: cancelToken,
      );

      final updatedPost = Post.fromJson(response.data);
      return ApiResult.success(updatedPost);
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Неизвестная ошибка: $e');
    }
  }

  /// Удалить пост
  Future<ApiResult<bool>> deletePost(
    int id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        '/posts/$id',
        cancelToken: cancelToken,
      );

      return ApiResult.success(response.statusCode == 200);
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Неизвестная ошибка: $e');
    }
  }

  /// Загрузка файла/изображения (опциональное задание)
  Future<ApiResult<String>> uploadFile(
    String filePath, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      // Примечание: JSONPlaceholder не поддерживает загрузку файлов,
      // но демонстрируем API
      await _dio.post(
        '/posts', // В реальном API это был бы /upload или подобный endpoint
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      return ApiResult.success('Файл загружен: $fileName');
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Ошибка загрузки файла: $e');
    }
  }

  /// Обработка ошибок с разными сообщениями для разных статус-кодов
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '⏱️ Превышено время ожидания. Проверьте подключение к интернету.';

      case DioExceptionType.connectionError:
        return '🌐 Нет подключения к интернету. Проверьте сетевые настройки.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return '❌ Неверный запрос (400). Проверьте данные.';
          case 401:
            return '🔒 Требуется авторизация (401). Войдите в систему.';
          case 403:
            return '🚫 Доступ запрещен (403). У вас нет прав.';
          case 404:
            return '🔍 Ресурс не найден (404).';
          case 500:
            return '🔥 Ошибка сервера (500). Попробуйте позже.';
          case 502:
            return '🔥 Сервер недоступен (502). Попробуйте позже.';
          case 503:
            return '🔥 Сервис временно недоступен (503). Попробуйте позже.';
          default:
            return '❌ Ошибка сервера ($statusCode). Попробуйте позже.';
        }

      case DioExceptionType.cancel:
        return '🚫 Запрос был отменен.';

      case DioExceptionType.badCertificate:
        return '🔐 Проблема с сертификатом безопасности.';

      case DioExceptionType.unknown:
        return '❓ Неизвестная ошибка. Попробуйте позже.';
    }
  }
}
