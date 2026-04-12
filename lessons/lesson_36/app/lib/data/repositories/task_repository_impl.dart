import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required this.remote,
    required this.local,
  });

  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;

  @override
  Future<List<TaskEntity>> getTasks() async {
    final tasks = await remote.fetchTasks();
    await local.saveTasks(tasks);
    return tasks;
  }

  @override
  Future<void> addTask(String title) async {
    await remote.addTask(title);
    await local.saveTasks(await remote.fetchTasks());
  }
}
