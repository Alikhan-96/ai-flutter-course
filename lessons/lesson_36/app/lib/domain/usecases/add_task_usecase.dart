import '../repositories/task_repository.dart';

class AddTaskUseCase {
  const AddTaskUseCase(this.repository);

  final TaskRepository repository;

  Future<void> call(String title) => repository.addTask(title);
}
