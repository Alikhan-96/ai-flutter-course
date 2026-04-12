# Lesson 31: Popular Flutter Packages

## Lecture Overview

**Topic**: Essential Flutter packages for real-world applications

### Key Packages Covered

#### 1. freezed + json_serializable
**Purpose**: Immutable data classes with JSON serialization

- **freezed**: Generates immutable data classes with copy, equality, toString
- **json_serializable**: Auto-generates JSON serialization code
- **Benefits**:
  - Type-safe models
  - Reduces boilerplate code
  - Union types (sealed classes)
  - Pattern matching

**Usage Pattern**:
```dart
@freezed
class User with _$User {
  factory User({
    required int id,
    required String name,
    String? email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

#### 2. cached_network_image
**Purpose**: Efficient image loading with caching

- **Features**:
  - Automatic disk and memory caching
  - Placeholder widgets while loading
  - Error widgets for failed loads
  - Fade-in animations

**Usage Pattern**:
```dart
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

#### 3. intl
**Purpose**: Internationalization and localization

- **Features**:
  - Date and time formatting
  - Number and currency formatting
  - Message translation
  - Locale-specific formatting

**Usage Pattern**:
```dart
// Date formatting
DateFormat('yyyy-MM-dd').format(DateTime.now());

// Currency formatting
NumberFormat.currency(locale: 'ru_RU', symbol: '₽').format(1000);

// Messages
Intl.message('Hello', name: 'greeting');
```

#### 4. go_router
**Purpose**: Declarative routing for Flutter apps

- **Features**:
  - Named routes
  - Path parameters and query parameters
  - Deep linking support
  - Redirects and guards
  - Nested navigation

**Usage Pattern**:
```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/user/:id',
      builder: (context, state) => UserPage(
        id: state.pathParameters['id']!,
      ),
    ),
  ],
);
```

#### 5. flutter_secure_storage
**Purpose**: Secure storage for sensitive data

- **Features**:
  - Platform-specific secure storage (Keychain on iOS, KeyStore on Android)
  - Encrypted storage
  - Key-value storage
  - Async API

**Usage Pattern**:
```dart
final storage = FlutterSecureStorage();
await storage.write(key: 'token', value: 'abc123');
final token = await storage.read(key: 'token');
```

## Homework Tasks

### Task 1: freezed + json_serializable
✅ Create DTO models with freezed
✅ Generate fromJson/toJson methods
✅ Use build_runner to generate code

### Task 2: cached_network_image
✅ Implement image list with network images
✅ Add placeholder while loading
✅ Add error widget for failed loads
✅ Demonstrate caching behavior

### Task 3: intl
✅ Format dates in different formats
✅ Format currency (RUB/USD)
✅ Switch between locales (ru/en)
✅ Demonstrate locale-specific formatting

### Task 4: go_router
✅ Setup go_router with 3+ routes
✅ Implement route with path parameters
✅ Implement route with query parameters
✅ Add navigation between screens

### Task 5: flutter_secure_storage
✅ Save and retrieve auth token
✅ Demonstrate secure storage
✅ Handle storage operations

## Project Structure

```
lib/
├── main.dart                          # App entry with go_router setup
├── core/
│   ├── router/
│   │   └── app_router.dart           # Route configuration
│   └── storage/
│       └── secure_storage_service.dart # Secure storage wrapper
├── data/
│   └── models/
│       ├── product.dart              # freezed model
│       └── product.freezed.dart      # Generated
│       └── product.g.dart            # Generated
└── presentation/
    ├── pages/
    │   ├── home_page.dart           # Main page with image list
    │   ├── product_list_page.dart   # Product list
    │   ├── product_detail_page.dart # Detail with path param
    │   └── settings_page.dart       # Locale and token settings
    └── widgets/
        └── product_card.dart        # Card with cached image
```

## Key Learnings

### 1. Code Generation
- Use `build_runner` for code generation
- Run `dart run build_runner build` after model changes
- Use `--delete-conflicting-outputs` flag to force rebuild

### 2. Image Optimization
- Always use cached images for network resources
- Provide meaningful placeholders
- Handle errors gracefully
- Consider image size and format

### 3. Localization Best Practices
- Support multiple locales from the start
- Use consistent date/number formats per locale
- Store user locale preference
- Provide locale selector in settings

### 4. Navigation Architecture
- Use declarative routing for better maintainability
- Structure routes hierarchically
- Use type-safe parameters
- Consider deep linking early

### 5. Security
- Never store sensitive data in SharedPreferences
- Use secure storage for tokens, keys, passwords
- Handle storage errors appropriately
- Clear sensitive data on logout

## Common Patterns

### freezed with json_serializable
```dart
// Model definition
@freezed
class Product with _$Product {
  factory Product({
    required int id,
    required String name,
    required double price,
    String? imageUrl,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

// Build command
// dart run build_runner build --delete-conflicting-outputs
```

### Cached Image with Placeholder
```dart
CachedNetworkImage(
  imageUrl: product.imageUrl ?? '',
  height: 200,
  width: double.infinity,
  fit: BoxFit.cover,
  placeholder: (context, url) => Container(
    color: Colors.grey[300],
    child: const Center(child: CircularProgressIndicator()),
  ),
  errorWidget: (context, url, error) => Container(
    color: Colors.grey[300],
    child: const Icon(Icons.broken_image, size: 50),
  ),
)
```

### Locale Switching
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ru'),
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      // ...
    );
  }
}
```

## Dependencies

```yaml
dependencies:
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  cached_network_image: ^3.4.1
  intl: ^0.19.0
  go_router: ^14.6.2
  flutter_secure_storage: ^9.2.2

dev_dependencies:
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  build_runner: ^2.4.13
```

## Common Pitfalls

1. **freezed**: Forgetting to run build_runner after model changes
2. **cached_network_image**: Not handling null imageUrl
3. **intl**: Not setting up app localization delegates
4. **go_router**: Route path typos causing navigation failures
5. **secure_storage**: Not handling platform-specific exceptions

## Testing Considerations

- Mock secure storage in tests
- Test JSON serialization/deserialization
- Test navigation flows
- Test locale switching
- Verify image placeholder and error states
