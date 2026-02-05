import 'package:flutter/material.dart';

// Homework 26: Advanced анимации - Hero, AnimatedList, PageView

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Animations',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const AdvancedAnimationsDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdvancedAnimationsDemo extends StatelessWidget {
  const AdvancedAnimationsDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Animations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Animation Demo
          _buildDemoCard(
            context,
            'Hero Animation',
            'Плавный переход изображения между экранами',
            Icons.photo_library,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HeroListScreen()),
            ),
          ),

          // AnimatedList Demo
          _buildDemoCard(
            context,
            'AnimatedList',
            'Анимированное добавление/удаление элементов',
            Icons.list,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnimatedListDemo()),
            ),
          ),

          // Onboarding Demo
          _buildDemoCard(
            context,
            'Onboarding PageView',
            'Экраны приветствия с индикаторами',
            Icons.swipe,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingScreen()),
            ),
          ),

          // AnimatedSwitcher Demo
          _buildDemoCard(
            context,
            'AnimatedSwitcher',
            'Плавная смена контента',
            Icons.swap_horiz,
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnimatedSwitcherDemo()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

// Hero Animation Demo with Staggered Animations
class HeroListScreen extends StatelessWidget {
  const HeroListScreen({Key? key}) : super(key: key);

  static const _items = [
    {'name': 'Горы', 'location': 'Швейцария'},
    {'name': 'Океан', 'location': 'Мальдивы'},
    {'name': 'Лес', 'location': 'Канада'},
    {'name': 'Город', 'location': 'Токио'},
    {'name': 'Пустыня', 'location': 'Сахара'},
    {'name': 'Архитектура', 'location': 'Париж'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Animation'),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HeroDetailScreen(
                    index: index,
                    name: item['name']!,
                    location: item['location']!,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'image-$index',
                      child: Image.network(
                        'https://picsum.photos/300/300?random=$index',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              item['location']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HeroDetailScreen extends StatefulWidget {
  final int index;
  final String name;
  final String location;

  const HeroDetailScreen({
    Key? key,
    required this.index,
    required this.name,
    required this.location,
  }) : super(key: key);

  @override
  State<HeroDetailScreen> createState() => _HeroDetailScreenState();
}

class _HeroDetailScreenState extends State<HeroDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  late Animation<double> _locationAnimation;
  late Animation<double> _descriptionAnimation;
  late Animation<double> _statsAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Staggered animations with intervals
    _titleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _locationAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );
    _descriptionAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    );
    _statsAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    );
    _buttonAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'image-${widget.index}',
                child: Image.network(
                  'https://picsum.photos/800/800?random=${widget.index}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with fade and slide animation
                  FadeTransition(
                    opacity: _titleAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_titleAnimation),
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Location with animation
                  FadeTransition(
                    opacity: _locationAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_locationAnimation),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Text(
                            widget.location,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description with animation
                  FadeTransition(
                    opacity: _descriptionAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_descriptionAnimation),
                      child: const Text(
                        'Это потрясающее место для путешествия. '
                        'Здесь вы найдете невероятные виды, '
                        'уникальную культуру и незабываемые впечатления. '
                        'Идеальное место для отдыха и открытия нового.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Stats with animation
                  FadeTransition(
                    opacity: _statsAnimation,
                    child: ScaleTransition(
                      scale: _statsAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard('4.8', 'Рейтинг', Icons.star),
                          _buildStatCard('1.2k', 'Отзывы', Icons.comment),
                          _buildStatCard('5k+', 'Фото', Icons.photo_library),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Button with animation
                  FadeTransition(
                    opacity: _buttonAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_buttonAnimation),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Забронировать',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// AnimatedList Demo
class AnimatedListDemo extends StatefulWidget {
  const AnimatedListDemo({Key? key}) : super(key: key);

  @override
  State<AnimatedListDemo> createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  final _listKey = GlobalKey<AnimatedListState>();
  final _items = <String>[];
  int _counter = 0;

  void _addItem() {
    _counter++;
    final index = _items.length;
    _items.add('Элемент $_counter');
    _listKey.currentState?.insertItem(index);
  }

  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation),
    );
  }

  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.star)),
          title: Text(item),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              final index = _items.indexOf(item);
              if (index != -1) _removeItem(index);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedList')),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_items[index], animation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Onboarding Demo with Staggered Animations
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = [
    {
      'title': 'Добро пожаловать',
      'description': 'Откройте для себя новый мир возможностей и функций',
      'color': Colors.blue,
      'icon': Icons.waving_hand,
    },
    {
      'title': 'Мощные возможности',
      'description': 'Используйте передовые инструменты для достижения целей',
      'color': Colors.green,
      'icon': Icons.star,
    },
    {
      'title': 'Начнем!',
      'description': 'Все готово для начала вашего путешествия',
      'color': Colors.orange,
      'icon': Icons.rocket_launch,
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _skipOnboarding() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: _pages[index]['title'] as String,
                description: _pages[index]['description'] as String,
                color: _pages[index]['color'] as Color,
                icon: _pages[index]['icon'] as IconData,
              );
            },
          ),

          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _skipOnboarding,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Пропустить',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // Bottom section with indicators and button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Next/Finish button
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      key: ValueKey<int>(_currentPage),
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _pages[_currentPage]['color'] as Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Начать' : 'Далее',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _descriptionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Staggered animations
    _iconAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    );
    _titleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    );
    _descriptionAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.color,
            widget.color.withOpacity(0.7),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated icon
              ScaleTransition(
                scale: _iconAnimation,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // Animated title
              FadeTransition(
                opacity: _titleAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(_titleAnimation),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Animated description
              FadeTransition(
                opacity: _descriptionAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(_descriptionAnimation),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AnimatedSwitcher Demo
class AnimatedSwitcherDemo extends StatefulWidget {
  const AnimatedSwitcherDemo({Key? key}) : super(key: key);

  @override
  State<AnimatedSwitcherDemo> createState() => _AnimatedSwitcherDemoState();
}

class _AnimatedSwitcherDemoState extends State<AnimatedSwitcherDemo> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedSwitcher')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Text(
                '$_counter',
                key: ValueKey<int>(_counter),
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'minus',
                  onPressed: () => setState(() => _counter--),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'plus',
                  onPressed: () => setState(() => _counter++),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
