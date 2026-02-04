# Урок 7: ООП - Классы и объекты

## Основные темы

### Объявление класса
```dart
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('Меня зовут $name, мне $age лет');
  }
}

// Создание объекта
var person = Person('Алия', 25);
person.introduce();
```

### Конструкторы
```dart
class Book {
  String title;
  String author;

  // Обычный конструктор
  Book(this.title, this.author);

  // Именованный конструктор
  Book.unknown() : title = 'Неизвестно', author = 'Неизвестно';

  // Конструктор с именованными параметрами
  Book.named({required this.title, required this.author});
}

var book1 = Book('Dart', 'Google');
var book2 = Book.unknown();
var book3 = Book.named(title: 'Flutter', author: 'Google');
```

### Наследование
```dart
class Animal {
  String name;
  Animal(this.name);

  void makeSound() {
    print('Какой-то звук');
  }
}

class Dog extends Animal {
  Dog(String name) : super(name);

  @override
  void makeSound() {
    print('Гав-гав!');
  }
}

class Cat extends Animal {
  Cat(String name) : super(name);

  @override
  void makeSound() {
    print('Мяу!');
  }
}
```

### Инкапсуляция
```dart
class Circle {
  double _radius;  // Приватное поле (начинается с _)

  Circle(this._radius);

  // Геттер
  double get radius => _radius;

  // Сеттер с валидацией
  set radius(double value) {
    if (value >= 0) {
      _radius = value;
    }
  }

  double area() {
    return 3.14159 * _radius * _radius;
  }
}
```

### Методы класса
```dart
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;
  double divide(int a, int b) => a / b;
}
```

## Ключевые концепции
- **Класс** - шаблон для создания объектов
- **Объект** - экземпляр класса
- **Наследование** - `extends` для расширения класса
- **Инкапсуляция** - `_` делает поле приватным
- **@override** - переопределение метода родителя

## Типичные ошибки
- Забытый `super()` в конструкторе наследника
- Отсутствие `@override` при переопределении
- Попытка доступа к приватному полю извне класса
