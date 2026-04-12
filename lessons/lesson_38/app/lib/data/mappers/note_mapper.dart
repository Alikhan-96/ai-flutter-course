import '../../domain/entities/note.dart';
import '../dto/api_note_dto.dart';

const _emptyTitleFallback = 'Untitled note';
const _emptyContentFallback = 'No content provided';

extension ApiNoteDtoMapper on ApiNoteDto {
  Note toDomain() {
    final trimmedTitle = noteTitle.trim();
    final trimmedContent = noteContent.trim();

    return Note(
      id: noteId,
      title: trimmedTitle.isEmpty ? _emptyTitleFallback : trimmedTitle,
      content: trimmedContent.isEmpty ? _emptyContentFallback : trimmedContent,
    );
  }
}

extension NoteMapper on Note {
  ApiNoteDto toDto() {
    return ApiNoteDto(noteId: id, noteTitle: title, noteContent: content);
  }
}
