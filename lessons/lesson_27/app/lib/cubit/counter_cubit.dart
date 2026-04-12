import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Состояние счётчика
class CounterState extends Equatable {
  final int count;
  final List<String> history;

  const CounterState({required this.count, required this.history});

  // Начальное состояние
  factory CounterState.initial() {
    return const CounterState(count: 0, history: []);
  }

  // Копирование состояния с изменениями
  CounterState copyWith({int? count, List<String>? history}) {
    return CounterState(
      count: count ?? this.count,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [count, history];
}

// Cubit для управления счётчиком
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState.initial());

  // Увеличение счётчика
  void increment() {
    final newCount = state.count + 1;
    final newHistory = _addToHistory('Увеличено до $newCount');
    emit(state.copyWith(count: newCount, history: newHistory));
  }

  // Уменьшение счётчика
  void decrement() {
    final newCount = state.count - 1;
    final newHistory = _addToHistory('Уменьшено до $newCount');
    emit(state.copyWith(count: newCount, history: newHistory));
  }

  // Сброс счётчика
  void reset() {
    final newHistory = _addToHistory('Сброшено до 0');
    emit(state.copyWith(count: 0, history: newHistory));
  }

  // Очистка состояния (включая историю)
  void clear() {
    emit(CounterState.initial());
  }

  // Добавление события в историю (максимум 10 последних)
  List<String> _addToHistory(String event) {
    final timestamp = DateTime.now();
    final formattedTime =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
    final eventWithTime = '[$formattedTime] $event';

    final newHistory = [eventWithTime, ...state.history];
    // Оставляем только последние 10 событий
    return newHistory.take(10).toList();
  }
}
