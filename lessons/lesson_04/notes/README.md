# Урок 4: Циклы в Dart

## Основные темы

### Цикл for
```dart
// Классический for
for (int i = 1; i <= 5; i++) {
  print('Итерация $i');
}

// Сумма от 1 до n
int sum = 0;
for (int i = 1; i <= n; i++) {
  sum += i;
}
```

### Цикл for-in
```dart
List<int> numbers = [1, 2, 3, 4, 5];

for (int num in numbers) {
  print(num);
}
```

### Цикл while
```dart
int count = 0;

while (count < 5) {
  print('Count: $count');
  count++;
}
```

### Цикл do-while
```dart
int x = 0;

do {
  print('x = $x');
  x++;
} while (x < 3);
```

### Управление циклами
```dart
// break - выход из цикла
for (int i = 0; i < 10; i++) {
  if (i == 5) break;
  print(i);
}

// continue - пропуск итерации
for (int i = 0; i < 10; i++) {
  if (i % 2 == 0) continue;
  print(i); // Только нечётные
}
```

### Работа со списками в циклах
```dart
List<int> list = [3, 1, 7, 2, 5];

// Поиск минимума
int min = list[0];
for (int num in list) {
  if (num < min) min = num;
}

// Подсчёт чётных
int evenCount = 0;
for (int num in list) {
  if (num % 2 == 0) evenCount++;
}
```

### Разворот списка (без .reversed)
```dart
List<int> original = [1, 2, 3];
List<int> reversed = [];

for (int i = original.length - 1; i >= 0; i--) {
  reversed.add(original[i]);
}
```

## Ключевые концепции
- Условие цикла проверяется перед/после каждой итерации
- `break` полностью прерывает цикл
- `continue` переходит к следующей итерации
- `for-in` удобен для итерации по коллекциям

## Типичные ошибки
- Бесконечный цикл (забыли обновить счётчик)
- Off-by-one error (ошибка на единицу)
- Изменение коллекции во время итерации
