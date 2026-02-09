import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Статусы загрузки данных
enum DataLoadingStatus { initial, loading, success, error }

// Состояние загрузки данных
class DataLoadingState extends Equatable {
  final DataLoadingStatus status;
  final List<String> data;
  final String? errorMessage;

  const DataLoadingState({
    required this.status,
    required this.data,
    this.errorMessage,
  });

  // Начальное состояние
  factory DataLoadingState.initial() {
    return const DataLoadingState(status: DataLoadingStatus.initial, data: []);
  }

  // Копирование состояния
  DataLoadingState copyWith({
    DataLoadingStatus? status,
    List<String>? data,
    String? errorMessage,
  }) {
    return DataLoadingState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}

// Cubit для загрузки данных
class DataLoadingCubit extends Cubit<DataLoadingState> {
  DataLoadingCubit() : super(DataLoadingState.initial());

  // Загрузка данных
  Future<void> loadData() async {
    emit(state.copyWith(status: DataLoadingStatus.loading, errorMessage: null));

    try {
      // Имитация загрузки данных с сервера
      await Future.delayed(const Duration(seconds: 2));

      // Симуляция успешной загрузки (можно изменить для тестирования ошибок)
      final random = DateTime.now().second % 3;

      if (random == 0) {
        // Симуляция ошибки
        throw Exception('Не удалось загрузить данные');
      } else if (random == 1) {
        // Пустой список
        emit(state.copyWith(status: DataLoadingStatus.success, data: []));
      } else {
        // Успешная загрузка с данными
        final loadedData = List.generate(
          10,
          (index) => 'Элемент данных ${index + 1}',
        );
        emit(
          state.copyWith(status: DataLoadingStatus.success, data: loadedData),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: DataLoadingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Повторная попытка загрузки
  Future<void> retry() async {
    await loadData();
  }
}
