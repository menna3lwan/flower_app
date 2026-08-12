# assets/logos

The Flowery brand mark, exported from the Figma "Design System" page.

Expected file: `app_logo.png` (the flower icon, 1024×1024 in Figma).
Registered as `AppAssets.appLogo` in `lib/core/constants/app_assets.dart`
— nothing in the UI references the file path directly.

Not present yet: Figma asset export requires either a manual export
from the Figma editor (Export panel on a selected layer) or a Figma API
token: this codebase currently has neither wired up, so `AppAssets`
declares the expected path ready to receive the real file without any
call site needing to change once it lands.
