import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/storage/secure_storage_service.dart';

/// Settings page demonstrating locale switching and secure storage
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storage = SecureStorageService();
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  String? _currentToken;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    setState(() => _isLoading = true);
    try {
      final token = await _storage.getAuthToken();
      final username = await _storage.getUsername();
      setState(() {
        _currentToken = token;
        _username = username;
        if (token != null) {
          _tokenController.text = token;
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveToken() async {
    if (_tokenController.text.isEmpty) {
      _showMessage('Please enter a token');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _storage.saveAuthToken(_tokenController.text);
      await _storage.saveUsername('demo_user@example.com');
      await _loadStoredData();
      if (mounted) {
        _showMessage('Token saved securely!');
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Error saving token: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _clearStorage() async {
    setState(() => _isLoading = true);
    try {
      await _storage.clearAll();
      _tokenController.clear();
      await _loadStoredData();
      if (mounted) {
        _showMessage('Storage cleared!');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Language section
                _Section(
                  icon: Icons.language,
                  title: l10n.language,
                  child: Column(
                    children: [
                      _LocaleOption(
                        locale: const Locale('en'),
                        title: 'English',
                        subtitle: 'Change to English',
                      ),
                      const Divider(),
                      _LocaleOption(
                        locale: const Locale('ru'),
                        title: 'Русский',
                        subtitle: 'Переключить на русский',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Secure storage section
                _Section(
                  icon: Icons.security,
                  title: l10n.security,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_currentToken != null) ...[
                        ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green),
                          title: Text('${l10n.authToken} Stored'),
                          subtitle: Text(_currentToken!),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: _clearStorage,
                          ),
                        ),
                        if (_username != null)
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Username'),
                            subtitle: Text(_username!),
                          ),
                        const Divider(),
                      ],
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Demo: ${l10n.authToken}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _tokenController,
                              decoration: InputDecoration(
                                labelText: 'Enter token',
                                hintText: 'e.g., abc123xyz',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _tokenController.clear(),
                                ),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _saveToken,
                                    icon: const Icon(Icons.save),
                                    label: Text(l10n.save),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                if (_currentToken != null)
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _clearStorage,
                                      icon: const Icon(Icons.delete),
                                      label: Text(l10n.logout),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 20, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Uses flutter_secure_storage to securely store tokens on iOS Keychain and Android KeyStore',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _Section({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _LocaleOption extends StatelessWidget {
  final Locale locale;
  final String title;
  final String subtitle;

  const _LocaleOption({
    required this.locale,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return ListTile(
      leading: Icon(
        isSelected ? Icons.check_circle : Icons.circle_outlined,
        color: isSelected ? Colors.green : null,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected ? const Chip(label: Text('Active')) : null,
      onTap: () {
        // In a real app, you would use a state management solution
        // to change the locale app-wide. For this demo, we'll show a message.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Locale switching would require app restart or state management. '
              'Current locale: ${currentLocale.languageCode}',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      },
    );
  }
}
