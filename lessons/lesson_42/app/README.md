# Lesson 42 App

This lesson is release-oriented, so the homework solution is mostly project
configuration and release documentation rather than new runtime features.

## Completed homework

- Android version bumped to `1.1.0+2`
- Android release signing template prepared with `key.properties`
- launcher icon and native splash configs added
- permissions and privacy review documented
- internal testing release checklist documented
- release bugs, risks, and rollback plan documented

## Release commands

```bash
flutter pub run flutter_launcher_icons
dart run flutter_native_splash:create
flutter build appbundle --release
```

If `android/key.properties` is present, the release build uses that keystore.
Otherwise it falls back to debug signing for local verification only.
