import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/app_user.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    final appUser = AppUser.fromFirebaseUser(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showSignOutDialog(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User avatar
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                backgroundImage:
                    appUser.photoURL != null ? NetworkImage(appUser.photoURL!) : null,
                child: appUser.photoURL == null
                    ? Text(
                        appUser.initials,
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      )
                    : null,
              ),
              const SizedBox(height: 24),

              // Welcome message
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              if (appUser.displayName != null)
                Text(
                  appUser.displayName!,
                  style: const TextStyle(fontSize: 20),
                ),
              if (appUser.email != null)
                Text(
                  appUser.email!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              const SizedBox(height: 32),

              // User info cards
              Card(
                child: ListTile(
                  leading: Icon(Icons.verified_user,
                      color: appUser.emailVerified ? Colors.green : Colors.orange),
                  title: const Text('Email Verification'),
                  subtitle: Text(appUser.emailVerified ? 'Verified' : 'Not verified'),
                  trailing: !appUser.emailVerified
                      ? TextButton(
                          onPressed: () => _sendVerificationEmail(context),
                          child: const Text('Verify'),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.fingerprint, color: Colors.blue),
                  title: const Text('User ID'),
                  subtitle: Text(
                    appUser.uid,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Action buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  ),
                  icon: const Icon(Icons.person),
                  label: const Text('View Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendVerificationEmail(BuildContext context) async {
    try {
      await AuthService().sendEmailVerification();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent! Check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showSignOutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      await AuthService().signOut();
    }
  }
}
