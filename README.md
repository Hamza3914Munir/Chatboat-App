# FacePix

Flutter application scaffold for **FacePix** (Android, iOS, Web).

## Current status

- **Splash & onboarding** — native splash + in-app splash, four onboarding screens (first launch only).
- **Auth** — create account, email verification, login, forgot password, AI data-sharing dialog.
  Form validation and session state are local (`shared_preferences`); **Firebase Auth is not wired
  up yet**, so no real account is created, no verification or reset email is sent, and any password
  is accepted at login.
- **Shell** — Home, Templates, History and Profile tabs.
- **Generation flows** — Avatar, Portrait, ID Photo and Video, sharing one parameterised skeleton
  (`lib/features/generate/`). UI only; no AI provider is connected.
- **Platforms:** Android, iOS, Web (no desktop targets in this project).

Design source: [docs/figma.md](docs/figma.md).

## Project conventions

- Dart package: `facepix`
- Display name: **FacePix**
- Application ID / bundle ID: `com.skyensolutions.facepix`

## Getting started

```bash
flutter pub get
flutter analyze
flutter test
flutter run              # device or simulator
flutter run -d chrome    # web — includes Device preview panel (device_preview)
```

**Web preview:** On web only, the app is wrapped with [`device_preview`](https://pub.dev/packages/device_preview) (device frame + sidebar). Native iOS/Android builds do not show it.

## Auth conventions

- Validation rules live in [`lib/core/validation/auth_validators.dart`](lib/core/validation/auth_validators.dart) —
  one place, so a rule and the hint describing it cannot drift apart.
- Shared controls are in [`lib/features/auth/widgets/auth_form_widgets.dart`](lib/features/auth/widgets/auth_form_widgets.dart).
  `GradientAuthButton` takes a **nullable** `onPressed`; pass `null` to disable it rather than
  dimming it with an `Opacity` wrapper, which leaves it tappable and reads as enabled to screen
  readers.
- Inline links in a sentence use `AuthInlineLinkText`, which owns and disposes its
  `TapGestureRecognizer`s. Do not build recognizers inside `build()` — they leak.
- Touch targets: `kMinTapTarget` (48) for standalone controls, `kMinInlineTapTarget` (24) for links
  inside a sentence, where 48 would not fit without moving the design.

## Future work

- **Firebase Auth** — replace the local `shared_preferences` simulation with real accounts,
  verification emails and password resets. The resend cooldown
  (`lib/features/auth/widgets/auth_resend_cooldown.dart`) is already in place for it.
- **ML Kit face detection** — on-device pre-validation before any upload. Face/camera features can
  follow patterns from other company apps (for example EduPlayce's face capture flow).
- **AI provider** — nothing is connected to the generation flows yet; see
  [docs/FacePix_Monthly_Cost_Report.pdf](docs/FacePix_Monthly_Cost_Report.pdf) for the cost model.
- **Shell layout at narrow widths** — `AppShell` overflows horizontally in widget tests at 390pt.
  Needs checking on a 360pt device and at large text scales.
