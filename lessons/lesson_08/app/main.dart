import 'dart:math';

// Задачи 1-3: Animal, Bird, Fish
class Animal {
  void sound() {
    print('Animal makes a sound');
  }
}

class Bird extends Animal {
  @override
  void sound() {
    print('Bird chirps: Tweet tweet!');
  }
}

class Fish extends Animal {
  @override
  void sound() {
    print('Fish blubs: Blub blub!');
  }
}

// Задача 4: Account с приватным полем
class Account {
  double _balance = 0.0;

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print('Deposited: \$${amount.toStringAsFixed(2)}');
    }
  }

  double getBalance() {
    return _balance;
  }
}

// Задачи 5-7: Shape, Circle, Square
abstract class Shape {
  double area();
}

class Circle extends Shape {
  final double radius;

  Circle(this.radius);

  @override
  double area() {
    return pi * radius * radius;
  }
}

class Square extends Shape {
  final double side;

  Square(this.side);

  @override
  double area() {
    return side * side;
  }
}

// Задача 8: Person, Student, Teacher
class Person {
  final String name;

  Person(this.name);

  void introduce() {
    print('Hello, I am $name');
  }
}

class Student extends Person {
  final String major;

  Student(String name, this.major) : super(name);

  @override
  void introduce() {
    print('Hello, I am $name, a student studying $major');
  }
}

class Teacher extends Person {
  final String subject;

  Teacher(String name, this.subject) : super(name);

  @override
  void introduce() {
    print('Hello, I am $name, a teacher of $subject');
  }
}

// Задача 9: Bank
class Bank {
  final List<Account> _accounts = [];

  void addAccount(Account account) {
    _accounts.add(account);
  }

  double getTotalBalance() {
    double total = 0;
    for (var account in _accounts) {
      total += account.getBalance();
    }
    return total;
  }
}

void main() {
  print('=== Задачи 1-3: Животные ===');
  List<Animal> animals = [Bird(), Fish(), Bird(), Fish()];
  for (var animal in animals) {
    animal.sound();
  }

  print('\n=== Задача 4: Account ===');
  Account myAccount = Account();
  myAccount.deposit(100);
  myAccount.deposit(250.50);
  print('Current balance: \$${myAccount.getBalance().toStringAsFixed(2)}');

  print('\n=== Задачи 5-7: Shapes ===');
  List<Shape> shapes = [
    Circle(5),
    Square(4),
    Circle(3.5),
    Square(6),
  ];

  for (var i = 0; i < shapes.length; i++) {
    var shape = shapes[i];
    if (shape is Circle) {
      print('Circle with radius ${shape.radius}: area = ${shape.area().toStringAsFixed(2)}');
    } else if (shape is Square) {
      print('Square with side ${shape.side}: area = ${shape.area().toStringAsFixed(2)}');
    }
  }

  print('\n=== Задача 8: Person, Student, Teacher ===');
  Student student = Student('Alikhan', 'Data Science');
  Teacher teacher = Teacher('Zhanat', 'Computer Science');

  student.introduce();
  teacher.introduce();

  print('\n=== Задача 9: Bank ===');
  Bank bank = Bank();

  Account acc1 = Account();
  acc1.deposit(1000);

  Account acc2 = Account();
  acc2.deposit(2500);

  Account acc3 = Account();
  acc3.deposit(750.75);

  bank.addAccount(acc1);
  bank.addAccount(acc2);
  bank.addAccount(acc3);

  print('Total bank balance: \$${bank.getTotalBalance().toStringAsFixed(2)}');

  print('\n=== Задача 10: Полиморфизм ===');
  List<Person> people = [
    Student('Aidar', 'Engineering'),
    Teacher('Nurlan', 'Mathematics'),
    Student('Assel', 'Medicine'),
    Teacher('Saule', 'Physics'),
  ];

  print('Demonstrating polymorphism:');
  for (var person in people) {
    person.introduce();
  }
}
