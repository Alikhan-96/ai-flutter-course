import 'package:flutter/material.dart';

// Homework 22: Анализ и оптимизация кода с помощью ИИ
// Этот код был проанализирован и оптимизирован с помощью ИИ

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Analysis Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const CodeAnalysisDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CodeAnalysisDemo extends StatefulWidget {
  const CodeAnalysisDemo({Key? key}) : super(key: key);

  @override
  State<CodeAnalysisDemo> createState() => _CodeAnalysisDemoState();
}

class _CodeAnalysisDemoState extends State<CodeAnalysisDemo> {
  // Список примеров до/после оптимизации
  final List<CodeExample> examples = [
    CodeExample(
      title: 'Упрощение условия',
      before: '''
if (value == true) {
  return true;
} else {
  return false;
}''',
      after: 'return value;',
      explanation: 'Прямое возвращение значения вместо избыточного условия',
    ),
    CodeExample(
      title: 'Использование правильного виджета',
      before: '''
Container(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)''',
      after: '''
Padding(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)''',
      explanation: 'Padding более эффективен когда нужен только отступ',
    ),
    CodeExample(
      title: 'Null-aware оператор',
      before: '''
String name;
if (user != null) {
  name = user.name;
} else {
  name = 'Guest';
}''',
      after: "String name = user?.name ?? 'Guest';",
      explanation: 'Использование ?. и ?? для краткости',
    ),
    CodeExample(
      title: 'Spread оператор',
      before: '''
List<int> combined = [];
combined.addAll(list1);
combined.addAll(list2);''',
      after: 'List<int> combined = [...list1, ...list2];',
      explanation: 'Spread оператор для объединения списков',
    ),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final example = examples[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Анализ кода с ИИ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Прогресс
            LinearProgressIndicator(
              value: (_currentIndex + 1) / examples.length,
            ),
            const SizedBox(height: 8),
            Text(
              'Пример ${_currentIndex + 1} из ${examples.length}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Заголовок примера
            Text(
              example.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // До оптимизации
            _buildCodeCard(
              'До оптимизации',
              example.before,
              Colors.red.shade50,
              Icons.code_off,
            ),
            const SizedBox(height: 16),

            // После оптимизации
            _buildCodeCard(
              'После оптимизации',
              example.after,
              Colors.green.shade50,
              Icons.code,
            ),
            const SizedBox(height: 16),

            // Объяснение
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        example.explanation,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Навигация
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentIndex > 0
                        ? () => setState(() => _currentIndex--)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Назад'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentIndex < examples.length - 1
                        ? () => setState(() => _currentIndex++)
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Далее'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeCard(String title, String code, Color bgColor, IconData icon) {
    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeExample {
  final String title;
  final String before;
  final String after;
  final String explanation;

  CodeExample({
    required this.title,
    required this.before,
    required this.after,
    required this.explanation,
  });
}
