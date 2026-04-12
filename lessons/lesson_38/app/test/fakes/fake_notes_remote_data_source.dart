import 'package:app/data/datasources/notes_remote_data_source.dart';
import 'package:app/data/dto/api_note_dto.dart';

class FakeNotesRemoteDataSource implements NotesRemoteDataSource {
  FakeNotesRemoteDataSource({required this.notesToReturn, this.errorToThrow});

  final List<ApiNoteDto> notesToReturn;
  final Exception? errorToThrow;

  bool fetchCalled = false;
  bool _shouldFail = false;

  @override
  bool get shouldFail => _shouldFail;

  @override
  set shouldFail(bool value) {
    _shouldFail = value;
  }

  @override
  Future<List<ApiNoteDto>> fetchNotes() async {
    fetchCalled = true;

    if (_shouldFail) {
      throw Exception('Remote source unavailable');
    }

    if (errorToThrow != null) {
      throw errorToThrow!;
    }

    return notesToReturn;
  }
}
