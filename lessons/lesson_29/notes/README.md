# Lesson 29 — Drift: SQLite Local Database in Flutter

## What is Drift?

**Drift** (formerly called *Moor*) is a type-safe, reactive ORM (Object-Relational Mapper) for SQLite in Flutter and Dart.
It uses code generation to turn Dart class definitions into fully-typed SQL queries, so you never write raw SQL strings.

| Feature | Drift |
|---|---|
| Database | SQLite (via `sqlite3` native lib) |
| Type safety | Full — queries are Dart code, compile-time checked |
| Reactivity | `Stream`-based with `watch()` |
| Migration | Declarative `MigrationStrategy` |
| Platforms | Android, iOS, Windows, macOS, Linux, Web (via `drift/web`) |

---

## Setup

### 1. Dependencies

```yaml
# pubspec.yaml
dependencies:
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.24   # native SQLite binaries
  path_provider: ^2.1.2           # get app documents dir
  path: ^1.9.0                    # path.join()

dev_dependencies:
  drift_dev: ^2.18.0              # code generator
  build_runner: ^2.4.9            # build system
```

### 2. Generate code

After creating/changing your `database.dart`, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This produces `database.g.dart` (never edit by hand).

---

## Defining Tables

Tables are Dart classes that extend `Table`.
Each getter defines a column:

```dart
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();      // PK, auto-increment
  TextColumn get title => text().withLength(min: 1)();  // NOT NULL
  TextColumn get description => text().nullable()();    // NULL allowed
  IntColumn get priority => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  // Foreign key → Tags table
  IntColumn get tagId => integer().nullable().references(Tags, #id)();
}
```

Column type shortcuts:

| Dart type | Drift column type |
|---|---|
| `int` | `IntColumn` via `integer()` |
| `String` | `TextColumn` via `text()` |
| `bool` | `BoolColumn` via `boolean()` |
| `DateTime` | `DateTimeColumn` via `dateTime()` |
| `double` | `RealColumn` via `real()` |
| `Uint8List` | `BlobColumn` via `blob()` |

---

## Defining the Database

```dart
part 'database.g.dart';   // generated code lives here

@DriftDatabase(tables: [Tags, Tasks])   // list all tables
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;   // bump when you change the schema
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(path.join(dir.path, 'my_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```

`_$AppDatabase` is the generated mixin — Drift creates it from your table definitions.

---

## CRUD Operations

### Insert

```dart
// Using a "Companion" — generated class for partial row insertion
await db.into(db.tasks).insert(TasksCompanion.insert(
  title: 'Buy groceries',
  priority: const Value(1),
  tagId: const Value(3),
));
```

Use `Value(x)` for optional/defaulted columns; absent columns keep their default.

### Select (one-time)

```dart
// All rows
final List<Task> all = await db.select(db.tasks).get();

// With filter
final List<Task> high = await (db.select(db.tasks)
  ..where((t) => t.priority.equals(2)))
  .get();
```

### Select (reactive stream)

```dart
// Emits a new List<Task> every time the tasks table changes
Stream<List<Task>> stream = db.select(db.tasks).watch();
```

Use in `StreamBuilder`:
```dart
StreamBuilder<List<Task>>(
  stream: db.watchAllTasks(),
  builder: (ctx, snapshot) {
    final tasks = snapshot.data ?? [];
    return ListView.builder(itemCount: tasks.length, ...);
  },
)
```

### Update

```dart
// Replace whole row (use copyWith to change only some fields)
await db.update(db.tasks).replace(task.copyWith(isCompleted: true));

// Selective update
await (db.update(db.tasks)
  ..where((t) => t.id.equals(task.id)))
  .write(TasksCompanion(isCompleted: const Value(true)));
```

### Delete

```dart
await (db.delete(db.tasks)..where((t) => t.id.equals(id))).go();
```

---

## watch() vs get() — Key Difference

| | `watch()` | `get()` |
|---|---|---|
| Return type | `Stream<List<T>>` | `Future<List<T>>` |
| Updates | **Automatic** — emits on every table change | One-time snapshot |
| Use with | `StreamBuilder` | `FutureBuilder` or `await` |
| Best for | Lists that change (live CRUD) | One-off reads, initialization |

**Rule of thumb:** Use `watch()` for anything shown in the UI that the user can modify. Use `get()` for loading initial config, export, or read-only lookups.

---

## JOIN Queries (Relations)

