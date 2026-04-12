import 'package:flutter/material.dart';

void main() {
  runApp(const ReleaseChecklistApp());
}

class ReleaseChecklistApp extends StatelessWidget {
  const ReleaseChecklistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Release Ready',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE76F51)),
      ),
      home: const ReleaseChecklistPage(),
    );
  }
}

class ReleaseChecklistPage extends StatelessWidget {
  const ReleaseChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    const releaseChecks = <String>[
      'Android versionName/versionCode updated to 1.1.0+2',
      'Release signing template added for Android keystore setup',
      'Launcher icon and native splash configs prepared',
      'Permissions and privacy review documented',
      'Internal testing rollout plan prepared',
      'Release bugs, risks, and rollback plan documented',
    ];

    const smokeTests = <String>[
      'Login / auth flow',
      'Primary task creation flow',
      'Offline / error handling',
      'Notification behavior if enabled',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lesson 42: Release Checklist')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This lesson packages the app for release readiness: versioning, '
                'Android signing, icon and splash setup, permissions review, '
                'internal testing, and rollback planning.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Completed homework items',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...releaseChecks.map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.verified_outlined),
                title: Text(item),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Release smoke test',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...smokeTests.map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.fact_check_outlined),
                title: Text(item),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: const ListTile(
              leading: Icon(Icons.rocket_launch_outlined),
              title: Text('Next release command'),
              subtitle: Text('flutter build appbundle --release'),
            ),
          ),
        ],
      ),
    );
  }
}
