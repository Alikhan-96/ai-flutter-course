// home_screen.dart
import 'package:flutter/material.dart';

import '../database/database.dart';
import '../services/json_service.dart';
import 'tags_tab.dart';
import 'tasks_tab.dart';

class HomeScreen extends StatefulWidget {
  final AppDatabase db;
  const HomeScreen({super.key, required this.db});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // JSON export / import actions
  // ---------------------------------------------------------------------------

  Future<void> _export() async {
    try {
      final path = await JsonService.exportToJson(widget.db);
      if (!mounted) return;
      _showSnack('Exported to:\n$path');
    } catch (e) {
      if (!mounted) return;
      _showSnack('Export failed: $e', isError: true);
    }
  }

  Future<void> _import() async {
    try {
      final msg = await JsonService.importFromJson(widget.db);
      if (!mounted) return;
      _showSnack(msg);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Import failed: $e', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : null,
      duration: const Duration(seconds: 4),
    ));
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager · Drift'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'More options',
            onSelected: (v) {
              if (v == 'export') _export();
              if (v == 'import') _import();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.upload_file),
                  title: Text('Export to JSON'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Import from JSON'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.task_alt), text: 'Tasks'),
            Tab(icon: Icon(Icons.label_outline), text: 'Tags'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TasksTab(db: widget.db),
          TagsTab(db: widget.db),
        ],
      ),
    );
  }
}
