# Урок 5: Коллекции - List и Map

## Основные темы

### Списки (List)
```dart
// Создание списка
List<int> numbers = [2, 5, 8, 11, 14];
var fruits = ['яблоко', 'банан', 'апельсин'];

// Доступ к элементам
print(numbers[0]);  // 2
print(numbers.length);  // 5

// Добавление элементов
numbers.add(17);
numbers.addAll([20, 23]);

// Удаление элементов
numbers.remove(5);
numbers.removeAt(0);
```

### Фильтрация списков
```dart
List<int> numbers = [2, 5, 8, 11, 14];

// Чётные числа
List<int> even = numbers.where((n) => n % 2 == 0).toList();

// Числа больше 10
List<int> big = numbers.where((n) => n > 10).toList();
```

### Метод map()
```dart
List<int> numbers = [1, 2, 3];

// Умножение каждого элемента на 3
List<int> tripled = numbers.map((n) => n * 3).toList();
// [3, 6, 9]
```

### Словари (Map)
```dart
// Создание Map
Map<String, dynamic> student = {
  'name': 'Аружан',
  'score': 90,
};

// Добавление поля
student['grade'] = 'A';

// Доступ к значению
print(student['name']);  // Аружан

// Проверка наличия ключа
if (student.containsKey('grade')) {
  print('Оценка: ${student['grade']}');
}
```

### Итерация по коллекциям
```dart
// forEach для List
numbers.forEach((n) => print(n));

// forEach для Map
student.forEach((key, value) {
  print('$key: $value');
});

// Получение ключей и значений
List<String> keys = student.keys.toList();
List<dynamic> values = student.values.toList();
```

### Работа со списком объектов
```dart
List<Map<String, dynamic>> students = [
  {'name': 'Алия', 'score': 85},
  {'name': 'Бекзат', 'score': 92},
  {'name': 'Сара', 'score': 78},
];

// Имена студентов с баллом > 80
var goodStudents = students
    .where((s) => s['score'] > 80)
    .map((s) => s['name'])
    .toList();
```

### Создание Map из двух списков
```dart
List<String> keys = ['a', 'b', 'c'];
List<int> values = [1, 2, 3];

Map<String, int> map = Map.fromIterables(keys, values);
// {'a': 1, 'b': 2, 'c': 3}
```

## Ключевые концепции
- **List** - упорядоченная коллекция с индексами
- **Map** - коллекция пар ключ-значение
- **Set** - коллекция уникальных элементов
- Методы `where()`, `map()`, `forEach()` для обработки

## Типичные ошибки
- Обращение к несуществующему индексу
- Изменение списка во время итерации
- Забытый `.toList()` после `where()` или `map()`
