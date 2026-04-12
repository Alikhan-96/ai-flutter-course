import 'package:app/data/dto/api_note_dto.dart';
import 'package:app/data/mappers/note_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures/note_fixtures.dart';

void main() {
  group('Note mapper', () {
    test('maps normal API data to domain', () {
      final dto = ApiNoteDto.fromJson(NoteFixtures.validApiJson());

      final note = dto.toDomain();

      expect(note.id, '1');
      expect(note.title, 'Title');
      expect(note.content, 'Content');
    });

    test('maps empty title and content to friendly defaults', () {
      final dto = ApiNoteDto.fromJson(NoteFixtures.emptyApiJson());

      final note = dto.toDomain();

      expect(note.id, '2');
      expect(note.title, 'Untitled note');
      expect(note.content, 'No content provided');
    });

    test('throws on incorrect API data', () {
      expect(
        () => ApiNoteDto.fromJson(NoteFixtures.invalidApiJson()),
        throwsA(
          isA<FormatException>().having(
            (exception) => exception.message,
            'message',
            'note_id is required',
          ),
        ),
      );
    });

    test('maps domain model back to DTO', () {
      final dto = const ApiNoteDto(
        noteId: '7',
        noteTitle: 'Repository note',
        noteContent: 'Back to api format',
      );

      expect(dto.toDomain().toDto().toJson(), <String, dynamic>{
        'note_id': '7',
        'note_title': 'Repository note',
        'note_content': 'Back to api format',
      });
    });
  });
}
