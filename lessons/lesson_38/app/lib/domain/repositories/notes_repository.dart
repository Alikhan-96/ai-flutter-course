import '../entities/note.dart';

enum FetchStrategy {
  localFirst('Local first, then remote refresh'),
  remoteFirst('Remote first, fallback to cache'),
  cacheOnly('Cache only');

  const FetchStrategy(this.label);

  final String label;
}

abstract class NotesRepository {
  Future<List<Note>> getNotes({
    FetchStrategy strategy = FetchStrategy.localFirst,
  });

  Future<List<Note>> refreshNotes();
}
