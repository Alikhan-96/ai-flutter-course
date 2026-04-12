import 'package:flutter/material.dart';

import 'data/datasources/task_local_data_source.dart';
import 'data/datasources/task_remote_data_source.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/usecases/add_task_usecase.dart';
import 'domain/usecases/get_tasks_usecase.dart';
import 'presentation/pages/task_dashboard_page.dart';
import 'presentation/viewmodels/task_view_model.dart';

void main() {
  final remoteDataSource = TaskRemoteDataSource();
  final localDataSource = TaskLocalDataSource();
  final repository = TaskRepositoryImpl(
    remote: remoteDataSource,
    local: localDataSource,
  );
  final viewModel = TaskViewModel(
    getTasksUseCase: GetTasksUseCase(repository),
    addTaskUseCase: AddTaskUseCase(repository),
  );

  runApp(Lesson36App(viewModel: viewModel));
}

class Lesson36App extends StatelessWidget {
  const Lesson36App({
    required this.viewModel,
    super.key,
  });

  final TaskViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson 36: Clean Architecture + MVVM',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TaskDashboardPage(viewModel: viewModel),
    );
  }
}
