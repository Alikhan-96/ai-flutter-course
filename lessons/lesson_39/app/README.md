# Lesson 39 App

This app now matches the lesson 39 homework from the lecture slides and
`Homework39.txt`.

## What is implemented

- `TaskDto -> Task` mapper with default handling for null and blank values
- `Task -> TaskDto` reverse mapper using snake_case DTO fields
- `AddTaskUseCase` with repository abstraction and title validation
- `InMemoryTasksRepository` for the demo app
- reusable test fixtures in `test/fixtures/task_fixtures.dart`
- fake repository for unit tests in `test/fakes/fake_tasks_repository.dart`
- mapper tests with 5 different inputs
- use-case tests for happy path and error scenarios
- coverage helper script for the key lesson files

## Run tests

```bash
flutter test
```

## Generate coverage

PowerShell:

```powershell
./tool/check_coverage.ps1
```

Manual command:

```bash
flutter test --coverage
```

The generated report is written to `coverage/lcov.info`.
