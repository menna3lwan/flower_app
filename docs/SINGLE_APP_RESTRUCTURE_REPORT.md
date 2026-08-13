# Single E-commerce App Restructure — Final Report

**Date:** 2026-08-13
**Scope:** Collapse the monorepo (`apps/customer_app` + `packages/{core,common,design_system}`) into one standard Flutter project at the repo root. No feature logic changed.

---

## 1. Final folder structure

```text
flower_app/
├── android/
├── ios/
├── assets/
│   ├── images/ (15, incl. brand logo)
│   ├── icons/ (47, incl. brand icon)
│   ├── fonts/ (Inter, Outfit, Roboto, IMFellEnglish)
│   ├── animations/ (3)
│   └── translations/ (en.json, ar.json)
├── lib/
│   ├── app.dart
│   ├── main.dart
│   ├── core/
│   │   ├── base/            # BaseCubit, ViewStatus
│   │   ├── constants/       # AppAssets (merged), AppAnimations, AppColors, AppDimens
│   │   ├── theme/           # AppTextStyles, AppTheme
│   │   ├── localization/    # AppStrings
│   │   ├── network/         # ApiClient, ApiEndpoints, NetworkInfo
│   │   ├── storage/         # LocalStorageService
│   │   ├── routing/         # CustomerRoutes, CustomerPages (GetPage table)
│   │   ├── di/              # injector.dart (sl), customer_app_injector.dart, auth_injector.dart
│   │   ├── error/           # Failure, exceptions
│   │   ├── result/          # Result<Success|Failure>
│   │   ├── extensions/, usecase/, utils/
│   │   └── domain/entities/ # User, Address, Cart, Order, Notification, Category, Occasion, Product
│   ├── common/
│   │   ├── widgets/         # buttons/, inputs/, media/, states/, + top-level widgets
│   │   ├── dialogs/, extensions/, formatters/
│   └── features/
│       ├── auth/            # presentation/{views,cubit,intent,state}, domain/, data/
│       ├── home/, catalog/, splash/
│       └── cart/, checkout/, orders/, notifications/, profile/  (scaffold-only)
├── test/
├── docs/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

`apps/`, `packages/`, and `melos.yaml` no longer exist.

---

## 2. Rider code/files removed

None in this step — the Rider app (`apps/rider_app`) and the last Rider references in docs/config were already removed in the prior refactor (see `docs/ECOMMERCE_MVI_REFACTOR_REPORT.md`). A repo-wide grep for `rider` (case-insensitive) at the end of this step confirms zero matches outside the two historical documentation notes that intentionally record the old Rider app's existence (`docs/Flower_App_Figma_Analysis.md`, `docs/FLOWERY_CODEBASE_GUIDE_AR.md`).

---

## 3. Final E-commerce feature structure

```
lib/features/
├── auth/         ✅ complete (Login, Sign Up, Forgot Password, OTP screen, Reset Password)
├── home/         🟡 Cubit/State only, no view, unregistered in DI
├── catalog/      🟡 domain + data only, no presentation layer
├── splash/       ✅ complete, wired as initialRoute
├── cart/         ⬜ scaffold (README only)
├── checkout/     ⬜ scaffold
├── orders/       ⬜ scaffold
├── notifications/⬜ scaffold
└── profile/      ⬜ scaffold
```

Each implemented feature follows `presentation/{views,cubit,intent,state}` → `domain/{repositories}` → `data/{datasources,repositories}`. No `use_cases/` layer exists anywhere in the app — every current repository call is a single, un-orchestrated operation, so a use case would be a pass-through wrapper adding no value; consistent with "don't manufacture layers that aren't needed."

---

## 4. MVI architecture diagram

```
USER → VIEW → INTENT (sealed) → CUBIT.onIntent() → DOMAIN (Repository interface)
     → DATA (Repository impl → DataSource) → RESULT<Success|Failure>
     → CUBIT → STATE (sealed) → VIEW
