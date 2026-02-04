import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CounterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Класс CounterModel с методами loadCounter() и saveCounter()
class CounterModel {
  int counter = 0;

  // Загрузка сохранённого значения из SharedPreferences
  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('counter') ?? 0;
  }

  // Сохранение текущего значения в SharedPreferences
  Future<void> saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
  }

  // Метод increment() - увеличивает counter на 1 и сохраняет
  void increment() {
    counter++;
    saveCounter();
  }

  // Дополнительно: метод для сброса счётчика
  void reset() {
    counter = 0;
    saveCounter();
  }
}

// StatefulWidget CounterPage
class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // Переменная counterModel
  final counterModel = CounterModel();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Асинхронная загрузка значения счётчика
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    await counterModel.loadCounter();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Счётчик с сохранением'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Кнопка сброса
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              counterModel.reset();
              setState(() {});
            },
            tooltip: 'Сбросить счётчик',
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Счётчик:',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  // Отображение текущего значения счётчика
                  Text(
                    '${counterModel.counter}',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Кнопка увеличения счётчика
                  ElevatedButton.icon(
                    onPressed: () {
                      counterModel.increment();
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Увеличить',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Значение сохраняется между запусками!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
