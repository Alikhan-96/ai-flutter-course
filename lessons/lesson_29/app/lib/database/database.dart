// database.dart
// Drift (formerly Moor) database definition.
// Run `flutter pub run build_runner build` to generate database.g.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ---------------------------------------------------------------------------
// TABLE DEFINITIONS
// ---------------------------------------------------------------------------

/// Tags — labels that can be attached to tasks (one-to-many: one tag → many tasks)
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  // Stored as ARGB int, e.g. 0xFF2196F3 = Material Blue
  IntColumn get colorValue =>
      integer().withDefault(const Constant(0xFF2196F3))();
}

/// Tasks — main entity, optionally linked to a Tag via foreign key
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();

  // 0 = low, 1 = medium, 2 = high
  IntColumn get priority => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dueDate => dateTime().nullable()();

  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();

  // Foreign key → Tags.id  (nullable: a task may have no tag)
  IntColumn get tagId => integer().nullable().references(Tags, #id)();

  // Added in schema v2 via migration from v1
  TextColumn get notes => text().withDefault(const Constant(''))();
}

// ---------------------------------------------------------------------------
// JOIN RESULT
// ---------------------------------------------------------------------------

/// Holds a Task together with its optional Tag (result of a JOIN query)
class TaskWithTag {
  final Task task;
  final Tag? tag;

  const TaskWithTag({required this.task, this.tag});
}

// ---------------------------------------------------------------------------
// DATABASE CONNECTION
// ---------------------------------------------------------------------------

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'lesson29_tasks.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// ---------------------------------------------------------------------------
// DATABASE CLASS
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [Tags, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Schema v1 → v2: added `notes` TEXT column with default ''
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          // Fresh install — create all tables at once
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Existing database being upgraded
          if (from < 2) {
            // v1 → v2: add `notes` column (TEXT, default empty string)
            await m.addColumn(tasks, tasks.notes);
          }
        },
      );

  // -------------------------------------------------------------------------
  // TAGS: CRUD
  // -------------------------------------------------------------------------

  /// Stream: emits updated list whenever tags table changes (reactive UI)
  Stream<List<Tag>> watchAllTags() => select(tags).watch();

  /// Future: one-time read of all tags
  Future<List<Tag>> getAllTags() => select(tags).get();

  Future<int> insertTag(TagsCompanion entry) => into(tags).insert(entry);

  Future<bool> updateTag(Tag tag) => update(tags).replace(tag);

  Future<int> deleteTag(int id) =>
      (delete(tags)..where((t) => t.id.equals(id))).go();

  // -------------------------------------------------------------------------
  // TASKS: CRUD + JOIN + SORT
  // -------------------------------------------------------------------------

  /// Stream (watch): tasks joined with tags, sorted by [sortBy].
  /// Demonstrates reactive updates — UI rebuilds automatically on any change.
  Stream<List<TaskWithTag>> watchTasksWithTags({String sortBy = 'date'}) {
    final query = select(tasks).join([
      leftOuterJoin(tags, tags.id.equalsExp(tasks.tagId)),
    ]);
    _applySort(query, sortBy);
    return query.watch().map(_mapRows);
  }

  /// Future (get): one-time fetch of tasks + tags.
  /// Demonstrates the difference vs watch() — no reactive updates.
  Future<List<TaskWithTag>> getTasksWithTags({String sortBy = 'date'}) async {
    final query = select(tasks).join([
      leftOuterJoin(tags, tags.id.equalsExp(tasks.tagId)),
    ]);
    _applySort(query, sortBy);
    return _mapRows(await query.get());
  }

  Future<int> insertTask(TasksCompanion entry) => into(tasks).insert(entry);

  Future<bool> updateTask(Task task) => update(tasks).replace(task);

  Future<int> deleteTask(int id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  Future<bool> toggleComplete(Task task) =>
      update(tasks).replace(task.copyWith(isCompleted: !task.isCompleted));

  // -------------------------------------------------------------------------
  // HELPERS
  // -------------------------------------------------------------------------

  void _applySort(
    JoinedSelectStatement<HasResultSet, dynamic> query,
    String sortBy,
  ) {
    if (sortBy == 'priority') {
      query.orderBy([
        // Incomplete tasks first, then by priority descending
        OrderingTerm.asc(tasks.isCompleted),
        OrderingTerm.desc(tasks.priority),
      ]);
    } else {
      // Default: sort by creation date descending (newest first)
      query.orderBy([
        OrderingTerm.asc(tasks.isCompleted),
        OrderingTerm.desc(tasks.createdAt),
      ]);
    }
  }

  List<TaskWithTag> _mapRows(List<TypedResult> rows) => rows
      .map((row) => TaskWithTag(
            task: row.readTable(tasks),
            tag: row.readTableOrNull(tags),
          ))
      .toList();
}
