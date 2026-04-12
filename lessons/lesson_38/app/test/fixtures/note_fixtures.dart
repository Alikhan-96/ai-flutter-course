import 'package:app/domain/entities/note.dart';

class NoteFixtures {
  static Map<String, dynamic> validApiJson() {
    return <String, dynamic>{
      'note_id': '1',
      'note_title': 'Title',
      'note_content': 'Content',
    };
  }

  static Map<String, dynamic> emptyApiJson() {
    return <String, dynamic>{
      'note_id': '2',
      'note_title': '   ',
      'note_content': '',
    };
  }

  static Map<String, dynamic> invalidApiJson() {
    return <String, dynamic>{
      'note_title': 'Missing id',
      'note_content': 'Broken payload',
    };
  }

  static List<Note> cachedNotes() {
    return const <Note>[
      Note(id: 'cached-1', title: 'Cached title', content: 'Cached content'),
    ];
  }
}
