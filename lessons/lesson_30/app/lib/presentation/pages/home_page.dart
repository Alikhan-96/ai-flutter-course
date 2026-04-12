import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_config.dart';
import '../../core/di/injection.dart';
import '../../domain/models/user.dart';
import '../../domain/usecases/get_users_usecase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Inject dependencies via getIt
  late final GetUsersUseCase _getUsersUseCase;
  late final SharedPreferences _prefs;

  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  String? _lastLaunch;

  @override
  void initState() {
    super.initState();
    // Get dependencies from getIt
    _getUsersUseCase = getIt<GetUsersUseCase>();
    _prefs = getIt<SharedPreferences>();

    // Load last launch time
    _lastLaunch = _prefs.getString('last_launch');

    // Load users on init
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final users = await _getUsersUseCase.execute();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showCreateUserDialog() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _getUsersUseCase.createUser(
                  nameController.text,
                  emailController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result == true) {
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 30: Dependency Injection'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppConfig.useMockApi ? Colors.orange[100] : Colors.green[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      AppConfig.useMockApi ? Icons.bug_report : Icons.cloud,
                      color: AppConfig.useMockApi ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppConfig.useMockApi ? 'Debug Mode - Using Mock API' : 'Release Mode - Using Real API',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (_lastLaunch != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Last launch: $_lastLaunch',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),

          // Users list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(_error!, textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadUsers,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _users.isEmpty
                        ? const Center(child: Text('No users found'))
                        : RefreshIndicator(
                            onRefresh: _loadUsers,
                            child: ListView.builder(
                              itemCount: _users.length,
                              itemBuilder: (context, index) {
                                final user = _users[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(user.name[0].toUpperCase()),
                                  ),
                                  title: Text(user.name),
                                  subtitle: Text(user.email),
                                  trailing: Text('#${user.id}'),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateUserDialog,
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }
}
