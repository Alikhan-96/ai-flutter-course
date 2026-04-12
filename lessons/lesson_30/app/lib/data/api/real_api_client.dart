import 'api_client.dart';

/// Real implementation of API client
/// In a real app, this would use http or dio to make actual API calls
class RealApiClient implements ApiClient {
  // In a real implementation, you would have:
  // final String baseUrl;
  // final http.Client client;

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // In real implementation:
    // final response = await client.get(Uri.parse('$baseUrl/users'));
    // if (response.statusCode == 200) {
    //   return jsonDecode(response.body);
    // }
    // throw Exception('Failed to load users');

    return [
      {'id': 1, 'name': 'Real User 1', 'email': 'real1@api.com'},
      {'id': 2, 'name': 'Real User 2', 'email': 'real2@api.com'},
    ];
  }

  @override
  Future<Map<String, dynamic>> getUserById(int id) async {
    await Future.delayed(const Duration(seconds: 1));

    // In real implementation:
    // final response = await client.get(Uri.parse('$baseUrl/users/$id'));
    // if (response.statusCode == 200) {
    //   return jsonDecode(response.body);
    // }
    // throw Exception('Failed to load user');

    return {'id': id, 'name': 'Real User $id', 'email': 'real$id@api.com'};
  }

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user) async {
    await Future.delayed(const Duration(seconds: 1));

    // In real implementation:
    // final response = await client.post(
    //   Uri.parse('$baseUrl/users'),
    //   body: jsonEncode(user),
    // );
    // if (response.statusCode == 201) {
    //   return jsonDecode(response.body);
    // }
    // throw Exception('Failed to create user');

    return {'id': 99, ...user, 'createdAt': DateTime.now().toIso8601String()};
  }
}
