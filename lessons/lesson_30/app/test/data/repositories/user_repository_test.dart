import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/data/api/api_client.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/data/repositories/user_repository_impl.dart';
import 'package:app/domain/models/user.dart';

/// Mock API Client for testing
class TestMockApiClient implements ApiClient {
  final List<Map<String, dynamic>> _testUsers = [
    {'id': 1, 'name': 'Test User 1', 'email': 'test1@test.com'},
    {'id': 2, 'name': 'Test User 2', 'email': 'test2@test.com'},
  ];

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    return _testUsers;
  }

  @override
  Future<Map<String, dynamic>> getUserById(int id) async {
    return _testUsers.firstWhere(
      (u) => u['id'] == id,
      orElse: () => throw Exception('User not found'),
    );
  }

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user) async {
    final newUser = {'id': 999, ...user};
    _testUsers.add(newUser);
    return newUser;
  }
}

/// Another mock API client with different data
class AnotherMockApiClient implements ApiClient {
  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    return [
      {'id': 100, 'name': 'Different User', 'email': 'different@test.com'},
    ];
  }

  @override
  Future<Map<String, dynamic>> getUserById(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user) async {
    throw UnimplementedError();
  }
}

void main() {
  group('UserRepository Tests with Dependency Injection', () {
    setUp(() async {
      // Reset get_it before each test
      await getIt.reset();

      // Register test dependencies
      getIt.registerSingleton<ApiClient>(TestMockApiClient());
      getIt.registerSingleton<UserRepository>(
        UserRepositoryImpl(getIt<ApiClient>()),
      );
    });

    tearDown(() async {
      // Clean up after each test
      await getIt.reset();
    });

    test('should get list of users from repository', () async {
      // Arrange
      final repository = getIt<UserRepository>();

      // Act
      final users = await repository.getUsers();

      // Assert
      expect(users, isA<List<User>>());
      expect(users.length, 2);
      expect(users[0].name, 'Test User 1');
      expect(users[1].email, 'test2@test.com');
    });

    test('should get user by id', () async {
      // Arrange
      final repository = getIt<UserRepository>();

      // Act
      final user = await repository.getUserById(1);

      // Assert
      expect(user, isA<User>());
      expect(user.id, 1);
      expect(user.name, 'Test User 1');
    });

    test('should throw exception when user not found', () async {
      // Arrange
      final repository = getIt<UserRepository>();

      // Act & Assert
      expect(
        () => repository.getUserById(999),
        throwsA(isA<Exception>()),
      );
    });

    test('should create new user', () async {
      // Arrange
      final repository = getIt<UserRepository>();

      // Act
      final newUser = await repository.createUser('New User', 'new@test.com');

      // Assert
      expect(newUser, isA<User>());
      expect(newUser.id, 999);
      expect(newUser.name, 'New User');
      expect(newUser.email, 'new@test.com');
    });

    test('should use injected dependencies from get_it', () async {
      // Arrange
      final apiClient = getIt<ApiClient>();
      final repository = getIt<UserRepository>();

      // Assert - verify dependencies are registered
      expect(apiClient, isA<TestMockApiClient>());
      expect(repository, isA<UserRepositoryImpl>());

      // Act - verify they work together
      final users = await repository.getUsers();
      expect(users.length, 2);
    });

    test('should substitute dependencies in tests', () async {
      // This test demonstrates how we can easily substitute
      // dependencies in tests using get_it

      // Reset and register new mock with different implementation
      await getIt.reset();
      getIt.registerSingleton<ApiClient>(AnotherMockApiClient());
      getIt.registerSingleton<UserRepository>(
        UserRepositoryImpl(getIt<ApiClient>()),
      );

      // Act
      final repository = getIt<UserRepository>();
      final users = await repository.getUsers();

      // Assert
      expect(users.length, 1);
      expect(users[0].name, 'Different User');
    });
  });

  group('UserRepository without DI (for comparison)', () {
    test('should work with direct instantiation', () async {
      // Without DI - manual dependency creation
      final apiClient = TestMockApiClient();
      final repository = UserRepositoryImpl(apiClient);

      final users = await repository.getUsers();

      expect(users.length, 2);
      expect(users[0].name, 'Test User 1');
    });
  });
}
