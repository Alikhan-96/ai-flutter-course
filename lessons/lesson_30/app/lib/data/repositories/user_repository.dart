import '../../domain/models/user.dart';

/// Abstract repository interface for user data
abstract class UserRepository {
  /// Get all users
  Future<List<User>> getUsers();

  /// Get user by ID
  Future<User> getUserById(int id);

  /// Create a new user
  Future<User> createUser(String name, String email);
}
