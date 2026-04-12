# Lesson 32: Firebase Authentication

Complete Firebase Authentication implementation with email/password and Google Sign-In.

## ✅ Features Implemented

- **Email/Password Authentication** - Registration, login, and password reset
- **Google Sign-In** - OAuth authentication with Google
- **Auth State Management** - Automatic navigation based on auth state
- **Error Handling** - User-friendly error messages for all Firebase errors
- **Profile Management** - View and update user profile
- **Email Verification** - Send verification emails
- **Form Validation** - Client-side validation for all inputs

## 🔥 Firebase Setup Required

**This app requires Firebase configuration to run. Follow these steps:**

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project" or select existing project
3. Follow the setup wizard

### 2. Add Android App

1. In Firebase Console, click "Add app" → Android
2. Register app with package name: `com.example.app`
3. Download `google-services.json`
4. Place it in `android/app/google-services.json`

### 3. Add iOS App

1. In Firebase Console, click "Add app" → iOS
2. Register app with bundle ID: `com.example.app`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/GoogleService-Info.plist`

### 4. Enable Authentication Methods

1. Firebase Console → Authentication → Sign-in method
2. Enable **Email/Password**
3. Enable **Google** (optional)
   - Download OAuth client configuration
   - Add SHA-1 fingerprint for Android (for Google Sign-In)

### 5. Update Android Configuration

Edit `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

Edit `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        minSdkVersion 21  // Firebase requires min SDK 21
    }
}
```

### 6. Get SHA-1 Fingerprint (for Google Sign-In)

```bash
# Debug SHA-1
cd android
./gradlew signingReport

# Or use keytool
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Add the SHA-1 to Firebase Console → Project Settings → Your apps → SHA certificate fingerprints

## 📦 Dependencies

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.4
  google_sign_in: ^6.2.2
```

## 🚀 How to Run

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app (after Firebase setup)
flutter run

# 3. Test on Android/iOS (Google Sign-In requires real device/emulator)
flutter run -d <device-id>
```

## 📱 Features Overview

### Authentication Flow
- **Login Screen** → Email/Password or Google Sign-In → **Home Screen**
- **Register Screen** → Create account → Auto login → **Home Screen**
- **Forgot Password** → Reset email sent → Back to login
- **Auth State Listener** → Automatic navigation on auth changes

### Screens

**1. Login Page** (`login_page.dart`)
- Email/password login
- Google Sign-In button
- Link to registration
- Link to password reset
- Input validation
- Loading states

**2. Register Page** (`register_page.dart`)
- Full name input
- Email and password
- Confirm password
- Profile creation on signup
- Input validation

**3. Forgot Password** (`forgot_password_page.dart`)
- Email input
- Send reset link
- Success confirmation
- Error handling

**4. Home Page** (`home_page.dart`)
- Welcome message
- User avatar (initials or photo)
- Email verification status
- Quick access to profile
- Sign out

**5. Profile Page** (`profile_page.dart`)
- View user details
- Edit display name
- Email verification status
- User ID display
- Sign out button

## 🏗️ Project Structure

```
lib/
├── main.dart                          # Firebase initialization + AuthWrapper
├── core/
│   ├── services/
│   │   └── auth_service.dart         # Firebase Auth wrapper
│   └── utils/
│       └── validators.dart           # Form validators
├── data/
│   └── models/
│       └── app_user.dart            # User model
└── presentation/
    ├── widgets/
    │   └── auth_wrapper.dart        # Auth state stream listener
    └── pages/
        ├── auth/
        │   ├── login_page.dart      # Login screen
        │   ├── register_page.dart   # Registration
        │   └── forgot_password_page.dart
        ├── home_page.dart           # Main screen (authenticated)
        └── profile_page.dart        # User profile

```

## 🔐 Security Notes

- Passwords are never stored in plain text
- Firebase handles all authentication securely
- Tokens are managed automatically by Firebase SDK
- Use Firebase Security Rules for additional protection
- Consider enabling App Check for production

## 🧪 Testing

### Manual Testing Checklist

- [ ] Register new account with email/password
- [ ] Login with registered account
- [ ] Test wrong password error
- [ ] Test invalid email error
- [ ] Test email already in use error
- [ ] Reset password via email
- [ ] Sign in with Google (requires setup)
- [ ] Update profile display name
- [ ] Send email verification
- [ ] Sign out
- [ ] Auto-navigation on auth state change

## ⚠️ Common Issues

**Firebase not initialized**
- Ensure config files are in correct locations
- Check package name/bundle ID matches Firebase

**Google Sign-In fails**
- Add SHA-1 fingerprint to Firebase
- Enable Google provider in Firebase Console
- Test on real device (simulator may have issues)

**Build errors**
- Update `minSdkVersion` to 21+
- Add `google-services` plugin
- Run `flutter clean` and rebuild

## 📚 Key Learnings

1. Firebase Auth handles token management automatically
2. `authStateChanges()` stream enables reactive auth
3. Error codes from Firebase need user-friendly mapping
4. Google Sign-In requires platform-specific setup
5. Profile updates require `reload()` to refresh
6. Email verification is separate from authentication

## 🎯 Production Checklist

- [ ] Add email verification requirement
- [ ] Implement stronger password requirements
- [ ] Add rate limiting (Firebase console)
- [ ] Configure password policy
- [ ] Set up Firebase App Check
- [ ] Implement proper error logging
- [ ] Add analytics for auth events
- [ ] Test on multiple devices/OS versions
- [ ] Configure OAuth consent screen properly
- [ ] Review Firebase Security Rules

## 💡 Tips

- Test auth flow end-to-end before adding features
- Use Firebase Emulator Suite for local development
- Monitor Authentication tab in Firebase Console
- Check Firebase quota limits for your plan
- Consider multi-factor authentication for sensitive apps
