# Lesson 34: Push Notifications (FCM)

## Overview
Firebase Cloud Messaging (FCM) enables push notifications across platforms.

## Homework Completed

✅ **FCM Setup** - Device token retrieval and management
✅ **Foreground Notifications** - Display notifications when app is open
✅ **Background Handling** - Handle notifications in background/terminated states
✅ **Deep Linking** - Open specific screen on notification tap
✅ **Token Storage** - Save device tokens to Firestore
✅ **Settings Page** - Enable/disable notifications

## Implementation

Complete implementation in `../app/` directory.

Key files:
- `lib/services/notification_service.dart` - FCM handler
- `lib/pages/notification_settings_page.dart` - Settings UI
- Android: `android/app/src/main/AndroidManifest.xml` - Permissions

## FCM Setup

1. Enable Cloud Messaging in Firebase Console
2. Download `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
3. Add notification permissions to manifests
4. Test with Firebase Console "Cloud Messaging"

## Key Concepts

- **App States**: Foreground, Background, Terminated
- **Permissions**: Request on Android 13+ and iOS
- **Local Notifications**: Show in foreground with `flutter_local_notifications`
- **Payload**: Send data with notification for deep linking
- **Topics**: Subscribe to channels for group messaging

## Complete Implementation Available

See `LESSONS_33-39_COMPLETION_GUIDE.md` for full code examples.
