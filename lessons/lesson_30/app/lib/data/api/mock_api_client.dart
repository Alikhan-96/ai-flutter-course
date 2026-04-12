import 'api_client.dart';

/// Mock implementation of API client for testing/debug
class MockApiClient implements ApiClient {
  final List<Map<String, dynamic>> _mockUsers = [
    {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'},
    {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com'},
    {'id': 3, 'name': 'Bob Johnson', 'email': 'bob@example.com'},
  ];

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_mockUsers);
  }

  @override
  Future<Map<String, dynamic>> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = _mockUsers.firstWhere(
      (u) => u['id'] == id,
      orElse: () => throw Exception('User not found'),
    );
    return Map.from(user);
  }

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newUser = {
      'id': _mockUsers.length + 1,
      ...user,
    };
    _mockUsers.add(newUser);
    return Map.from(newUser);
  }
}
