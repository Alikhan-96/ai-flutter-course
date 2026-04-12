class Task {
  const Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.createdAt,
  });

  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
