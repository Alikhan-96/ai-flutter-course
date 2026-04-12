import '../entities/task.dart';

abstract class TasksRepository {
  Future<void> addTask(Task task);

  Future<List<Task>> getTasks();
}
