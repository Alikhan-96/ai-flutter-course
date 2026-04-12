import 'package:flutter/material.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';

class TaskViewModel extends ChangeNotifier {
  TaskViewModel({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
  });

  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;

  List<TaskEntity> tasks = const <TaskEntity>[];
  bool isLoading = false;
  String? error;

  Future<void> loadTasks() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      tasks = await getTasksUseCase();
    } catch (errorValue) {
      error = 'Load failed: $errorValue';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) {
      error = 'Task title cannot be empty';
      notifyListeners();
      return;
    }

    await addTaskUseCase(title.trim());
    await loadTasks();
  }
}
