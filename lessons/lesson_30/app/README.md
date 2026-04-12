# Lesson 30: Dependency Injection with get_it

This application demonstrates dependency injection using the `get_it` package.

## Features Implemented

✅ **Dependency Injection with get_it**
- ApiClient, Repository, and UseCase registered in get_it
- Dependencies accessed through get_it in UI layer
- Clean separation of concerns

✅ **Mock and Real Implementations**
- `MockApiClient` for debug/testing mode
- `RealApiClient` for production mode
- Automatic switching based on build configuration
- Different data sets for each implementation

✅ **Async Initialization**
- SharedPreferences initialized before runApp
- Last launch timestamp saved and displayed
- Demonstrates proper async setup with get_it

✅ **Unit Tests**
- Comprehensive repository tests with mocked dependencies
- Demonstrates dependency substitution in tests
- Tests verify get_it integration works correctly
- All 7 tests passing

## Project Structure

```
lib/
├── main.dart                      # App entry with async DI initialization
├── core/
│   ├── di/
│   │   └── injection.dart        # get_it configuration
│   └── config/
│       └── app_config.dart       # Debug/Release configuration
├── data/
│   ├── api/
│   │   ├── api_client.dart       # API client interface
│   │   ├── mock_api_client.dart  # Mock implementation (debug)
│   │   └── real_api_client.dart  # Real implementation (release)
│   └── repositories/
│       ├── user_repository.dart  # Repository interface
│       └── user_repository_impl.dart # Repository implementation
├── domain/
│   ├── models/
│   │   └── user.dart            # User model
│   └── usecases/
│       └── get_users_usecase.dart # Business logic
└── presentation/
    └── pages/
        └── home_page.dart        # UI with injected dependencies

test/
└── data/
    └── repositories/
        └── user_repository_test.dart # Unit tests with DI
```

## How to Run

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run in debug mode (uses Mock API):**
   ```bash
   flutter run
   ```

3. **Run in release mode (uses Real API):**
   ```bash
   flutter run --release
   ```

4. **Run tests:**
   ```bash
   flutter test
   ```

## Key Concepts Demonstrated

### 1. Service Locator Pattern
- Central registry for all dependencies
- Type-safe dependency resolution
- Easy to access from anywhere in the app

### 2. Dependency Inversion
- High-level modules don't depend on low-level modules
- Both depend on abstractions (interfaces)
- Easy to swap implementations

### 3. Async Initialization
- Wait for async services before running app
- SharedPreferences initialized at startup
- Proper handling of async dependencies

### 4. Testability
- Easy to mock dependencies in tests
- Tests run in isolation
- No need for complex test setup

## App Features

- **User List**: Displays users from API (mock or real)
- **Add User**: Create new users with validation
- **Pull to Refresh**: Refresh user list
- **Mode Indicator**: Shows if using Mock or Real API
- **Last Launch Time**: Displays when app was last launched

## Testing Strategy

The app includes comprehensive unit tests that demonstrate:
- Testing with mocked dependencies
- Substituting different implementations
- Verifying get_it registration
- Comparison with manual dependency injection

## Dependencies Used

- `get_it`: ^8.3.0 - Service locator for dependency injection
- `shared_preferences`: ^2.3.3 - For persistent storage demo
- `mockito`: ^5.4.4 - For creating mocks in tests (dev dependency)

## Notes

- In debug mode, the Mock API returns 3 users
- In release mode, the Real API returns 2 users (simulated)
- The app demonstrates how easy it is to switch implementations
- All business logic is properly separated from UI
