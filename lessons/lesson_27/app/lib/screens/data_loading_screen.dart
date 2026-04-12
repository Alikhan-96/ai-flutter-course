import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/data_loading_cubit.dart';

class DataLoadingScreen extends StatelessWidget {
  const DataLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataLoadingCubit()..loadData(),
      child: const DataLoadingView(),
    );
  }
}

class DataLoadingView extends StatelessWidget {
  const DataLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Загрузка данных'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<DataLoadingCubit, DataLoadingState>(
        builder: (context, state) {
          switch (state.status) {
            case DataLoadingStatus.initial:
              return const InitialView();
            case DataLoadingStatus.loading:
              return const LoadingView();
            case DataLoadingStatus.success:
              return SuccessView(data: state.data);
            case DataLoadingStatus.error:
              return ErrorView(
                errorMessage: state.errorMessage ?? 'Неизвестная ошибка',
              );
          }
        },
      ),
    );
  }
}

// Начальное состояние
class InitialView extends StatelessWidget {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_download_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          const Text(
            'Готово к загрузке данных',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<DataLoadingCubit>().loadData(),
            icon: const Icon(Icons.download),
            label: const Text('Загрузить данные'),
          ),
        ],
      ),
    );
  }
}

// Состояние загрузки
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          const Text('Загрузка данных...', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Пожалуйста, подождите',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// Успешная загрузка
class SuccessView extends StatelessWidget {
  final List<String> data;

  const SuccessView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Проверка на пустой список
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.orange.shade300),
            const SizedBox(height: 24),
            const Text('Данные не найдены', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Попробуйте загрузить снова',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<DataLoadingCubit>().retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Загрузка успешна!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    Text(
                      'Загружено элементов: ${data.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => context.read<DataLoadingCubit>().retry(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Обновить'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(data[index]),
                  subtitle: Text(
                    'Загружено: ${DateTime.now().toString().substring(11, 19)}',
                  ),
                  trailing: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Состояние ошибки
class ErrorView extends StatelessWidget {
  final String errorMessage;

  const ErrorView({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
            const SizedBox(height: 24),
            const Text(
              'Ошибка загрузки',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.red.shade700),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.read<DataLoadingCubit>().retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить попытку'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
