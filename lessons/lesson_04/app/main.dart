// A1. Сумма 1..n
int sumOneToN(int n) {
  if (n <= 0) return 0;

  int sum = 0;
  for (int i = 1; i <= n; i++) {
    sum += i;
  }
  return sum;
}

// A2. Сумма элементов списка
int sumList(List<int> list) {
  int sum = 0;
  for (int element in list) {
    sum += element;
  }
  return sum;
}

// A3. Минимум и максимум
(int, int) minMax(List<int> list) {
  if (list.isEmpty) {
    throw ArgumentError('Список не может быть пустым');
  }

  int min = list[0];
  int max = list[0];

  for (int element in list) {
    if (element < min) min = element;
    if (element > max) max = element;
  }

  return (min, max);
}

// A4. Количество чётных
int countEven(List<int> list) {
  int count = 0;
  for (int element in list) {
    if (element % 2 == 0) {
      count++;
    }
  }
  return count;
}

// A5. Разворот списка (без .reversed)
List<int> reverseList(List<int> list) {
  List<int> result = [];
  for (int i = list.length - 1; i >= 0; i--) {
    result.add(list[i]);
  }
  return result;
}

// A6. Фильтр "неотрицательные"
List<int> filterNonNegative(List<int> list) {
  List<int> result = [];
  for (int element in list) {
    if (element >= 0) {
      result.add(element);
    }
  }
  return result;
}

// A7. Удалить все вхождения x
List<int> removeAll(List<int> list, int x) {
  List<int> result = [];
  for (int element in list) {
    if (element != x) {
      result.add(element);
    }
  }
  return result;
}

// A8. Кол-во уникальных элементов (через Set)
int countUnique(List<int> list) {
  Set<int> uniqueElements = Set<int>.from(list);
  return uniqueElements.length;
}

// A9. Удалить дубликаты, сохранив порядок первой встречи
List<int> removeDuplicates(List<int> list) {
  Set<int> seen = {};
  List<int> result = [];

  for (int element in list) {
    if (!seen.contains(element)) {
      seen.add(element);
      result.add(element);
    }
  }

  return result;
}

// Тесты
void main() {
  print('=== A1. Сумма 1..n ===');
  print('sumOneToN(5) = ${sumOneToN(5)}'); // Ожидается: 15
  print('sumOneToN(1) = ${sumOneToN(1)}'); // Ожидается: 1
  print('sumOneToN(0) = ${sumOneToN(0)}'); // Ожидается: 0
  print('sumOneToN(-5) = ${sumOneToN(-5)}'); // Ожидается: 0

  print('\n=== A2. Сумма элементов списка ===');
  print('sumList([1,2,3]) = ${sumList([1, 2, 3])}'); // Ожидается: 6
  print('sumList([]) = ${sumList([])}'); // Ожидается: 0
  print('sumList([10]) = ${sumList([10])}'); // Ожидается: 10

  print('\n=== A3. Минимум и максимум ===');
  print('minMax([3,1,7]) = ${minMax([3, 1, 7])}'); // Ожидается: (1, 7)
  print('minMax([5]) = ${minMax([5])}'); // Ожидается: (5, 5)
  print('minMax([10,-5,20]) = ${minMax([10, -5, 20])}'); // Ожидается: (-5, 20)
  try {
    print('minMax([]) = ${minMax([])}');
  } catch (e) {
    print('minMax([]) вызвал ошибку: $e'); // Ожидается ошибка
  }

  print('\n=== A4. Количество чётных ===');
  print('countEven([1,2,4,5]) = ${countEven([1, 2, 4, 5])}'); // Ожидается: 2
  print('countEven([]) = ${countEven([])}'); // Ожидается: 0
  print('countEven([1,3,5]) = ${countEven([1, 3, 5])}'); // Ожидается: 0
  print('countEven([2,4,6]) = ${countEven([2, 4, 6])}'); // Ожидается: 3

  print('\n=== A5. Разворот списка ===');
  print('reverseList([1,2,3]) = ${reverseList([1, 2, 3])}'); // Ожидается: [3, 2, 1]
  print('reverseList([]) = ${reverseList([])}'); // Ожидается: []
  print('reverseList([5]) = ${reverseList([5])}'); // Ожидается: [5]

  print('\n=== A6. Фильтр "неотрицательные" ===');
  print('filterNonNegative([-2,0,3]) = ${filterNonNegative([-2, 0, 3])}'); // Ожидается: [0, 3]
  print('filterNonNegative([-1,-5]) = ${filterNonNegative([-1, -5])}'); // Ожидается: []
  print('filterNonNegative([1,2,3]) = ${filterNonNegative([1, 2, 3])}'); // Ожидается: [1, 2, 3]

  print('\n=== A7. Удалить все вхождения x ===');
  print('removeAll([1,2,2,3], 2) = ${removeAll([1, 2, 2, 3], 2)}'); // Ожидается: [1, 3]
  print('removeAll([2,2], 2) = ${removeAll([2, 2], 2)}'); // Ожидается: []
  print('removeAll([1,2,3], 5) = ${removeAll([1, 2, 3], 5)}'); // Ожидается: [1, 2, 3]

  print('\n=== A8. Кол-во уникальных элементов ===');
  print('countUnique([1,1,2]) = ${countUnique([1, 1, 2])}'); // Ожидается: 2
  print('countUnique([]) = ${countUnique([])}'); // Ожидается: 0
  print('countUnique([5,5,5]) = ${countUnique([5, 5, 5])}'); // Ожидается: 1
  print('countUnique([1,2,3,4]) = ${countUnique([1, 2, 3, 4])}'); // Ожидается: 4

  print('\n=== A9. Удалить дубликаты, сохранив порядок ===');
  print('removeDuplicates([1,2,1,3,2]) = ${removeDuplicates([1, 2, 1, 3, 2])}'); // Ожидается: [1, 2, 3]
  print('removeDuplicates([4,4,4]) = ${removeDuplicates([4, 4, 4])}'); // Ожидается: [4]
  print('removeDuplicates([]) = ${removeDuplicates([])}'); // Ожидается: []
  print('removeDuplicates([1,2,3]) = ${removeDuplicates([1, 2, 3])}'); // Ожидается: [1, 2, 3]
}
