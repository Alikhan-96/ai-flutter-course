import 'dart:math' as math;
import 'package:flutter/material.dart';

// Homework 25: Explicit анимации во Flutter

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explicit Animations',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const ExplicitAnimationsDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExplicitAnimationsDemo extends StatefulWidget {
  const ExplicitAnimationsDemo({Key? key}) : super(key: key);

  @override
  State<ExplicitAnimationsDemo> createState() => _ExplicitAnimationsDemoState();
}

class _ExplicitAnimationsDemoState extends State<ExplicitAnimationsDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Создаём AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Анимация масштаба
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // Анимация вращения
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Анимация смещения
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.5, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit анимации'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Кнопки управления
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Управление анимацией',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _controller.forward(),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Forward'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _controller.reverse(),
                          icon: const Icon(Icons.replay),
                          label: const Text('Reverse'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _controller.stop(),
                          icon: const Icon(Icons.stop),
                          label: const Text('Stop'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _controller.reset(),
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Reset'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _controller.repeat(reverse: true),
                          icon: const Icon(Icons.repeat),
                          label: const Text('Repeat'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Анимация масштаба
            _buildSectionTitle('ScaleTransition'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.zoom_out_map,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Анимация вращения
            _buildSectionTitle('RotationTransition'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Анимация смещения
            _buildSectionTitle('SlideTransition'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Комбинированная анимация
            _buildSectionTitle('Комбинированная анимация'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.pink],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Информация о состоянии
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Value: ${_controller.value.toStringAsFixed(2)}',
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: _controller.value),
                      ],
                    ),
                  ),
                );
              },
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
}
