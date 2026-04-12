# Lesson 35: Architecture Patterns (MVC/MVP)

## Overview
MVC (Model-View-Controller) and MVP (Model-View-Presenter) are fundamental architecture patterns.

## Homework Completed

✅ **MVC Implementation** - Task list screen using MVC pattern
✅ **MVP Implementation** - Same screen using MVP pattern
✅ **Business Logic Separation** - 2+ methods (load/add) separated from UI
✅ **Architecture Diagram** - Visual representation of layers
✅ **Error Handling** - Unified ErrorHandler implementation

## Patterns Comparison

### MVC (Model-View-Controller)
- **Model**: Data and business logic
- **View**: UI (StatefulWidget)
- **Controller**: Mediates between Model and View
- View directly observes Model changes

### MVP (Model-View-Presenter)
- **Model**: Data and business logic
- **View**: UI implementing View interface
- **Presenter**: Business logic, updates View via interface
- Better testability (View is an interface)

## Implementation

Complete code in `../app/` directory.

Files:
- `lib/mvc/task_list_mvc.dart` - MVC implementation
- `lib/mvp/task_list_mvp.dart` - MVP implementation
- `lib/mvp/task_presenter.dart` - Presenter logic
- `lib/core/error_handler.dart` - Centralized error handling

## Key Differences

| Aspect | MVC | MVP |
|--------|-----|-----|
| View-Logic Coupling | Tight | Loose |
| Testability | Moderate | High |
| Code Reusability | Moderate | High |
| Complexity | Simple | More Complex |

## Complete Implementation Available

See `LESSONS_33-39_COMPLETION_GUIDE.md` for full implementations of both patterns.
