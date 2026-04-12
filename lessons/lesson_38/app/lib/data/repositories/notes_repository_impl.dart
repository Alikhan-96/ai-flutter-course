import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_data_source.dart';
import '../datasources/notes_remote_data_source.dart';
import '../mappers/note_mapper.dart';

class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final NotesRemoteDataSource remoteDataSource;
  final NotesLocalDataSource localDataSource;

  @override
  Future<List<Note>> getNotes({
    FetchStrategy strategy = FetchStrategy.localFirst,
  }) async {
    switch (strategy) {
      case FetchStrategy.cacheOnly:
        return localDataSource.getCachedNotes();
      case FetchStrategy.remoteFirst:
        return _loadRemoteWithFallback();
      case FetchStrategy.localFirst:
        final cachedNotes = await localDataSource.getCachedNotes();
        if (cachedNotes.isNotEmpty) {
          return cachedNotes;
        }
        return _loadRemoteWithFallback();
    }
  }

  @override
  Future<List<Note>> refreshNotes() async {
    final remoteDtos = await remoteDataSource.fetchNotes();
    final notes = remoteDtos.map((dto) => dto.toDomain()).toList();
    await localDataSource.cacheNotes(notes);
    return notes;
  }

  Future<List<Note>> _loadRemoteWithFallback() async {
    try {
      return await refreshNotes();
    } catch (_) {
      return localDataSource.getCachedNotes();
    }
  }
}
