# Урок 6: Функции в Dart

## Основные темы

### Объявление функции
```dart
// Функция без возврата
void sayHello() {
  print('Привет!');
}

// Функция с возвратом
int square(int n) {
  return n * n;
}

// Стрелочная функция (для одного выражения)
int cube(int n) => n * n * n;
double getPi() => 3.14;
bool isEven(int n) => n % 2 == 0;
```

### Параметры функций
```dart
// Обязательные параметры
String getFullName(String first, String last) {
  return '$first $last';
}

// Именованные параметры (опциональные)
void greet({String name = 'Гость'}) {
  print('Привет, $name!');
}
greet();              // Привет, Гость!
greet(name: 'Алия'); // Привет, Алия!

// Обязательные именованные параметры
void showUser({required String name, required int age}) {
  print('$name, $age лет');
}

// Опциональные позиционные параметры
void log(String message, [String? prefix]) {
  if (prefix != null) {
    print('$prefix: $message');
  } else {
    print(message);
  }
}
```

### Вложенные функции
```dart
void calculate() {
  int sum(int a, int b) => a + b;
  int multiply(int a, int b) => a * b;

  print(sum(3, 4));       // 7
  print(multiply(3, 4));  // 12
}
```

### Область видимости
```dart
void demo() {
  int localVar = 10;  // Локальная переменная
  print(localVar);
}
// localVar недоступна здесь
```

### Возвращаемые типы
```dart
// void - ничего не возвращает
void printMessage(String msg) {
  print(msg);
}

// Конкретный тип
int add(int a, int b) {
  return a + b;
}

// Nullable тип
String? findUser(int id) {
  if (id == 1) return 'Admin';
  return null;
}
```

### Функции высшего порядка
```dart
// Функция как параметр
void processNumbers(List<int> numbers, Function(int) processor) {
  for (var n in numbers) {
    processor(n);
  }
}

processNumbers([1, 2, 3], (n) => print(n * 2));
```

## Ключевые концепции
- Функции - многократно используемые блоки кода
- `void` означает отсутствие возвращаемого значения
- `=>` для однострочных функций
- `required` для обязательных именованных параметров

## Типичные ошибки
- Забытый `return` в функции с возвратом
- Путаница между позиционными и именованными параметрами
- Вызов функции без скобок (получение ссылки вместо вызова)
