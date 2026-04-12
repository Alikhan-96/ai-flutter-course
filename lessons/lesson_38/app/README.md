# Lesson 38 App

This app now implements the real lesson 38 homework around Repository,
Adapter, DTO mapping, caching, and datasource strategy.

## Implemented structure

- `lib/domain/entities/note.dart`
- `lib/domain/repositories/notes_repository.dart`
- `lib/data/dto/api_note_dto.dart`
- `lib/data/mappers/note_mapper.dart`
- `lib/data/datasources/notes_remote_data_source.dart`
- `lib/data/datasources/notes_local_data_source.dart`
- `lib/data/repositories/notes_repository_impl.dart`

## Homework coverage

- repository interface in domain and implementation in data
- adapter/mapper from external DTO to domain and back
- mapping cases for normal, empty, and incorrect data
- local cache with remote refresh
- remote and local datasources with explicit fetch strategy switching

## Run tests

```bash
flutter test
```
