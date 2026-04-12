class TaskDto {
  const TaskDto({
    required this.id,
    this.title,
    this.isDone,
    this.createdAtMilliseconds,
  });

  final String id;
  final String? title;
  final bool? isDone;
  final int? createdAtMilliseconds;

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String?,
      isDone: json['is_done'] as bool?,
      createdAtMilliseconds: _parseCreatedAt(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'is_done': isDone,
      'created_at': createdAtMilliseconds,
    };
  }

  static int? _parseCreatedAt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is DateTime) {
      return value.toUtc().millisecondsSinceEpoch;
    }

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      return parsed?.toUtc().millisecondsSinceEpoch;
    }

    return null;
  }
}
