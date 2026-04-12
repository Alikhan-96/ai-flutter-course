# Firebase Credentials Cleanup

## What was sanitized

- `lessons/lesson_32/app/lib/firebase_options.dart`
- `lessons/lesson_32/app/android/app/google-services.json`
- `lessons/lesson_33/app/android/app/google-services.json`
- `lessons/lesson_34/app/android/app/google-services.json`

These files now contain placeholders only.

## What to do locally before running those apps again

1. Rotate or restrict the exposed Firebase API keys in Firebase / Google Cloud.
2. Regenerate `firebase_options.dart` locally with:
   `flutterfire configure`
3. Re-download the real `google-services.json` for each affected app.
4. Keep those real files local and do not commit them again.

## Recommended push strategy

1. Commit the sanitized files.
2. Push the cleanup commit immediately.
3. If the repository is public, rotate the keys even if you plan to rewrite git history.
4. Optionally rewrite git history later to remove the old leaked values from past commits.

## Important note

Firebase client API keys are not equivalent to service-account private keys,
but they should still be treated as exposed configuration once committed to a
public remote.
