# E-commerce-Only + MVI Refactor — Final Report

**Date:** 2026-08-13
**Scope:** Convert the repo from a 2-app monorepo (Customer + Rider) to a single E-commerce app, and formalize Auth as MVI (Intent → Cubit → State) with one `AuthCubit`.

> **Superseded note:** this report documents the state immediately after this step — a monorepo with one app (`apps/customer_app`) and three shared packages (`core`, `common`, `design_system`). A later restructuring removed the monorepo/`apps`/`packages` layer entirely and flattened everything into a single Flutter project at the repo root (`lib/core`, `lib/common`, `lib/features`). See [`docs/SINGLE_APP_RESTRUCTURE_REPORT.md`](./SINGLE_APP_RESTRUCTURE_REPORT.md) for that step. The content below is kept as an accurate historical record of this step; paths like `apps/customer_app/...` and `packages/core/...` no longer exist.

---

## 1. Final project structure

```text
flower_app/
├── apps/
│   └── customer_app/
│       └── lib/
│           ├── features/auth/
│           │   ├── presentation/{views,cubit,intent,state}/
│           │   ├── domain/{entities?,repositories}/
│           │   └── data/{datasources,repositories}/
│           ├── core/domain/entities/   # User, Address, Cart, Order, Notification
│           ├── di/
│           ├── routing/
│           └── constants/
├── packages/
│   ├── core/            # DI instance, Result/Failure, BaseCubit, network/storage contracts
│   ├── common/           # reusable widgets
│   └── design_system/    # colors, typography, spacing, theme, brand assets
└── docs/
```

`apps/rider_app/` and `packages/shared/` no longer exist. Melos discovers packages via the existing glob patterns (`apps/*`, `packages/*`) in `melos.yaml`, so no config edit was needed there.

---

## 2. Rider-related code removed

- `apps/rider_app/` — entire app (skeleton only: empty route lists, `RiderFoundationPreviewScreen`, 7 feature folders each containing only a `README.md`, no working screens).
- Rider mentions in `.vscode/launch.json` (3 launch configs + 1 compound config).
- Rider mentions in `README.md` (two-app framing, feature table row, dependency diagram, folder tree, setup instructions).
- Rider mentions in `packages/design_system`'s doc comments and `pubspec.yaml` description ("used by both apps").
- Rider mention in root `pubspec.yaml` description.
- `docs/FLOWERY_CODEBASE_GUIDE_AR.md` — rewritten: removed the "Rider App" section, the two-app diagrams, and all Rider-specific DI/routing/asset references; updated to reflect the new single-`AuthCubit` MVI flow.
- `docs/Flower_App_Figma_Analysis.md` — **not deleted**, since it documents the actual contents of the Figma source file (which genuinely contains two application designs). Added a scope note at the top and above the feature-mapping section clarifying that only the Customer/E-commerce content applies to this repo; the Rider/Tracking analysis is kept as an accurate record of the Figma file, not as a pending feature.

Confirmed via a final repo-wide grep for `rider` (case-insensitive) that zero references remain outside those two intentionally-preserved documentation notes.

---

## 3. What was kept as shared infrastructure, and why

- `packages/core`, `packages/common`, `packages/design_system` — kept as separate packages even with a single consuming app, because they still enforce real boundaries (DI/Result contracts, reusable widgets, design tokens) and stay independently testable. Collapsing them into `apps/customer_app` would work too, but wasn't requested and would lose that boundary enforcement for no benefit.
- `UserEntity` and `AddressEntity` — previously in `packages/shared` (justified only by being shared between Customer and Rider). With Rider gone, that package had a single consumer, so its content moved into `apps/customer_app/lib/core/domain/entities/`, alongside the existing cross-feature entities (`CartItemEntity`, `OrderEntity`, `NotificationEntity`) it's now consistent with.

---

## 4. Final MVI structure

```
View → Intent (sealed) → Cubit.onIntent() → Repository (interface)
     → Repository (impl) → DataSource → Result<Success|Failure>
     → Cubit → State (sealed) → View
```

