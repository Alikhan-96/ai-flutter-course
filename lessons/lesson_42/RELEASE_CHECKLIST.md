# Lesson 42 Release Checklist

## Version

- `versionName`: `1.1.0`
- `versionCode`: `2`
- Release date: `2026-04-12`
- Android package: `com.example.releaseready`

## Android release prep

- [x] `pubspec.yaml` version updated
- [x] Android signing template added
- [x] `flutter build appbundle --release` documented
- [x] AAB selected instead of APK
- [x] Internal testing notes prepared for Play Console

## iOS release prep

- [x] Display name updated
- [x] Build number wired through Flutter build variables
- [x] Signing review documented
- [x] Archive / Upload steps documented

## Visual assets

- [x] launcher icon config added
- [x] native splash config added
- [ ] generated assets verified on a real device

## Permissions and privacy

- [x] Android permissions reviewed
- [x] iOS privacy text reviewed
- [x] privacy policy draft added
- [x] current release declares no camera/photo/notification access in app flow

## Smoke test before release

- [ ] login works on release build
- [ ] main flow works on release build
- [ ] offline/error handling checked
- [ ] no debug banner or test endpoints

## Store readiness

- [x] internal testing plan written
- [x] release risk / rollback plan written
- [ ] screenshots and store listing copy uploaded
- [ ] privacy policy URL published externally
