import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'presentation/pages/home_page.dart';

/// Main entry point
/// Demonstrates async initialization before runApp
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies (async initialization)
  print('🚀 Initializing dependencies...');
  await initializeDependencies();
  print('✅ Dependencies initialized successfully!');

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson 30: Dependency Injection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
