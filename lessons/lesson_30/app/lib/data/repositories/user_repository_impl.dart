import '../../domain/models/user.dart';
import '../api/api_client.dart';
import 'user_repository.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;

  UserRepositoryImpl(this._apiClient);

  @override
  Future<List<User>> getUsers() async {
    try {
      final usersJson = await _apiClient.getUsers();
      return usersJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<User> getUserById(int id) async {
    try {
      final userJson = await _apiClient.getUserById(id);
      return User.fromJson(userJson);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<User> createUser(String name, String email) async {
    try {
      final userJson = await _apiClient.createUser({
        'name': name,
        'email': email,
      });
      return User.fromJson(userJson);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
}
