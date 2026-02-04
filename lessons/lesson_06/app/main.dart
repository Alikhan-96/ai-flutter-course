// Dart Functions Practice - Comprehensive Examples
// Author: Alikhan
// Date: November 18, 2025

void main() {
  print('=== Dart Functions Practice ===\n');

  // Task 1.1: Full name function
  print('1. Full Name:');
  String fullName = getFullName('Alikhan', 'Kurmankulov');
  print('Full name: $fullName\n');

  // Task 1.2: Arrow function to check even number
  print('2. Even Number Check:');
  print('Is 4 even? ${isEven(4)}');
  print('Is 7 even? ${isEven(7)}\n');

  // Task 1.3: Named parameters with default value
  print('3. Send Message:');
  sendMessage('Hello, World!');
  sendMessage('Custom message', sender: 'Alikhan');
  print('');

  // Task 1.4: Sum from 1 to 10
  print('4. Sum from 1 to 10:');
  int totalSum = sumOneToTen();
  print('Sum: $totalSum\n');

  // Task 1.5: Calculate function calling other functions
  print('5. Calculate (calling multiple functions):');
  calculate();
  print('');

  // Task 2.1: Simple greeting function
  print('6. Say Hello:');
  sayHello();
  print('');

  // Task 2.2: Square of a number
  print('7. Square:');
  int squareResult = square(5);
  print('Square of 5: $squareResult\n');

  // Task 2.3: Sum function with print
  print('8. Sum function:');
  print('Sum of 3 and 4: ${sum(3, 4)}\n');

  // Task 2.4: Cube arrow function
  print('9. Cube:');
  print('Cube of 3: ${cube(3)}\n');

  // Task 2.5: Required named parameters
  print('10. Show User:');
  showUser(name: 'Alikhan', age: 30);
  print('');

  // Task 2.6: Default parameter value
  print('11. Greet with default:');
  greet();
  greet(name: 'Zhanat');
  print('');

  // Task 2.7: Local variable example
  print('12. Local variable scope:');
  demonstrateLocalScope();
  print('');

  // Task 2.8: Get Pi function
  print('13. Get Pi:');
  print('Pi value: ${getPi()}\n');

  // Task 2.9: Boolean return - check if number is even
  print('14. Check if even (boolean):');
  print('Is 10 even? ${checkIfEven(10)}');
  print('Is 15 even? ${checkIfEven(15)}\n');

  // Task 2.10: Custom function with named parameters
  print('15. Custom function - Create Profile:');
  createProfile(
    username: 'alikhan96',
    email: 'alikhankurmankulov@gmail.com',
    role: 'Data Scientist',
    isActive: true
  );
}

// ========================================
// Task 1.1: Function to get full name
// ========================================
String getFullName(String first, String last) {
  return '$first $last';
}

// ========================================
// Task 1.2: Arrow function to check if number is even
// ========================================
bool isEven(int n) => n % 2 == 0;

// ========================================
// Task 1.3: Function with named parameters and default value
// ========================================
void sendMessage(String text, {String sender = 'Система'}) {
  print('[$sender]: $text');
}

// ========================================
// Task 1.4: Function that returns sum from 1 to 10
// ========================================
int sumOneToTen() {
  int sum = 0;
  for (int i = 1; i <= 10; i++) {
    sum += i;
  }
  return sum;
}

// ========================================
// Task 1.5: Calculate function calling other internal functions
// ========================================
void calculate() {
  // Helper function for sum
  int sumNumbers(int a, int b) {
    return a + b;
  }

  // Helper function for multiplication
  int multiply(int a, int b) {
    return a * b;
  }

  int num1 = 5;
  int num2 = 3;

  int sumResult = sumNumbers(num1, num2);
  int multiplyResult = multiply(num1, num2);

  print('Sum of $num1 and $num2: $sumResult');
  print('Product of $num1 and $num2: $multiplyResult');
}

// ========================================
// Task 2.1: Simple greeting function
// ========================================
void sayHello() {
  print('Привет! Добро пожаловать в мир Dart!');
}

// ========================================
// Task 2.2: Function returning square of a number
// ========================================
int square(int n) {
  return n * n;
}

// ========================================
// Task 2.3: Sum function
// ========================================
int sum(int a, int b) {
  return a + b;
}

// ========================================
// Task 2.4: Arrow function for cube
// ========================================
int cube(int n) => n * n * n;

// ========================================
// Task 2.5: Function with required named parameters
// ========================================
void showUser({required String name, required int age}) {
  print('User: $name, Age: $age');
}

// ========================================
// Task 2.6: Function with default parameter
// ========================================
void greet({String name = 'Гость'}) {
  print('Привет, $name!');
}

// ========================================
// Task 2.7: Demonstration of local variable scope
// ========================================
void demonstrateLocalScope() {
  String localVariable = 'Это локальная переменная';
  print('Inside function: $localVariable');

  // localVariable is not accessible outside this function
  // Uncommenting the line below in main() would cause an error:
  // print(localVariable); // Error!
}

// ========================================
// Task 2.8: Arrow function returning Pi
// ========================================
double getPi() => 3.14;

// ========================================
// Task 2.9: Function returning boolean - check if even
// ========================================
bool checkIfEven(int number) {
  return number % 2 == 0;
}

// ========================================
// Task 2.10: Custom function with named parameters
// ========================================
void createProfile({
  required String username,
  required String email,
  String role = 'User',
  bool isActive = true,
  int credits = 0
}) {
  print('Creating profile...');
  print('Username: $username');
  print('Email: $email');
  print('Role: $role');
  print('Active: $isActive');
  print('Credits: $credits');
}
