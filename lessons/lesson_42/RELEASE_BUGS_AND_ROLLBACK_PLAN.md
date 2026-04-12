# Release Bugs, Risks, And Rollback Plan

## Top release risks

1. Incorrect Android signing setup prevents Play upload.
2. Version code is not incremented and Play rejects the build.
3. Placeholder branding remains in icons or splash assets.
4. Store privacy disclosure does not match actual permissions.
5. Release build behaves differently from debug and misses a critical flow.

## Likely bugs to watch

- release-only startup crash
- wrong package name or signing mismatch
- icon/splash assets look stretched on some devices
- stale environment config or test endpoint left enabled

## Mitigation

- validate `pubspec.yaml` version before every build
- verify `android/key.properties` and keystore path locally
- run smoke test on a release build, not debug
- review AndroidManifest and Info.plist before store upload
- verify store listing and privacy text against shipped features

## Rollback plan

1. Stop promotion beyond internal testing if blockers are found.
2. Fix the issue on a hotfix branch.
3. Increase `versionCode` and rebuild the AAB.
4. Re-run smoke test on the hotfix release build.
5. Upload the new bundle to internal testing again before wider rollout.

## Owner

- Release engineer / student maintainer for lesson 42
