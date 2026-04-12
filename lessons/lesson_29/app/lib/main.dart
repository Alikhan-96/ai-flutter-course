// main.dart — Lesson 29: Drift SQLite local database
// Run `flutter pub run build_runner build` before first launch.
import 'package:flutter/material.dart';

import 'database/database.dart';
import 'screens/home_screen.dart';

/// Global database instance (single connection, alive for app lifetime)
final AppDatabase db = AppDatabase();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager · Drift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(db: db),
    );
  }
}
