// filename: tasks.dart
void main() {
  // 1. Создай список numbers = [2, 5, 8, 11, 14] и выведи только чётные числа.
  List<int> numbers = [2, 5, 8, 11, 14];
  List<int> evens = numbers.where((n) => n % 2 == 0).toList();
  print('1) Чётные числа: $evens'); // [2, 8, 14]

  // 2. С помощью map() создай новый список, где каждый элемент умножен на 3.
  List<int> timesThree = numbers.map((n) => n * 3).toList();
  print('2) Умноженные на 3: $timesThree'); // [6, 15, 24, 33, 42]

  // 3. Напиши функцию, которая принимает список и возвращает только значения больше 10.
  List<int> greaterThanTen(List<int> list) {
    return list.where((x) => x > 10).toList();
  }
  print('3) Значения > 10 из numbers: ${greaterThanTen(numbers)}'); // [11,14]

  // 4. Создай объект student = {'name': 'Аружан', 'score': 90} и добавь поле 'grade': 'A'.
  Map<String, dynamic> student = {'name': 'Аружан', 'score': 90};
  student['grade'] = 'A';
  print('4) Student with grade: $student'); // {name: Аружан, score: 90, grade: A}

  // 5. Создай список объектов студентов и выведи имена тех, у кого score > 80.
  List<Map<String, dynamic>> students = [
    {'name': 'Аружан', 'score': 90},
    {'name': 'Бакыт', 'score': 75},
    {'name': 'Дина', 'score': 82},
    {'name': 'Ерлан', 'score': 60},
  ];
  List<String> highScorers =
      students.where((s) => (s['score'] ?? 0) > 80).map((s) => s['name'] as String).toList();
  print('5) Имена со score > 80: $highScorers'); // [Аружан, Дина]

  // 6. С помощью forEach() выведи все ключи и значения из Map.
  Map<String, String> sampleMap = {'a': 'apple', 'b': 'banana', 'c': 'cherry'};
  print('6) Ключи и значения sampleMap:');
  sampleMap.forEach((key, value) => print('   $key -> $value'));

  // 7. Преобразуй Map в список ключей через .keys.toList().
  List<String> keysList = sampleMap.keys.toList();
  print('7) Список ключей: $keysList'); // [a, b, c]

  // 8. Создай два списка (keys и values) и преврати их в Map.
  List<String> keys = ['id', 'name', 'city'];
  List<dynamic> values = [1, 'Аружан', 'Алматы'];
  Map<String, dynamic> fromIterables = Map.fromIterables(keys, values);
  print('8) Map из ключей и значений: $fromIterables'); // {id:1, name:Аружан, city:Алматы}

  // 9. Напиши код, который удаляет элемент по ключу из Map.
  Map<String, int> ages = {'Аружан': 25, 'Бакыт': 30, 'Дина': 28};
  print('9) До удаления: $ages');
  ages.remove('Бакыт'); // удаляем по ключу
  print('   После удаления ключа "Бакыт": $ages');

  // 10. Реализуй проверку: если ключ отсутствует, добавить его с дефолтным значением.
  // Используем putIfAbsent
  Map<String, String> config = {'theme': 'dark'};
  print('10) До putIfAbsent: $config');
  config.putIfAbsent('language', () => 'ru'); // добавит 'language' если нет
  config.putIfAbsent('theme', () => 'light'); // не перезапишет существующий 'theme'
  print('    После putIfAbsent: $config');
}
