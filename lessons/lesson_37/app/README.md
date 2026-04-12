# Lesson 37 App

This app completes the lesson 37 homework for Singleton and Factory patterns.

## Implemented homework

- `LoggerService` singleton used across app startup and multiple UI actions
- `AnalyticsService` singleton used across app startup and multiple UI actions
- `StatusCardFactory` creates `loading`, `success`, and `error` widgets from `StatusState`
- `ApiPayloadFactory` parses API payloads based on response type
- `SINGLETON_VS_DI.md` documents Singleton vs `get_it` with clear pros and cons
- tests verify that singleton instances are reused and keep shared state

## Run tests

```bash
flutter test
```
