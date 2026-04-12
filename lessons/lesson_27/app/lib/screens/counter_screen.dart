import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/counter_cubit.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Счётчик с историей (Cubit)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Область со значением счётчика
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Текущее значение:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  // BlocBuilder для отображения счётчика
                  BlocBuilder<CounterCubit, CounterState>(
                    builder: (context, state) {
                      return Text(
                        '${state.count}',
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Кнопки управления
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: 'decrement',
                        onPressed: () =>
                            context.read<CounterCubit>().decrement(),
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton(
                        heroTag: 'increment',
                        onPressed: () =>
                            context.read<CounterCubit>().increment(),
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => context.read<CounterCubit>().reset(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Сброс'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // История действий
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'История действий (последние 10):',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => context.read<CounterCubit>().clear(),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Очистить всё'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
                // BlocBuilder для отображения истории
                Expanded(
                  child: BlocBuilder<CounterCubit, CounterState>(
                    builder: (context, state) {
                      if (state.history.isEmpty) {
                        return const Center(
                          child: Text(
                            'История пуста',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.history.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(state.history[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
