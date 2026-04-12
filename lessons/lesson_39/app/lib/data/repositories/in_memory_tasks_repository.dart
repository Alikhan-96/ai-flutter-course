import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';

class InMemoryTasksRepository implements TasksRepository {
  final List<Task> _tasks = <Task>[];

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<List<Task>> getTasks() async {
    return List<Task>.unmodifiable(_tasks);
  }
}
