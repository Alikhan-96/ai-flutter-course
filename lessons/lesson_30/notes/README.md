# Lesson 30: Dependency Injection with get_it

## Lecture Overview

**Topic**: Dependency Injection in Flutter using the `get_it` package

### Key Concepts

1. **Service Locator Pattern**
   - Central registry for application dependencies
   - Singleton instance accessible throughout the app
   - Alternative to passing dependencies through constructors

2. **get_it Package**
   - Popular dependency injection solution for Flutter/Dart
   - Supports singleton, lazy singleton, and factory registrations
   - Type-safe dependency resolution

3. **Benefits of Dependency Injection**
   - Loose coupling between components
   - Easy testing with mock implementations
   - Centralized configuration
   - Better code organization

### Implementation Patterns

1. **Service Registration**
   ```dart
   GetIt.instance.registerSingleton<Service>(ServiceImpl());
   GetIt.instance.registerLazySingleton<Repository>(() => RepositoryImpl());
   GetIt.instance.registerFactory<UseCase>(() => UseCaseImpl());
   ```

2. **Service Resolution**
   ```dart
   final service = GetIt.instance<Service>();
   // or using shorthand
   final service = getIt<Service>();
   ```

3. **Mock vs Real Implementations**
   - Use build configurations (debug/release)
   - Register different implementations based on environment
   - Enables testing without external dependencies

4. **Async Initialization**
   - Initialize services that require async setup
   - Use `GetItHelper` or manual async setup
   - Wait for initialization before running app

## Homework Tasks

### Task 1: Basic get_it Setup
✅ Register ApiClient, Repository, and UseCase in get_it
✅ Access dependencies through constructor/factory in UI

### Task 2: Mock and Real Implementations
✅ Create MockApiClient and RealApiClient
✅ Switch implementations based on debug/release flag
✅ Demonstrate different behavior in each mode

### Task 3: Async Initialization
✅ Add SharedPreferences initialization
✅ Setup async init before runApp
✅ Use initialized preferences in the app

### Task 4: Unit Testing
✅ Write unit tests for repository
✅ Mock dependencies using get_it
✅ Verify dependency substitution works correctly

## Project Structure

```
lib/
├── main.dart                      # App entry point with DI setup
├── core/
│   ├── di/
│   │   └── injection.dart        # Dependency injection configuration
│   └── config/
│       └── app_config.dart       # App configuration (debug/release)
├── data/
│   ├── api/
│   │   ├── api_client.dart       # API client interface
│   │   ├── mock_api_client.dart  # Mock implementation
│   │   └── real_api_client.dart  # Real implementation
│   └── repositories/
│       ├── user_repository.dart  # Repository interface
│       └── user_repository_impl.dart
├── domain/
│   └── usecases/
│       └── get_users_usecase.dart
└── presentation/
    └── pages/
        └── home_page.dart
```

## Key Learnings

1. **Separation of Concerns**: DI helps separate object creation from usage
2. **Testability**: Easy to substitute real implementations with mocks
3. **Flexibility**: Switch between implementations without changing client code
4. **Lifecycle Management**: Control when and how objects are created
5. **Async Initialization**: Handle complex setup requirements before app starts

## Testing Strategy

- Unit tests with mocked dependencies
- Integration tests with real implementations
- Verify singleton behavior
- Test async initialization flow

## Common Pitfalls

1. Forgetting to await async initialization
2. Registering services in wrong order (dependencies first)
3. Not resetting get_it between tests
4. Using get_it for every class (over-engineering)

## Best Practices

1. Keep DI configuration in a separate file
2. Use interfaces/abstract classes for better testability
3. Register dependencies at app startup
4. Document which services are singletons vs factories
5. Consider using get_it only for cross-cutting concerns
