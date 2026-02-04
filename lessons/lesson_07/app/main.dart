import 'dart:math';

// Задачи 1-4: Иерархия Animal -> Dog, Cat
class Animal {
  String name;

  Animal(this.name);

  void makeSound() {
    print('Животное издает звук');
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

// Задачи 5-6: Класс Person
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('Привет! Меня зовут $name, мне $age лет.');
  }
}

// Задача 7: Класс Book с именованным конструктором
class Book {
  String title;
  String author;

  Book(this.title, this.author);

  // Именованный конструктор для неизвестной книги
  Book.unknown()
      : title = 'Неизвестно',
        author = 'Неизвестен';

  void displayInfo() {
    print('Книга: "$title", автор: $author');
  }
}

// Задачи 8-10: Класс Circle
class Circle {
  double _radius = 0; // Приватное поле

  Circle(double radius) {
    setRadius(radius);
  }

  // Сеттер с валидацией
  void setRadius(double radius) {
    if (radius < 0) {
      print('Ошибка: радиус не может быть отрицательным!');
      _radius = 0;
    } else {
      _radius = radius;
    }
  }

  // Геттер
  double getRadius() {
    return _radius;
  }

  // Вычисление площади
  double area() {
    return pi * _radius * _radius;
  }
}

void main() {
  print('=== Задачи 1-4: Animal, Dog, Cat ===');
  var dog = Dog('Бобик');
  var cat = Cat('Мурка');

  print('${dog.name} говорит:');
  dog.makeSound();

  print('${cat.name} говорит:');
  cat.makeSound();

  print('\n=== Задачи 5-6: Person ===');
  var person1 = Person('Алихан', 30);
  var person2 = Person('Жанат', 28);

  person1.introduce();
  person2.introduce();

  print('\n=== Задача 7: Book ===');
  var book1 = Book('1984', 'Джордж Оруэлл');
  var book2 = Book.unknown();

  book1.displayInfo();
  book2.displayInfo();

  print('\n=== Задачи 8-10: Circle ===');
  var circle = Circle(5.0);

  print('Радиус круга: ${circle.getRadius()}');
  print('Площадь круга: ${circle.area().toStringAsFixed(2)}');

  // Попытка установить отрицательный радиус
  circle.setRadius(-3.0);
  print('Радиус после попытки установить -3: ${circle.getRadius()}');

  // Установка корректного значения
  circle.setRadius(10.0);
  print('Новый радиус: ${circle.getRadius()}');
  print('Новая площадь: ${circle.area().toStringAsFixed(2)}');
}
