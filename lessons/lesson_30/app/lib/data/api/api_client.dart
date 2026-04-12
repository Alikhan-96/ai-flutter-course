/// Abstract API client interface
abstract class ApiClient {
  /// Fetch users from the API
  Future<List<Map<String, dynamic>>> getUsers();

  /// Fetch user by ID
  Future<Map<String, dynamic>> getUserById(int id);

  /// Create a new user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user);
}
