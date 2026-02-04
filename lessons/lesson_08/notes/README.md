# Урок 8: ООП - Наследование и полиморфизм

## Основные темы

### Полиморфизм
```dart
class Shape {
  double area() => 0;
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);

  @override
  double area() => 3.14 * radius * radius;
}

class Square extends Shape {
  double side;
  Square(this.side);

  @override
  double area() => side * side;
}

// Полиморфизм в действии
List<Shape> shapes = [Circle(5), Square(4)];
for (var shape in shapes) {
  print(shape.area());  // Вызывается правильный метод
}
```

### Абстрактные классы
```dart
abstract class Animal {
  void sound();  // Абстрактный метод

  void breathe() {
    print('Дышит');
  }
}

class Bird extends Animal {
  @override
  void sound() => print('Чирик!');
}

class Fish extends Animal {
  @override
  void sound() => print('...');
}
```

### Работа с приватными полями
```dart
class Account {
  double _balance = 0;

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
    }
  }

  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
    }
  }

  double getBalance() => _balance;
}
```

### Композиция классов
```dart
class Bank {
  List<Account> accounts = [];

  void addAccount(Account account) {
    accounts.add(account);
  }

  double getTotalBalance() {
    double total = 0;
    for (var account in accounts) {
      total += account.getBalance();
    }
    return total;
  }
}
```

### Демонстрация полиморфизма
```dart
class Person {
  String name;
  Person(this.name);

  void introduce() => print('Я $name');
}

class Student extends Person {
  Student(String name) : super(name);

  @override
  void introduce() => print('Я студент $name');
}

class Teacher extends Person {
  Teacher(String name) : super(name);

  @override
  void introduce() => print('Я преподаватель $name');
}

// Использование
List<Person> people = [Student('Алия'), Teacher('Бекзат')];
for (var person in people) {
  person.introduce();  // Вызывается соответствующий метод
}
```

## Ключевые концепции
- **Полиморфизм** - один интерфейс, разные реализации
- **Абстрактный класс** - нельзя создать экземпляр напрямую
- **Абстрактный метод** - метод без реализации
- **Композиция** - класс содержит другие объекты

## Типичные ошибки
- Попытка создать экземпляр абстрактного класса
- Забытая реализация абстрактного метода
- Неправильное приведение типов при полиморфизме