```

Applied fully to Auth (`AuthIntent`/`AuthState`, real sealed classes). Other features (`Home`, `Catalog`) currently only have a `Cubit`/`State` pair with no separate `Intent` class and no view — they predate this task and are unchanged, since introducing new Intent classes or business logic for unimplemented screens would be new feature work, out of scope here ("do not start implementing new features").

---

## 5. AuthCubit flow

Unchanged from the prior refactor — still one `AuthCubit extends BaseCubit<AuthState>` with `onIntent()` dispatching `LoginRequested` / `GuestLoginRequested` / `SignUpRequested` / `ForgotPasswordRequested` to private handlers, each following `safeEmit(AuthLoading())` → repository call → `result.fold(...)`. `ResetPasswordCubit` remains intentionally separate. Only its file location changed: `lib/features/auth/presentation/cubit/auth_cubit.dart` (was `apps/customer_app/lib/features/auth/presentation/cubit/auth_cubit.dart`).

```
AuthCubit
    │
    ├── Login              → AuthRepository.login()
    ├── Sign Up             → AuthRepository.signUp()
    └── Forgot Password     → AuthRepository.sendPasswordResetEmail()
                    ↓
              AuthRepository (interface, lib/features/auth/domain/repositories/)
                    ↓
              AuthRepositoryImpl (lib/features/auth/data/repositories/)
                    ↓
              AuthLocalDataSource (mock, lib/features/auth/data/datasources/)
```

---

## 6. DI structure

```
main.dart
   ↓ setupCustomerAppDependencies()   (lib/core/di/customer_app_injector.dart)
   ├── setupCoreDependencies()         (lib/core/di/injector.dart)
   └── setupAuthDependencies()         (lib/core/di/auth_injector.dart)
         ├── registerLazySingleton<AuthLocalDataSource>
         ├── registerLazySingleton<AuthRepository>
         ├── registerFactory<AuthCubit>
         └── registerFactory<ResetPasswordCubit>
