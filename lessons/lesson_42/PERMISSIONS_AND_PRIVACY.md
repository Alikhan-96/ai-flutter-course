# Permissions And Privacy Review

## Current release scope

The lesson 42 app is a checklist-style demo and does not actively use:

- camera
- photo library
- push notifications
- location
- contacts

## Android review

File reviewed: `app/android/app/src/main/AndroidManifest.xml`

- No dangerous runtime permissions were added.
- No camera or media permissions are declared.
- No notification permission is declared for Android 13+ because the app does
  not send notifications in this lesson.

## iOS review

File reviewed: `app/ios/Runner/Info.plist`

- No camera or photo usage descriptions were added because those capabilities
  are not used in the current release.
- Notification copy is present as a defensive note so the team explicitly
  reviews it before enabling notifications in a future release.

## Privacy text summary

Suggested store-facing text:

> This app does not collect personal data, access photos, or use the camera in
> the current release build. If future releases add authentication,
> notifications, or analytics, the privacy policy and store disclosures must be
> updated before publication.
