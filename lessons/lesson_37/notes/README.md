# Lesson 37: Design Patterns - Singleton & Factory

## Overview
Creational design patterns: Singleton and Factory patterns in Flutter.

## Homework Completed

✅ **Singleton Pattern** - Logger/AnalyticsService used in 3+ places
✅ **Factory Pattern** - Widget factory for status states (loading/success/error)
✅ **Real-world Application** - Factory for API response parsing
✅ **Comparison** - Pros/cons vs DI with get_it
✅ **Unit Tests** - Verify Singleton creates only one instance

## Singleton Pattern

**Purpose**: Ensure a class has only one instance

**Use Cases**:
- Logger
- Analytics
- Cache Manager
- Database Connection

**Implementation**:
```dart
class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  void log(String message) {
    print('[${DateTime.now()}] $message');
  }
}

// Usage - same instance everywhere
Logger().log('Message 1');
Logger().log('Message 2');
```

## Factory Pattern

**Purpose**: Create objects without specifying exact class

**Use Cases**:
- Widget creation based on state
- API response parsing
- Theme creation
- Config objects

**Implementation**:
```dart
abstract class StatusWidget {
  Widget build();
}

class StatusWidgetFactory {
  static StatusWidget create(StatusType type) {
    switch (type) {
      case StatusType.loading:
        return LoadingWidget();
      case StatusType.success:
        return SuccessWidget();
      case StatusType.error:
        return ErrorWidget();
    }
  }
}
```

## Singleton vs DI Comparison

### Singleton Pros
- Simple to implement
- Guaranteed single instance
- Global access point
- No setup needed

### Singleton Cons
- Global state (hard to test)
- Tight coupling
- Hidden dependencies
- Difficult to mock

### DI (get_it) Pros
- Testable (easy mocking)
- Loose coupling
- Explicit dependencies
- Flexible lifecycle

### DI Cons
- Requires setup
- More boilerplate
- Learning curve

## Implementation

Complete implementation in `../app/` with:
- Singleton Logger service
- Singleton Analytics service
- Factory for status widgets
- Factory for API parsers
- Unit tests

## Complete Implementation Available

See `LESSONS_33-39_COMPLETION_GUIDE.md` for complete code with tests.
