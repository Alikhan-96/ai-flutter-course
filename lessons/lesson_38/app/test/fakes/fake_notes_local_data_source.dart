import 'package:app/data/datasources/notes_local_data_source.dart';
import 'package:app/domain/entities/note.dart';

class FakeNotesLocalDataSource implements NotesLocalDataSource {
  FakeNotesLocalDataSource({List<Note> seedNotes = const <Note>[]})
    : _cache = List<Note>.from(seedNotes);

  List<Note> _cache;
  bool cacheCalled = false;

  @override
  Future<void> cacheNotes(List<Note> notes) async {
    cacheCalled = true;
    _cache = List<Note>.from(notes);
  }

  @override
  Future<List<Note>> getCachedNotes() async {
    return List<Note>.from(_cache);
  }
}
