# assets/fonts

Not used yet — the app's typography (`lib/core/theme/app_text_styles.dart`)
is served by the `google_fonts` package (Poppins), fetched/cached at
runtime rather than bundled.

If the team later decides to bundle font files locally instead (for
fully offline builds or a licensed font `google_fonts` doesn't carry),
drop the `.ttf`/`.otf` files here and declare them under the `fonts:`
section of `pubspec.yaml`.
