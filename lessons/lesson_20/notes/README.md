# Урок 20: Мини-проект - Полноценное приложение

## Основные темы

### Планирование приложения
1. Выбор идеи (заметки, задачи, каталог)
2. Определение экранов
3. Определение моделей данных
4. Выбор подхода к состоянию

### Структура проекта
```
lib/
├── main.dart
├── models/
│   └── note.dart
├── screens/
│   ├── home_screen.dart
│   ├── detail_screen.dart
│   └── add_edit_screen.dart
├── providers/
│   └── notes_provider.dart
└── widgets/
    └── note_card.dart
```

### Модель данных
```dart
// lib/models/note.dart
class Note {
  final String id;
  String title;
  String content;
  DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}
```

### Provider для состояния
```dart
// lib/providers/notes_provider.dart
import 'package:flutter/foundation.dart';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void updateNote(String id, String title, String content) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index].title = title;
      _notes[index].content = content;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
```

### Главный экран со списком
```dart
// lib/screens/home_screen.dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NotesProvider>().notes;

    return Scaffold(
      appBar: AppBar(title: Text('Мои заметки')),
      body: notes.isEmpty
          ? Center(child: Text('Нет заметок'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(note: note),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Экран деталей
```dart
// lib/screens/detail_screen.dart
class DetailScreen extends StatelessWidget {
  final Note note;

  DetailScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditScreen(note: note),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              context.read<NotesProvider>().deleteNote(note.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text(note.content),
      ),
    );
  }
}
```

### Экран добавления/редактирования
```dart
// lib/screens/add_edit_screen.dart
class AddEditScreen extends StatefulWidget {
  final Note? note;

  AddEditScreen({this.note});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать' : 'Новая заметка'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Заголовок'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Содержание'),
                maxLines: null,
                expands: true,
              ),
            ),
            ElevatedButton(
              onPressed: _save,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final provider = context.read<NotesProvider>();

    if (widget.note != null) {
      provider.updateNote(
        widget.note!.id,
        _titleController.text,
        _contentController.text,
      );
    } else {
      provider.addNote(Note(
        id: DateTime.now().toString(),
        title: _titleController.text,
        content: _contentController.text,
        createdAt: DateTime.now(),
      ));
    }

    Navigator.pop(context);
  }
}
```

## Ключевые концепции
- Разделение на слои (models, screens, providers)
- CRUD операции (Create, Read, Update, Delete)
- Навигация между экранами
- Передача данных через конструкторы

## Чеклист готовности
- [ ] Список элементов отображается
- [ ] Переход на детали работает
- [ ] Добавление нового элемента работает
- [ ] Редактирование работает
- [ ] Удаление работает
- [ ] UI оформлен (AppBar, Card, иконки)
