import 'dart:io';

void main() {
  print('=== ОСНОВНЫЕ ЗАДАЧИ ===\n');

  // Задача 1: Сумма и разность двух чисел
  task1();

  // Задача 2: Кратность 5
  task2();

  // Задача 3: Максимум из трёх чисел
  task3();

  // Задача 4: Диапазон 100-999
  task4();

  // Задача 5: Логин и пароль
  task5();

  // Задача 6: Тернарный оператор для возраста
  task6();

  // Задача 7: Категория BMI
  task7();

  // Задача 8: Делимость на 4 и 6
  task8();

  // Задача 9: Проверка пустой строки
  task9();

  // Задача 10: Вложенный if для возраста и прав
  task10();

  print('\n=== БОНУСНЫЕ ЗАДАЧИ ===\n');

  // Бонус 1: Калькулятор
  bonus1();

  // Бонус 2: Оценки с вложенными условиями
  bonus2();

  // Бонус 3: Имя начинается с 'A'
  bonus3();

  // Бонус 4: День недели
  bonus4();

  // Бонус 5: Делимость на 3 и 5
  bonus5();
}

// ================== ОСНОВНЫЕ ЗАДАЧИ ==================

// Задача 1: Сумма и разность
void task1() {
  print('Задача 1: Сумма и разность двух чисел');
  print('Введите первое число:');
  double num1 = double.parse(stdin.readLineSync()!);

  print('Введите второе число:');
  double num2 = double.parse(stdin.readLineSync()!);

  double sum = num1 + num2;
  double difference = num1 - num2;

  print('Сумма: $sum');
  print('Разность: $difference\n');
}

// Задача 2: Кратность 5
void task2() {
  print('Задача 2: Проверка кратности 5');
  print('Введите число:');
  int number = int.parse(stdin.readLineSync()!);

  if (number % 5 == 0) {
    print('Число $number кратно 5\n');
  } else {
    print('Число $number НЕ кратно 5\n');
  }
}

// Задача 3: Максимум из трёх чисел
void task3() {
  print('Задача 3: Определение максимального из трёх чисел');
  print('Введите первое число:');
  double num1 = double.parse(stdin.readLineSync()!);

  print('Введите второе число:');
  double num2 = double.parse(stdin.readLineSync()!);

  print('Введите третье число:');
  double num3 = double.parse(stdin.readLineSync()!);

  double max = num1;

  if (num2 > max) {
    max = num2;
  }
  if (num3 > max) {
    max = num3;
  }

  print('Максимальное число: $max\n');
}

// Задача 4: Диапазон 100-999
void task4() {
  print('Задача 4: Проверка попадания в диапазон 100-999');
  print('Введите число:');
  int number = int.parse(stdin.readLineSync()!);

  if (number >= 100 && number <= 999) {
    print('Число $number находится в диапазоне от 100 до 999\n');
  } else {
    print('Число $number НЕ находится в диапазоне от 100 до 999\n');
  }
}

// Задача 5: Логин и пароль
void task5() {
  print('Задача 5: Проверка логина и пароля');
  print('Введите логин:');
  String login = stdin.readLineSync()!;

  print('Введите пароль:');
  String password = stdin.readLineSync()!;

  if (login == 'admin' && password == 'dart123') {
    print('Вход выполнен успешно!\n');
  } else {
    print('Неверный логин или пароль\n');
  }
}

// Задача 6: Тернарный оператор для возраста
void task6() {
  print('Задача 6: Проверка совершеннолетия (тернарный оператор)');
  print('Введите возраст:');
  int age = int.parse(stdin.readLineSync()!);

  String result = age >= 18 ? 'Взрослый' : 'Несовершеннолетний';
  print('Статус: $result\n');
}

// Задача 7: Категория BMI
void task7() {
  print('Задача 7: Определение категории по BMI');
  print('Введите ваш BMI:');
  double bmi = double.parse(stdin.readLineSync()!);

  String category;

  if (bmi < 18.5) {
    category = 'Недостаточный вес';
  } else if (bmi >= 18.5 && bmi < 25) {
    category = 'Нормальный вес';
  } else if (bmi >= 25 && bmi < 30) {
    category = 'Избыточный вес';
  } else {
    category = 'Ожирение';
  }

  print('Категория: $category\n');
}

// Задача 8: Делимость на 4 и 6
void task8() {
  print('Задача 8: Проверка делимости на 4 и 6 одновременно');
  print('Введите число:');
  int number = int.parse(stdin.readLineSync()!);

  if (number % 4 == 0 && number % 6 == 0) {
    print('Число $number делится одновременно на 4 и 6\n');
  } else {
    print('Число $number НЕ делится одновременно на 4 и 6\n');
  }
}

