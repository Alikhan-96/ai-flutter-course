# Урок 14: ListView и отображение списков

## Основные темы

### ListView.builder
```dart
List<String> tasks = ['Задача 1', 'Задача 2', 'Задача 3'];

ListView.builder(
  itemCount: tasks.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(tasks[index]),
    );
  },
)
```

### ListTile с иконками
```dart
ListTile(
  leading: Icon(Icons.check_box_outline_blank),
  title: Text(tasks[index]),
  subtitle: Text('Описание задачи'),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () {
    print('Выбрана: ${tasks[index]}');
  },
)
```

### ListView.separated с разделителями
```dart
ListView.separated(
  itemCount: tasks.length,
  itemBuilder: (context, index) {
    return ListTile(
      leading: Icon(Icons.task_alt),
      title: Text(tasks[index]),
    );
  },
  separatorBuilder: (context, index) {
    return Divider();
  },
)
```

### Обработка нажатий
```dart
ListTile(
  title: Text(tasks[index]),
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Выбрано: ${tasks[index]}')),
    );
  },
  onLongPress: () {
    // Долгое нажатие
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              // Удаление
              Navigator.pop(context);
            },
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  },
)
```

### Полный пример экрана со списком
```dart
class TasksListScreen extends StatelessWidget {
  final List<String> tasks = [
    'Купить продукты',
    'Позвонить маме',
    'Написать отчёт',
    'Сходить в спортзал',
    'Прочитать книгу',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мои задачи')),
      body: ListView.separated(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(tasks[index]),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Выбрано: ${tasks[index]}'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
```

### Card для элементов списка
```dart
ListView.builder(
  padding: EdgeInsets.all(8),
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(Icons.folder),
        title: Text(items[index].title),
        subtitle: Text(items[index].description),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteItem(index),
        ),
      ),
    );
  },
)
```

## Ключевые концепции
- **ListView.builder** - ленивое создание элементов
- **ListView.separated** - добавляет разделители
- **ListTile** - готовый виджет для элемента списка
- **itemCount** - количество элементов
- **itemBuilder** - функция создания элемента

## Типичные ошибки
- Отсутствие itemCount в ListView.builder
- ListView внутри Column без ограничения высоты
- Забытый ключ key при динамических списках
