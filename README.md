# FacePix

Flutter application scaffold for **FacePix** (Android, iOS, Web).

## Current status

- **Splash & onboarding** — native splash + in-app splash, four onboarding screens (first launch only), placeholder home.
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

## Future work

Face/camera features can follow patterns from other company apps (for example EduPlayce’s face capture flow). Firebase and ML Kit are not configured in this scaffold.
