import '../../domain/entities/task_entity.dart';

class TaskLocalDataSource {
  List<TaskEntity> _cache = const <TaskEntity>[];

  Future<void> saveTasks(List<TaskEntity> tasks) async {
    _cache = List<TaskEntity>.from(tasks);
  }

  Future<List<TaskEntity>> getCachedTasks() async {
    return List<TaskEntity>.from(_cache);
  }
}
