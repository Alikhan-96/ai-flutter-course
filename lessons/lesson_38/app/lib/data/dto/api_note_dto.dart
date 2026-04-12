class ApiNoteDto {
  const ApiNoteDto({
    required this.noteId,
    required this.noteTitle,
    required this.noteContent,
  });

  final String noteId;
  final String noteTitle;
  final String noteContent;

  factory ApiNoteDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['note_id'];
    if (rawId == null || rawId.toString().trim().isEmpty) {
      throw const FormatException('note_id is required');
    }

    final title = json['note_title']?.toString() ?? '';
    final content = json['note_content']?.toString() ?? '';

    return ApiNoteDto(
      noteId: rawId.toString(),
      noteTitle: title,
      noteContent: content,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'note_id': noteId,
      'note_title': noteTitle,
      'note_content': noteContent,
    };
  }
}
