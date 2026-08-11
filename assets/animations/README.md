# assets/animations

Reserved for Lottie (or similar) animation files — e.g. a richer
"order placed" success animation than the current static checkmark.

Not wired into `pubspec.yaml` yet since it's empty; when the first
`.json` animation is added, add both the `lottie` dependency and an
`assets/animations/` entry under `flutter: assets:` in `pubspec.yaml`,
and register the path in `lib/core/constants/app_assets.dart`.
