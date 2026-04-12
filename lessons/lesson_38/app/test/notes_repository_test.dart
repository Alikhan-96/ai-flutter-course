import 'package:app/data/dto/api_note_dto.dart';
import 'package:app/data/repositories/notes_repository_impl.dart';
import 'package:app/domain/repositories/notes_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_notes_local_data_source.dart';
import 'fakes/fake_notes_remote_data_source.dart';
import 'fixtures/note_fixtures.dart';

void main() {
  group('NotesRepositoryImpl', () {
    test('returns local cache first for localFirst strategy', () async {
      final remote = FakeNotesRemoteDataSource(
        notesToReturn: <ApiNoteDto>[
          const ApiNoteDto(
            noteId: 'remote-1',
            noteTitle: 'Remote title',
            noteContent: 'Remote content',
          ),
        ],
      );
      final local = FakeNotesLocalDataSource(
        seedNotes: NoteFixtures.cachedNotes(),
      );
      final repository = NotesRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
      );

      final notes = await repository.getNotes();

      expect(notes.first.title, 'Cached title');
      expect(remote.fetchCalled, isFalse);
    });

    test('refreshNotes fetches remote data and updates local cache', () async {
      final remote = FakeNotesRemoteDataSource(
        notesToReturn: <ApiNoteDto>[
          const ApiNoteDto(
            noteId: 'remote-1',
            noteTitle: ' Remote title ',
            noteContent: ' Remote content ',
          ),
        ],
      );
      final local = FakeNotesLocalDataSource();
      final repository = NotesRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
      );

      final notes = await repository.refreshNotes();
      final cached = await local.getCachedNotes();

      expect(notes.first.title, 'Remote title');
      expect(local.cacheCalled, isTrue);
      expect(cached.first.content, 'Remote content');
    });

    test('remoteFirst falls back to cached data on remote failure', () async {
      final remote = FakeNotesRemoteDataSource(
        notesToReturn: const <ApiNoteDto>[],
      )..shouldFail = true;
      final local = FakeNotesLocalDataSource(
        seedNotes: NoteFixtures.cachedNotes(),
      );
      final repository = NotesRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
      );

      final notes = await repository.getNotes(
        strategy: FetchStrategy.remoteFirst,
      );

      expect(notes.first.id, 'cached-1');
      expect(remote.fetchCalled, isTrue);
    });

    test('cacheOnly returns cached data without contacting remote', () async {
      final remote = FakeNotesRemoteDataSource(
        notesToReturn: <ApiNoteDto>[
          const ApiNoteDto(
            noteId: 'unused',
            noteTitle: 'Unused',
            noteContent: 'Unused',
          ),
        ],
      );
      final local = FakeNotesLocalDataSource(
        seedNotes: NoteFixtures.cachedNotes(),
      );
      final repository = NotesRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
      );

      final notes = await repository.getNotes(
        strategy: FetchStrategy.cacheOnly,
      );

      expect(notes.single.title, 'Cached title');
      expect(remote.fetchCalled, isFalse);
    });
  });
}