// Задача 9: Проверка пустой строки
void task9() {
  print('Задача 9: Проверка пустой строки');
  print('Введите строку:');
  String input = stdin.readLineSync()!;

  if (input.isEmpty) {
    print('Строка пуста\n');
  } else {
    print('Строка не пуста. Содержимое: "$input"\n');
  }
}

// Задача 10: Вложенный if
void task10() {
  print('Задача 10: Проверка возраста и водительского удостоверения');
  print('Введите возраст:');
  int age = int.parse(stdin.readLineSync()!);

  if (age < 18) {
    print('Несовершеннолетний\n');
  } else {
    print('Есть ли у вас водительское удостоверение? (да/нет):');
    String hasLicense = stdin.readLineSync()!.toLowerCase();

    if (hasLicense == 'да' || hasLicense == 'yes') {
      print('Вы можете управлять автомобилем\n');
    } else {
      print('Вам необходимо получить водительское удостоверение\n');
    }
  }
}

// ================== БОНУСНЫЕ ЗАДАЧИ ==================

// Бонус 1: Калькулятор
void bonus1() {
  print('Бонус 1: Калькулятор с четырьмя операциями');
  print('Введите первое число:');
  double num1 = double.parse(stdin.readLineSync()!);

  print('Введите оператор (+, -, *, /):');
  String operator = stdin.readLineSync()!;

  print('Введите второе число:');
  double num2 = double.parse(stdin.readLineSync()!);

  double result;

  if (operator == '+') {
    result = num1 + num2;
    print('Результат: $num1 + $num2 = $result\n');
  } else if (operator == '-') {
    result = num1 - num2;
    print('Результат: $num1 - $num2 = $result\n');
  } else if (operator == '*') {
    result = num1 * num2;
    print('Результат: $num1 * $num2 = $result\n');
  } else if (operator == '/') {
    if (num2 != 0) {
      result = num1 / num2;
      print('Результат: $num1 / $num2 = $result\n');
    } else {
      print('Ошибка: Деление на ноль!\n');
    }
  } else {
    print('Ошибка: Неизвестный оператор\n');
  }
}

// Бонус 2: Оценки
void bonus2() {
  print('Бонус 2: Определение оценки по баллам');
  print('Введите количество баллов (0-100):');
  int score = int.parse(stdin.readLineSync()!);

  String grade;

  if (score >= 0 && score <= 100) {
    if (score >= 90) {
      grade = 'A (Отлично)';
    } else if (score >= 80) {
      grade = 'B (Хорошо)';
    } else if (score >= 70) {
      grade = 'C (Удовлетворительно)';
    } else if (score >= 60) {
      grade = 'D (Посредственно)';
    } else {
      grade = 'F (Неудовлетворительно)';
    }
    print('Оценка: $grade\n');
  } else {
    print('Ошибка: Баллы должны быть от 0 до 100\n');
  }
}

// Бонус 3: Имя начинается с 'A'
void bonus3() {
  print('Бонус 3: Проверка имени на букву A');
  print('Введите имя:');
  String name = stdin.readLineSync()!;

  if (name.isNotEmpty && name[0].toUpperCase() == 'A') {
    print('Имя "$name" начинается с буквы A\n');
  } else if (name.isEmpty) {
    print('Имя не может быть пустым\n');
  } else {
    print('Имя "$name" НЕ начинается с буквы A\n');
  }
}

// Бонус 4: День недели
void bonus4() {
  print('Бонус 4: Определение дня недели по номеру');
  print('Введите номер дня (1-7):');
  int day = int.parse(stdin.readLineSync()!);

  String dayName;

  if (day == 1) {
    dayName = 'Понедельник';
  } else if (day == 2) {
    dayName = 'Вторник';
  } else if (day == 3) {
    dayName = 'Среда';
  } else if (day == 4) {
    dayName = 'Четверг';
  } else if (day == 5) {
    dayName = 'Пятница';
  } else if (day == 6) {
    dayName = 'Суббота';
  } else if (day == 7) {
    dayName = 'Воскресенье';
  } else {
    dayName = 'Ошибка: Неверный номер дня';
  }

  print('День недели: $dayName\n');
}

// Бонус 5: Делимость на 3 и 5
void bonus5() {
  print('Бонус 5: Проверка делимости на 3 и 5 одновременно');
  print('Введите число:');
  int number = int.parse(stdin.readLineSync()!);

  if (number % 3 == 0 && number % 5 == 0) {
    print('Число $number делится одновременно на 3 и 5\n');
  } else {
    print('Число $number НЕ делится одновременно на 3 и 5\n');
  }
}
