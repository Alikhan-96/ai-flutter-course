# Lesson 41 App

This app completes the lesson 41 homework around mocks and integration tests.

## Implemented homework

- mocked external services with `mocktail` in repository tests
- fake API client with fixed JSON responses instead of real network requests
- DI through `AppDependencies`, allowing tests to replace production services
- integration test for `login -> list -> add -> logout`
- local CI workflow for running lesson 41 tests

## Run tests

```bash
flutter test
flutter test integration_test
```
