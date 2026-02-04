# Урок 12: Формы и валидация

## Основные темы

### Form и GlobalKey
```dart
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Поля формы
        ],
      ),
    );
  }
}
```

### TextFormField с валидацией
```dart
TextFormField(
  controller: _emailController,
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'example@mail.com',
    prefixIcon: Icon(Icons.email),
    border: OutlineInputBorder(),
  ),
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    if (!value.contains('@')) {
      return 'Некорректный email';
    }
    return null;
  },
)

// Поле пароля
TextFormField(
  controller: _passwordController,
  decoration: InputDecoration(
    labelText: 'Пароль',
    prefixIcon: Icon(Icons.lock),
    border: OutlineInputBorder(),
  ),
  obscureText: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 6) {
      return 'Минимум 6 символов';
    }
    return null;
  },
)
```

### Валидация и отправка формы
```dart
ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      // Форма валидна
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Вход выполнен!')),
      );

      // Очистка полей
      _emailController.clear();
      _passwordController.clear();
    }
  },
  child: Text('Войти'),
)
```

### Полный пример формы
```dart
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вход')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Обязательное поле';
                  if (!value!.contains('@')) return 'Некорректный email';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Обязательное поле';
                  if (value!.length < 6) return 'Минимум 6 символов';
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }
}
```

## Ключевые концепции
- **GlobalKey<FormState>** - ключ для доступа к состоянию формы
- **TextEditingController** - управление текстом в поле
- **validator** - функция валидации (null = валидно)
- **validate()** - запуск валидации всех полей

## Типичные ошибки
- Забытый dispose() для контроллеров
- Неправильный ключ формы
- Отсутствие проверки на null в валидаторе
