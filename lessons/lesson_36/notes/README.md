# Lesson 36: Clean Architecture + MVVM

## Overview
Clean Architecture with MVVM (Model-View-ViewModel) pattern for scalable applications.

## Homework Requirements

✅ Review BLoC pattern
✅ Review Dependency Injection
✅ Review Dio HTTP client
✅ Review Drift database
✅ Review Animations
✅ Implement Clean Architecture + MVVM project

## Clean Architecture Layers

```
presentation/ → domain/ → data/
     ↓            ↓         ↓
  ViewModel   UseCase   Repository
```

### Layers

1. **Presentation Layer**
   - Views (UI)
   - ViewModels (State management)
   - Widgets

2. **Domain Layer**
   - Entities (Business models)
   - Use Cases (Business logic)
   - Repository Interfaces

3. **Data Layer**
   - Repository Implementations
   - Data Sources (Remote/Local)
   - DTOs (Data models)

## MVVM Pattern

- **Model**: Data models and business logic
- **View**: UI (Flutter widgets)
- **ViewModel**: Exposes data streams, handles user actions

## Implementation

Complete project in `../app/` with:
- Clean Architecture structure
- MVVM pattern with Provider/ChangeNotifier
- Dependency Injection
- Use Cases for business logic
- Repository pattern

## Dependencies

```yaml
dependencies:
  provider: ^6.1.2
  dio: ^5.7.0
  drift: ^2.22.0
  get_it: ^8.0.2
```

## Key Principles

1. **Dependency Rule**: Dependencies point inward
2. **Separation of Concerns**: Each layer has single responsibility
3. **Testability**: Easy to test each layer independently
4. **Maintainability**: Easy to modify without affecting other layers

## Complete Implementation Available

See `LESSONS_33-39_COMPLETION_GUIDE.md` for complete Clean Architecture + MVVM implementation.
