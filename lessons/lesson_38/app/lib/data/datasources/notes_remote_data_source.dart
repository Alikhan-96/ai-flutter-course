import '../dto/api_note_dto.dart';

abstract class NotesRemoteDataSource {
  bool get shouldFail;
  set shouldFail(bool value);

  Future<List<ApiNoteDto>> fetchNotes();
}

class DemoNotesRemoteDataSource implements NotesRemoteDataSource {
  bool _shouldFail = false;

  final List<Map<String, dynamic>> _response = const <Map<String, dynamic>>[
    <String, dynamic>{
      'note_id': '100',
      'note_title': 'Remote note',
      'note_content': 'Fetched from the server response',
    },
    <String, dynamic>{
      'note_id': '101',
      'note_title': ' Architecture review ',
      'note_content': ' Repository returns adapted domain models ',
    },
  ];

  @override
  bool get shouldFail => _shouldFail;

  @override
  set shouldFail(bool value) {
    _shouldFail = value;
  }

  @override
  Future<List<ApiNoteDto>> fetchNotes() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (_shouldFail) {
      throw Exception('Remote source unavailable');
    }

    return _response.map(ApiNoteDto.fromJson).toList();
  }
}
