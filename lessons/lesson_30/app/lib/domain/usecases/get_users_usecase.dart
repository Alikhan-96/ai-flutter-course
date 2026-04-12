import '../../data/repositories/user_repository.dart';
import '../models/user.dart';

/// Use case for getting users
/// Encapsulates business logic for fetching users
class GetUsersUseCase {
  final UserRepository _repository;

  GetUsersUseCase(this._repository);

  /// Execute the use case
  Future<List<User>> execute() async {
    try {
      final users = await _repository.getUsers();
      // Business logic: Sort users by name
      users.sort((a, b) => a.name.compareTo(b.name));
      return users;
    } catch (e) {
      throw Exception('Use case error: $e');
    }
  }

  /// Get user by ID
  Future<User> getUserById(int id) async {
    return await _repository.getUserById(id);
  }

  /// Create a new user with validation
  Future<User> createUser(String name, String email) async {
    // Business logic: Validate input
    if (name.isEmpty) {
      throw Exception('Name cannot be empty');
    }
    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    return await _repository.createUser(name, email);
  }
}
