// json_service.dart
// Optional homework: export / import tasks & tags as JSON
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/database.dart';

class JsonService {
  static const _fileName = 'tasks_export.json';

  // ---------------------------------------------------------------------------
  // EXPORT
  // ---------------------------------------------------------------------------

  /// Exports all tags and tasks to a JSON file in the app documents directory.
  /// Returns the full path of the written file.
  static Future<String> exportToJson(AppDatabase db) async {
    final tags = await db.getAllTags();
    final taskWithTags = await db.getTasksWithTags();

    final data = {
      'exported_at': DateTime.now().toIso8601String(),
      'tags': tags
          .map((t) => {
                'id': t.id,
                'name': t.name,
                'colorValue': t.colorValue,
              })
          .toList(),
      'tasks': taskWithTags
          .map((twt) => {
                'id': twt.task.id,
                'title': twt.task.title,
                'description': twt.task.description,
                'priority': twt.task.priority,
                'createdAt': twt.task.createdAt.toIso8601String(),
                'dueDate': twt.task.dueDate?.toIso8601String(),
                'isCompleted': twt.task.isCompleted,
                'tagId': twt.task.tagId,
                'notes': twt.task.notes,
              })
          .toList(),
    };

    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, _fileName));
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
    );
    return file.path;
  }

  // ---------------------------------------------------------------------------
  // IMPORT
  // ---------------------------------------------------------------------------

  /// Reads the JSON export file and inserts any missing tags & tasks.
  /// Existing records (same id) are skipped to avoid duplicates.
  /// Returns a summary message.
  static Future<String> importFromJson(AppDatabase db) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, _fileName));

    if (!file.existsSync()) {
      return 'Export file not found at ${file.path}';
    }

    final raw = await file.readAsString();
    final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;

    int tagsImported = 0;
    int tasksImported = 0;

    // Import tags first (tasks reference them)
    final existingTags = await db.getAllTags();
    final existingTagIds = existingTags.map((t) => t.id).toSet();

    for (final t in (data['tags'] as List<dynamic>)) {
      final map = t as Map<String, dynamic>;
      if (!existingTagIds.contains(map['id'] as int)) {
        await db.insertTag(TagsCompanion.insert(
          name: map['name'] as String,
          colorValue: Value(map['colorValue'] as int),
        ));
        tagsImported++;
      }
    }

    // Import tasks
    final existingTasksWithTags = await db.getTasksWithTags();
    final existingTaskIds =
        existingTasksWithTags.map((twt) => twt.task.id).toSet();

    for (final t in (data['tasks'] as List<dynamic>)) {
      final map = t as Map<String, dynamic>;
      if (!existingTaskIds.contains(map['id'] as int)) {
        await db.insertTask(TasksCompanion.insert(
          title: map['title'] as String,
          description: Value(map['description'] as String?),
          priority: Value(map['priority'] as int),
          createdAt: Value(DateTime.parse(map['createdAt'] as String)),
          dueDate: Value(
            map['dueDate'] != null
                ? DateTime.parse(map['dueDate'] as String)
                : null,
          ),
          isCompleted: Value(map['isCompleted'] as bool),
          tagId: Value(map['tagId'] as int?),
          notes: Value(map['notes'] as String? ?? ''),
        ));
        tasksImported++;
      }
    }

    return 'Imported $tagsImported tag(s) and $tasksImported task(s).';
  }

  /// Returns path to export file (may or may not exist yet)
  static Future<String> exportFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, _fileName);
  }
}
