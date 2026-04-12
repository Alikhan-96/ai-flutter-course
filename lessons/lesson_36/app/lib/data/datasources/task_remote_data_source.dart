import '../../domain/entities/task_entity.dart';

class TaskRemoteDataSource {
  final List<TaskEntity> _remoteItems = <TaskEntity>[
    const TaskEntity(id: '1', title: 'Review BLoC ideas'),
    const TaskEntity(id: '2', title: 'Review dependency injection'),
    const TaskEntity(id: '3', title: 'Review Dio request flow'),
    const TaskEntity(id: '4', title: 'Review Drift local cache'),
  ];

  Future<List<TaskEntity>> fetchTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<TaskEntity>.from(_remoteItems);
  }

  Future<void> addTask(String title) async {
    _remoteItems.add(
      TaskEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
      ),
    );
  }
}
