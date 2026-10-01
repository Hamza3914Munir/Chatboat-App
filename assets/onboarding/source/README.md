# Onboarding illustration sources

Place **white-background PNG exports from Figma** here (same files as in your Mac Downloads folder):

| File | Character |
|------|-----------|
| `onboarding_1_source.png` | Man, thumbs up (yellow overalls) |
| `onboarding_2_source.png` | Girl, selfie + peace sign |
| `onboarding_3_source.png` | Man, beanbag + phone |
| `onboarding_4_source.png` | Girl, pink cube + media icons |

Then regenerate app assets from the project root:

```bash
python3 tooling/process_onboarding_assets.py
```

The script removes only **edge-connected** white (or black) background so **black hair, laces, and boot soles stay opaque**. Do not use a global “delete all dark pixels” pass.

After updating PNGs, do a **full restart** of the Flutter app (not hot reload).