```dart
// tasks LEFT JOIN tags ON tags.id = tasks.tagId
final query = db.select(db.tasks).join([
  leftOuterJoin(db.tags, db.tags.id.equalsExp(db.tasks.tagId)),
]);

// Sorting
query.orderBy([
  OrderingTerm.asc(db.tasks.isCompleted),
  OrderingTerm.desc(db.tasks.priority),
]);

// Read results
final rows = await query.get();
final result = rows.map((row) => TaskWithTag(
  task: row.readTable(db.tasks),
  tag: row.readTableOrNull(db.tags),   // null if no tag (LEFT JOIN)
)).toList();
```

**Reactive JOIN** — replace `.get()` with `.watch()` to get a live stream.

---

## Schema Migrations

When you change your schema (add/remove/rename a column), bump `schemaVersion` and handle the upgrade:

```dart
@override
int get schemaVersion => 2;   // was 1, now 2

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async {
    // Fresh install — create everything at schema version 2
    await m.createAll();
  },
  onUpgrade: (m, from, to) async {
    if (from < 2) {
      // v1 → v2: add `notes` TEXT column with default ''
      await m.addColumn(tasks, tasks.notes);
    }
  },
);
```

Available migration helpers:

| Method | Action |
|---|---|
| `m.createAll()` | Create all tables (fresh install) |
| `m.createTable(table)` | Create a single table |
| `m.addColumn(table, column)` | Add column (ALTER TABLE ... ADD COLUMN) |
| `m.deleteTable(tableName)` | Drop a table |
| `m.renameTable(from, to)` | Rename a table |
| `m.issueCustomQuery(sql, vars)` | Run arbitrary SQL during migration |

---

## Project Structure (this lesson)

```
lib/
  database/
    database.dart      ← Table definitions + DB class + queries
    database.g.dart    ← Generated by build_runner (do not edit)
  screens/
    home_screen.dart          ← TabBar: Tasks | Tags + export/import menu
    tasks_tab.dart            ← StreamBuilder watch() vs FutureBuilder get()
    tags_tab.dart             ← Tags CRUD with color picker
    add_edit_task_dialog.dart ← Add/Edit task form
    add_edit_tag_dialog.dart  ← Add/Edit tag form
  services/
    json_service.dart  ← Export/import tasks+tags as JSON
  main.dart            ← App entry point, global AppDatabase instance
```

---

## Homework Requirements — Implemented

| Requirement | Implementation |
|---|---|
| 2 tables with FK relation | `Tags` + `Tasks` tables; `Tasks.tagId` references `Tags.id` |
| CRUD | Insert/update/delete for both tables; toggle complete |
| Sort by date / priority | `_sortBy` toggle in `TasksTab`; `orderBy` in query |
| `watch()` vs `get()` demo | Mode toggle chip in toolbar; `StreamBuilder` vs manual refresh |
| Migration (new field) | Schema v1→v2 adds `notes` TEXT column via `m.addColumn()` |
| JSON export/import | `JsonService.exportToJson()` / `importFromJson()` in app menu |

---

## Common Gotchas

1. **Always regenerate after schema changes** — run `build_runner build` or the app will fail to compile.
2. **`part 'database.g.dart'`** must be the first non-import line in your database file.
3. **Table declaration order matters for FK** — declare referenced tables (e.g. `Tags`) before tables that reference them, OR rely on Drift's deferred FK support.
4. **`LazyDatabase`** is important — it defers the actual file opening to first use, which prevents issues with `main()` running before the Flutter engine initializes.
5. **Schema version** starts at `1`. Only increment it — never go backwards.
6. **`Value<T>`** vs absent — in Companions, wrap optional fields with `Value(x)`. Absent fields keep their table default.

---

## Useful Drift Concepts

### `currentDateAndTime`
A Drift expression equivalent to SQLite's `CURRENT_TIMESTAMP`. Use it as a column default:
```dart
DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
```

### `copyWith`
Every generated data class has `copyWith` for immutable updates:
```dart
final updated = task.copyWith(isCompleted: true, priority: 2);
await db.update(db.tasks).replace(updated);
```

### `customSelect` (raw SQL when needed)
```dart
final rows = await db.customSelect(
  'SELECT * FROM tasks WHERE priority > ?',
  variables: [Variable.withInt(1)],
  readsFrom: {db.tasks},
).get();
```

---

## References

- [Drift documentation](https://drift.simonbinder.eu/)
- [Drift pub.dev page](https://pub.dev/packages/drift)
- [SQLite documentation](https://sqlite.org/docs.html)
