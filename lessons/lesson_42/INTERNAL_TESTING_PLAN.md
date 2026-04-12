# Internal Testing Plan

## Goal

Ship an Android internal testing build through Play Console before public
release.

## Build to upload

- Format: AAB
- Command: `flutter build appbundle --release`
- Track: `Internal testing`
- Audience: course reviewers or 3-5 trusted testers

## Tester checklist

1. Install the internal build from Play Console.
2. Launch the app and verify the release icon and splash screen.
3. Confirm there is no debug banner.
4. Run the primary app flow and note regressions.
5. Confirm permissions match actual features.
6. Report crashes, layout issues, and unclear copy.

## Exit criteria

- no blocker crashes
- no broken primary flow
- no unexpected permission prompts
- release metadata is ready

## Notes

- Use internal testing before closed/open testing.
- Do not upload APK; use AAB only.
- Keep testers on a single known version during the feedback cycle.
