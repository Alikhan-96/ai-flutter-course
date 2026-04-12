import 'package:app/domain/entities/task.dart';
import 'package:app/domain/repositories/tasks_repository.dart';

class FakeTasksRepository implements TasksRepository {
  FakeTasksRepository({this.errorToThrow});

  final Exception? errorToThrow;

  bool addCalled = false;
  Task? addedTask;
  final List<Task> _storedTasks = <Task>[];

  @override
  Future<void> addTask(Task task) async {
    addCalled = true;

    if (errorToThrow != null) {
      throw errorToThrow!;
    }

    addedTask = task;
    _storedTasks.add(task);
  }

  @override
  Future<List<Task>> getTasks() async {
    return List<Task>.unmodifiable(_storedTasks);
  }
}
