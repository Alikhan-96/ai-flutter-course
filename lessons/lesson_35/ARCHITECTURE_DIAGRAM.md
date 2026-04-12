# Lesson 35 Architecture Diagram

## Screen chosen

Task list with add and toggle actions.

## MVC

```text
View (TaskMvcScreen)
  -> Controller (TaskController)
      -> Model/Repository (TaskRepository)
      -> ErrorHandler
```

### Responsibilities

- View: renders inputs, list items, and error text
- Controller: loads tasks, adds tasks, toggles completion, updates state
- Repository/Model: owns task data and performs mutations
- ErrorHandler: converts thrown errors into UI-friendly messages

## MVP

```text
View (TaskMvpScreen implements TaskViewContract)
  <- Presenter (TaskPresenter)
      -> Model/Repository (TaskRepository)
      -> ErrorHandler
```

### Responsibilities

- View: renders state and forwards user actions to the presenter
- Presenter: owns interaction logic and tells the view what to render
- Repository/Model: stores and mutates task data
- ErrorHandler: centralizes message formatting for failures

## What became simpler or harder

- MVC is simpler to start and needs less boilerplate.
- MVP makes responsibilities clearer and isolates interaction logic better.
- MVP adds more ceremony because of the view contract and presenter wiring.
- MVC keeps the widget more coupled to controller state.
