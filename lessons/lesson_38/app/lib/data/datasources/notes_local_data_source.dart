import '../../domain/entities/note.dart';

abstract class NotesLocalDataSource {
  Future<void> cacheNotes(List<Note> notes);

  Future<List<Note>> getCachedNotes();
}

class InMemoryNotesLocalDataSource implements NotesLocalDataSource {
  InMemoryNotesLocalDataSource({List<Note> seedNotes = const <Note>[]})
    : _cache = List<Note>.from(seedNotes);

  List<Note> _cache;

  @override
  Future<void> cacheNotes(List<Note> notes) async {
    _cache = List<Note>.from(notes);
  }

  @override
  Future<List<Note>> getCachedNotes() async {
    return List<Note>.from(_cache);
  }
}