Introduced for Auth specifically: `presentation/intent/auth_intent.dart` and `presentation/state/auth_state.dart` as real sealed classes (previously, Cubit public methods were the de-facto intent with no separate class — that convention still holds for `ResetPasswordCubit`, which was out of this task's explicit scope).

---

## 5. How `AuthCubit` handles Login / Sign Up / Forgot Password

One `AuthCubit extends BaseCubit<AuthState>` with a single dispatch entrypoint:

```dart
Future<void> onIntent(AuthIntent intent) => switch (intent) {
  LoginRequested() => _login(intent),
  GuestLoginRequested() => _continueAsGuest(),
  SignUpRequested() => _signUp(intent),
  ForgotPasswordRequested() => _sendPasswordResetEmail(intent),
};
```

Each private handler follows the same shape: `safeEmit(AuthLoading())` → call `AuthRepository` → `result.fold(failure → AuthFailed(message), success → AuthXxxSuccess(...))`. No validation or business logic lives in the Cubit — that stays in `Validators` (core) and the views.

`LoginCubit`, `SignUpCubit`, `ForgotPasswordCubit` were deleted, as instructed. `ResetPasswordCubit` was deliberately kept separate — it's not named in the task's 3-flow list, and it operates on a different repository call (`resetPassword()`, reached after OTP verification, not part of the Login/SignUp/ForgotPassword entry flow).

---

## 6. Files created / modified / removed

**Created:** `core/domain/entities/{user_entity,address_entity}.dart`, `presentation/intent/auth_intent.dart`, `presentation/state/auth_state.dart`, `presentation/cubit/auth_cubit.dart`, `presentation/cubit/reset_password_cubit.dart` (flattened), `presentation/state/reset_password_state.dart` (flattened), `docs/ECOMMERCE_MVI_REFACTOR_REPORT.md` (this file).

**Modified:** `pubspec.yaml` (root + `customer_app`), 4 auth views, `auth_local_data_source.dart`, `auth_repository_impl.dart`, `auth_repository.dart` (import fixes only), `di/auth_injector.dart`, `routing/customer_pages.dart`, `login_view_test.dart`, `README.md`, `docs/FLOWERY_CODEBASE_GUIDE_AR.md`, `docs/Flower_App_Figma_Analysis.md`, `packages/design_system/{pubspec.yaml,lib/constants/app_assets.dart}`, `.vscode/launch.json`.

**Removed:** `apps/rider_app/` (17 files), `packages/shared/` (4 files), old nested cubit folders `presentation/cubit/{login,sign_up,forgot_password,reset_password}/` (8 files).

Full, exact list is visible via `git status` in the repo.

---

## 7. Figma-related UI changes

None. This was an architecture-only refactor — no widget trees, spacing, colors, or copy were touched. All 5 auth screens (Login, Sign Up, Forgot Password, OTP Verification, Reset Password) were already Figma-verified pixel-accurate in prior work; only their Cubit/State wiring changed underneath the same UI.

---

## 8. Code standards applied

No `CODING_STANDARDS.md` exists anywhere in the repo (confirmed by search). In its absence, the refactor followed the codebase's own established, consistent conventions: feature-first Clean Architecture, plural `views/`/`widgets/` folders, singular `cubit/`/`state/` (and now `intent/`) folders, `BaseCubit` + `safeEmit`, `Result<T>`/`Failure` for error propagation, sealed classes for state/intent, meaningful names, no magic values, all user-facing strings through the `easy_localization` pipeline.

---

## 9. DI structure

```
main.dart → setupCustomerAppDependencies()
  ├── setupCoreDependencies()   (NetworkInfo, ApiClient, LocalStorageService)
  └── setupAuthDependencies()
        ├── registerLazySingleton<AuthLocalDataSource>
        ├── registerLazySingleton<AuthRepository>
        ├── registerFactory<AuthCubit>          (was 3 separate factories)
        └── registerFactory<ResetPasswordCubit>
```

`registerFactory` for Cubits (fresh instance per screen — Login/SignUp/ForgotPassword each get their own `AuthCubit` so form/error state can't leak between screens); `registerLazySingleton` for repositories/data sources.

---

## 10. Navigation structure

`GetMaterialApp(getPages: CustomerPages.pages, initialRoute: CustomerRoutes.splash)`. Registered routes: `/splash`, `/login`, `/sign-up`, `/forgot-password`, `/otp-verification`, `/reset-password` — each Auth screen wrapped in `BlocProvider(create: (_) => sl<AuthCubit>())`, Reset Password wrapped in `BlocProvider<ResetPasswordCubit>`. `CustomerRoutes.main` (post-login destination) has no `GetPage` registered yet — pre-existing gap, out of this task's scope, called out here rather than silently left for someone to hit at runtime.

---

## 11–13. Validation results

**No Flutter/Dart SDK is available in this environment** (confirmed at the start of this whole engagement, re-confirmed here) — `flutter analyze`, `flutter test`, `flutter run`, `flutter clean`, and `flutter pub get` could not be executed. In their place, static checks were run:

- Brace/paren/bracket balance check across all 18 created/modified Dart files — all balanced.
- Grep-based verification that no import references a deleted file path (`package:shared/...`, old nested cubit paths) — zero matches.
- Grep-based verification that no class reference to `LoginCubit`/`SignUpCubit`/`ForgotPasswordCubit` remains outside an explanatory doc comment.
- `pubspec.yaml` asset-path verification (Python + PyYAML) — all 4 declared asset globs (`images/`, `icons/`, `translations/`, `animations/`) resolve to real files.
- `.vscode/launch.json` JSONC syntax check (comment-stripped `json.load`) — valid.
- `melos.yaml` glob-based package discovery confirmed to need no edit for the new 1-app/3-package layout.

I did not run the app and cannot claim it launches successfully — that check requires a real Flutter toolchain and should be run locally (`flutter clean && flutter pub get && flutter analyze && flutter test && flutter run`) before merging. The manual flow (Login → Sign Up → Login → Forgot Password → Verification → Reset Password → Login → Home) should be re-walked at that point; I traced it in code (imports, method signatures, state transitions) and found it consistent, but that's not a substitute for running it.

---

## 14. Remaining issues (pre-existing, not introduced by this refactor)

- `CustomerRoutes.main` has no registered `GetPage` — login success currently navigates to a route with no screen behind it.
- `HomeCubit`/`CatalogRepository` exist in code but are unregistered in DI and have no wired views.
- Cart, Checkout, Orders, Notifications, Profile are scaffold-only (`README.md` placeholders, no Dart files).
- The `enterYourEmail` localization key still has the pre-existing typo ("Enter you email") on the Login screen (fixed only on Sign Up's newer keys).
- No Flutter toolchain in this sandbox — items 11–13 above need to be re-verified on a machine with Flutter installed before this is considered merge-ready.
