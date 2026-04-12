# Lesson 32: Firebase Authentication

## Lecture Overview

**Topic**: User authentication with Firebase Authentication

### Key Concepts

#### 1. Firebase Authentication
**Purpose**: Backend-as-a-Service (BaaS) for user authentication

**Features**:
- Multiple authentication providers (Email/Password, Google, Facebook, etc.)
- Secure token-based authentication
- Built-in password reset functionality
- User session management
- OAuth 2.0 support

#### 2. Authentication Flow
```
User Sign Up → Firebase Creates User → Returns User Object + Token
User Sign In → Firebase Validates → Returns User Object + Token
Auth State → Stream of authentication changes
Sign Out → Firebase Invalidates Token
```

#### 3. Auth State Changes
**Purpose**: React to authentication state automatically

```dart
FirebaseAuth.instance.authStateChanges().listen((User? user) {
  if (user == null) {
    // User is signed out
  } else {
    // User is signed in
  }
});
```

#### 4. Error Handling
Common Firebase Auth errors:
- `user-not-found`: No user with this email
- `wrong-password`: Incorrect password
- `email-already-in-use`: Email already registered
- `weak-password`: Password too weak
- `invalid-email`: Email format invalid

## Homework Tasks

### Task 1: Email/Password Authentication
✅ Registration with email and password
✅ Sign in with email and password
✅ Sign out functionality
✅ Form validation

### Task 2: Auth State Management
✅ Listen to `authStateChanges()`
✅ Automatic navigation on auth state change
✅ Show login screen when signed out
✅ Show home screen when signed in

### Task 3: Error Handling
✅ Handle all common authentication errors
✅ Display user-friendly error messages
✅ Show loading indicators
✅ Validate input before submission

### Task 4: Additional Features
✅ Password reset (Forgot Password)
✅ Google Sign-In integration
✅ User profile display (displayName, photoURL, email)
✅ Update user profile

## Project Structure

```
lib/
├── main.dart                          # App entry with auth state listener
├── core/
│   ├── services/
│   │   └── auth_service.dart         # Firebase Auth wrapper
│   └── utils/
│       └── validators.dart           # Input validators
├── data/
│   └── models/
│       └── app_user.dart            # User model
└── presentation/
    ├── pages/
    │   ├── auth/
    │   │   ├── login_page.dart      # Login screen
    │   │   ├── register_page.dart   # Registration screen
    │   │   └── forgot_password_page.dart # Password reset
    │   ├── home_page.dart           # Main app screen
    │   └── profile_page.dart        # User profile
    └── widgets/
        └── auth_wrapper.dart        # Auth state wrapper
```

## Implementation Details

### 1. Firebase Configuration
Required files:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

Enable in Firebase Console:
- Authentication > Sign-in method > Email/Password
- Authentication > Sign-in method > Google

### 2. Email/Password Authentication
```dart
// Sign Up
UserCredential credential = await FirebaseAuth.instance
    .createUserWithEmailAndPassword(
  email: email,
  password: password,
);

// Sign In
UserCredential credential = await FirebaseAuth.instance
    .signInWithEmailAndPassword(
  email: email,
  password: password,
);

// Sign Out
await FirebaseAuth.instance.signOut();
```

### 3. Google Sign-In
```dart
final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;

final credential = GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken,
);

await FirebaseAuth.instance.signInWithCredential(credential);
```

### 4. Password Reset
```dart
await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
```

### 5. Update User Profile
```dart
await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
await FirebaseAuth.instance.currentUser?.updatePhotoURL(photoUrl);
```

## Key Learnings

### 1. Authentication Best Practices
- Never store passwords in plain text
- Use Firebase's built-in security
- Validate inputs before sending to Firebase
- Handle all error cases
- Show loading states

### 2. State Management
- Use `authStateChanges()` stream
- Centralize auth logic in a service
- Navigate based on auth state
- Persist auth state across app restarts

### 3. User Experience
- Clear error messages
- Loading indicators during async operations
- Form validation feedback
- Success confirmations
- Smooth transitions between auth states

### 4. Security Considerations
- Enable email verification (optional)
- Implement rate limiting
- Use strong password requirements
- Secure token storage (automatic with Firebase)
- Implement session timeout (optional)

## Common Patterns

### Auth Service Wrapper
```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ... more methods
}
```

### Error Message Mapping
```dart
String getErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'user-not-found':
      return 'No user found with this email';
    case 'wrong-password':
      return 'Incorrect password';
    case 'email-already-in-use':
      return 'Email already registered';
    // ... more cases
  }
}
```

### Auth State Wrapper
```dart
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}
```

## Dependencies

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.4
  google_sign_in: ^6.2.2
```

## Firebase Setup Steps

1. **Create Firebase Project**
   - Go to https://console.firebase.google.com
   - Create new project
   - Add Android/iOS apps

2. **Download Config Files**
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`

3. **Enable Authentication**
   - Firebase Console → Authentication
   - Enable Email/Password provider
   - Enable Google provider (optional)
   - Configure OAuth consent screen

4. **Update Build Files**
   - Android: Update `android/build.gradle`
   - iOS: Update `ios/Podfile`

## Testing Strategy

- Test successful sign up
- Test successful sign in
- Test sign out
- Test error cases (invalid email, wrong password, etc.)
- Test password reset
- Test Google Sign-In (if configured)
- Test auth state persistence

## Common Pitfalls

1. Forgetting to initialize Firebase in `main.dart`
2. Not handling all error cases
3. Missing platform-specific configuration
4. Not showing loading states
5. Poor error messages for users
6. Not clearing forms after success
7. Missing input validation

## Best Practices

1. Initialize Firebase before runApp
2. Use a centralized auth service
3. Handle errors gracefully
4. Validate inputs client-side
5. Show meaningful loading states
6. Clear sensitive data on sign out
7. Use StreamBuilder for auth state
8. Implement proper navigation guards
