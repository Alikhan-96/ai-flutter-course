import 'package:flutter/material.dart';

// Homework 24: Implicit анимации во Flutter

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Implicit Animations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ImplicitAnimationsDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImplicitAnimationsDemo extends StatefulWidget {
  const ImplicitAnimationsDemo({Key? key}) : super(key: key);

  @override
  State<ImplicitAnimationsDemo> createState() => _ImplicitAnimationsDemoState();
}

class _ImplicitAnimationsDemoState extends State<ImplicitAnimationsDemo> {
  // Состояния для анимаций
  bool _expanded = false;
  bool _visible = true;
  bool _alignRight = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit анимации'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. AnimatedContainer
            _buildSectionTitle('AnimatedContainer'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: _expanded ? 200 : 100,
                        height: _expanded ? 200 : 100,
                        decoration: BoxDecoration(
                          color: _expanded ? Colors.blue : Colors.orange,
                          borderRadius: BorderRadius.circular(_expanded ? 100 : 10),
                        ),
                        child: const Center(
                          child: Text(
                            'Нажми',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Нажмите для изменения размера и цвета'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2. AnimatedOpacity
            _buildSectionTitle('AnimatedOpacity'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: _visible ? 1.0 : 0.0,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.green,
                        child: const Center(
                          child: Icon(Icons.visibility, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() => _visible = !_visible),
                      child: Text(_visible ? 'Скрыть' : 'Показать'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 3. AnimatedAlign
            _buildSectionTitle('AnimatedAlign'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      color: Colors.grey[200],
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        alignment: _alignRight
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() => _alignRight = !_alignRight),
                      child: Text(_alignRight ? 'Влево' : 'Вправо'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 4. AnimatedContainer для кнопки загрузки
            _buildSectionTitle('Анимация состояний UI'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isLoading ? 50 : 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLoading,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_isLoading ? 25 : 8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Загрузить'),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 5. AnimatedDefaultTextStyle
            _buildSectionTitle('AnimatedDefaultTextStyle'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: _expanded
                          ? const TextStyle(
                              fontSize: 28,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            )
                          : const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                      child: const Text('Анимированный текст'),
                    ),
                    const SizedBox(height: 8),
                    const Text('(Нажмите на AnimatedContainer выше)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _handleLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }
}
