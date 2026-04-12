# Lesson 38: Design Patterns - Repository & Adapter

## Overview
Structural design patterns: Repository and Adapter patterns for data management.

## Homework Completed

✅ **Repository Pattern** - Interface in domain, implementation in data
✅ **Adapter Pattern** - Transform external formats to domain models
✅ **Model Mapping** - Handle normal, empty, and incorrect data
✅ **Caching** - Local cache with remote sync
✅ **Data Sources** - Separate remote and local data sources

## Repository Pattern

**Purpose**: Abstract data source access

**Benefits**:
- Centralized data access
- Easy to switch data sources
- Testable (mock repository)
- Clean separation

**Structure**:
```
domain/repositories/
  └── notes_repository.dart (interface)

data/repositories/
  └── notes_repository_impl.dart (implementation)

data/datasources/
  ├── remote_data_source.dart
  └── local_data_source.dart
```

**Implementation**:
```dart
// Domain layer - Interface
abstract class NotesRepository {
  Future<List<Note>> getNotes();
  Future<Note> getNoteById(String id);
  Future<void> createNote(Note note);
}

// Data layer - Implementation
class NotesRepositoryImpl implements NotesRepository {
  final RemoteDataSource remote;
  final LocalDataSource local;

  NotesRepositoryImpl(this.remote, this.local);

  @override
  Future<List<Note>> getNotes() async {
    try {
      final notes = await remote.fetchNotes();
      await local.cacheNotes(notes);
      return notes;
    } catch (e) {
      return await local.getCachedNotes();
    }
  }
}
```

## Adapter Pattern

**Purpose**: Convert one interface to another

**Use Cases**:
- API model → Domain model
- Database model → Domain model
- Third-party library integration

**Implementation**:
```dart
// External API model
class ApiNote {
  final String noteId;
  final String noteTitle;

  factory ApiNote.fromJson(Map<String, dynamic> json) =>
      ApiNote(json['note_id'], json['note_title']);
}

// Domain model
class Note {
  final String id;
  final String title;

  Note(this.id, this.title);
}

// Adapter
class NoteAdapter {
  static Note fromApi(ApiNote apiNote) {
    return Note(apiNote.noteId, apiNote.noteTitle);
  }

  static ApiNote toApi(Note note) {
    return ApiNote(note.id, note.title);
  }
}
```

## Data Source Strategy

### Remote Data Source
- API calls
- Network requests
- Real-time updates

### Local Data Source
- SQLite/Drift
- SharedPreferences
- Caching

### Strategy
1. Try remote first
2. Cache results locally
3. Fallback to local on error
4. Sync when connection restored

## Implementation

Complete implementation in `../app/` with:
- Repository interfaces
- Repository implementations
- Remote and local data sources
- Adapter classes
- Caching strategy
- Error handling

## Complete Implementation Available

See `LESSONS_33-39_COMPLETION_GUIDE.md` for complete repository and adapter implementations.