```

`di/` moved from `lib/di/` to `lib/core/di/` to match the requested `core/di/` layout. No repository, data source, or Cubit is ever instantiated directly in a view — every one is resolved through `sl<T>()`.

---

## 7. Routing structure

`GetMaterialApp(getPages: CustomerPages.pages, initialRoute: CustomerRoutes.splash)`, both now under `lib/core/routing/` (moved from `lib/routing/`). Registered routes: `/splash`, `/login`, `/sign-up`, `/forgot-password`, `/otp-verification`, `/reset-password`, each Auth screen wrapped in `BlocProvider(create: (_) => sl<AuthCubit>())`. `CustomerRoutes.main` (post-login destination) still has no `GetPage` registered — pre-existing gap, unrelated to this restructuring, called out again for visibility.

GetX is used for `GetMaterialApp`/`GetPage`/route navigation only; no `GetxController` or reactive `.obs` state exists anywhere in the codebase.

---

## 8. Files moved / created / removed

**Moved (content unchanged, only path + internal imports updated):** all of `apps/customer_app/{android,ios,assets,test,lib/features,lib/common,lib/core}` to repo root; `apps/customer_app/lib/{app.dart,main.dart,foundation_preview_screen.dart}` to `lib/`; `lib/di/*` → `lib/core/di/`; `lib/routing/*` → `lib/core/routing/`; `lib/constants/app_strings.dart` → `lib/core/localization/app_strings.dart`; `lib/constants/app_animations.dart` → `lib/core/constants/app_animations.dart`; all of `packages/core/lib/*` → `lib/core/*`; all of `packages/common/lib/*` → `lib/common/*`; `packages/design_system/lib/constants/{app_colors,app_dimens}.dart` → `lib/core/constants/`; `packages/design_system/lib/theme/*` → `lib/core/theme/`; `packages/design_system/assets/{images/flower_app_logo.png,icons/flowery_icon.svg,fonts/*.ttf}` → `assets/{images,icons,fonts}/`.

**Created:** merged `lib/core/constants/app_assets.dart` (combines the app's full asset registry with design_system's brand logo/icon constants — previously two separate classes both named `AppAssets`); this report; `pubspec.yaml` (rewritten, merging all four old pubspecs' dependencies); `.gitignore` (dropped the now-meaningless `apps/*/pubspec.lock`/`packages/*/pubspec.lock` rules).

**Removed:** `apps/` and `packages/` directories entirely (including their individual `pubspec.yaml`/`pubspec.lock`/`analysis_options.yaml`/`devtools_options.yaml`), `melos.yaml`, the old workspace-root `pubspec.yaml` (replaced by the real app manifest), stale root `pubspec.lock`/`.dart_tool` (regenerated fresh once the new `pubspec.yaml` was in place).

No feature Dart file's logic, class names, or public API changed — only file location and import statements.

---

## 9. Figma compliance changes

None. This was a structural-only refactor; no widget tree, spacing, color, or copy changed anywhere.

---

## 10. Code Standards compliance

No `CODING_STANDARDS.md` exists in the repo (confirmed by search, as in the prior refactor). Followed the codebase's own established conventions: relative imports for same-directory/feature-local references, absolute `package:customer_app/...` imports for cross-layer references (core ↔ features, common ↔ features) — chosen deliberately over deep `../../../../` relative chains for the files that moved, since it removes an entire class of fragile depth-counting errors and is a widely accepted Dart convention for cross-directory imports. No magic values were introduced; the merged `AppAssets` class removes what had become a duplicate-abstraction problem (two classes named `AppAssets` serving overlapping purposes) rather than papering over it.

---

## 11–13. Validation results

**No Flutter/Dart SDK is available in this sandbox** — `flutter analyze`, `flutter test`, and `flutter run` could not be executed directly by me. In their place:

- Brace/paren/bracket balance check across all 71 lib+test Dart files — all balanced.
- A Python import-resolution check parsed every relative (`'./...'`, `'../...'`) import in all 71 files and confirmed each one resolves to a real file on disk after the move — 72/72 relative imports valid.
- A second pass checked every `package:customer_app/...` absolute import (118 of them) against the new `lib/` tree — all 118 resolve to real files.
- `pubspec.yaml` was parsed as YAML and its `assets:`/`fonts:` entries verified against disk — all 4 asset directories and the one declared font file exist.
- `.vscode/launch.json` was rewritten (removed the `apps/customer_app` `cwd`, since the project root is now the Flutter project root) and validated as syntactically correct JSONC.
- A final repo-wide grep confirmed no remaining references to `apps/customer_app`, `apps/rider_app`, `packages/core`, `packages/common`, `packages/design_system`, `packages/shared`, or `melos` in `lib/`, `test/`, `README.md`, `.vscode/launch.json`, or `pubspec.yaml` (the two intentional historical mentions in the Arabic guide are the only remaining hits, and are correctly labeled as historical).

**Independent signal worth noting:** partway through this session, this sandbox's mounted copy of the repo picked up a freshly regenerated `pubspec.lock` that successfully resolves `get_it` and `google_fonts` as direct dependencies — consistent with something on your machine (an IDE's Dart/Flutter tooling) having run `flutter pub get` against the new merged `pubspec.yaml` in the background and succeeding. That's a good sign, but it isn't something I triggered or can fully verify from here, so please still run the full checklist below yourself.

I did not and cannot run the app. Before merging, please run locally:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run
```

and re-walk the flow: Login → Sign Up → Login → Forgot Password → Verification → Reset Password → Login → Home.

---

## 14. Remaining issues (pre-existing, not introduced by this restructuring)

- `CustomerRoutes.main` has no registered `GetPage` — login success currently navigates to a route with no screen behind it.
- `HomeCubit`/`CatalogRepository` exist but are unregistered in DI and have no wired views.
- Cart, Checkout, Orders, Notifications, Profile remain scaffold-only.
- `AppTextStyles` uses `GoogleFonts.inter()` dynamically; the local `assets/fonts/inter.ttf` declared in `pubspec.yaml`'s `fonts:` section is therefore unused in practice, and `Outfit.ttf`/`roboto.ttf`/`IMFellEnglish.ttf` are present as files but registered nowhere. Left unchanged (moved as-is) since removing or wiring them up would be a behavior change outside this task's scope — flagged here for a deliberate follow-up decision.
- The `enterYourEmail` localization typo ("Enter you email") on the Login screen, noted in the prior report, is still present.
- No Flutter toolchain in this sandbox — items 11–13 need real verification on a machine with Flutter installed.
