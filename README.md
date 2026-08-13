# Flowery

Flowery is a flower delivery e-commerce app — browse a flower catalog, add to cart, check out, pay, and track delivery. This repository **is** the Flutter app itself: a single, standard Flutter project (no monorepo, no `apps/` layer, no separate packages) organized with Clean Architecture and a feature-first `lib/` layout — see [Project structure](#project-structure).

---

## Main features

- Authentication — login, sign up, forgot/reset password, continue as guest
- Home & catalog — categories, best sellers, occasions, search, product details
- Cart, checkout (address + payment method), and order placement
- Order history and live order tracking
- Profile — edit details, saved addresses, reset password, logout

> See [Current status](#current-status) for what's actually implemented today versus planned.

---

## Architecture

- **Clean Architecture** — every feature is split into `presentation` (view + Cubit + sealed intent/state) → `domain` (entities + repository contracts) → `data` (repository implementations + data sources). Business logic lives in Cubits/repositories, never in a widget.
- **MVI + Cubit** — `flutter_bloc`'s `Cubit` is the state handler. A user action dispatches a sealed `Intent` (e.g. `AuthIntent`), the Cubit's `onIntent()` handles it and updates a sealed `State`, and the view reacts via `BlocBuilder`/`BlocConsumer`.
- **GetIt** — dependency injection / service locator (`lib/core/di/`). Dependencies are registered once at startup; Cubits, repositories, and data sources are never instantiated directly inside a view.
- **GetX** — used **only** for navigation (`GetMaterialApp`, `Get.toNamed`, ...). It is not used for state management anywhere in this codebase.
- **SOLID / OOP** — repositories are accessed through interfaces, every class has one responsibility, and intents/states are `sealed` so handling is exhaustive by construction.

**Data flow:** `View → Intent → Cubit → Repository interface → Repository impl → Data source → Result<Success|Failure> → State → View`

---

## Project structure

```text
flower_app/
├── android/
├── ios/
├── assets/
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   ├── animations/
│   └── translations/
├── lib/
│   ├── core/
│   │   ├── base/            # BaseCubit — safeEmit() guard against emitting after close()
│   │   ├── constants/       # AppAssets, AppAnimations, AppColors, AppDimens
│   │   ├── theme/           # AppTextStyles, AppTheme
│   │   ├── localization/    # AppStrings (wraps easy_localization's .tr())
│   │   ├── network/         # ApiClient contract, endpoints, connectivity check
│   │   ├── storage/         # LocalStorageService contract
│   │   ├── routing/         # GetX route names + GetPage table
│   │   ├── di/              # GetIt setup (app-level + per-feature injectors)
│   │   ├── error/           # Failure / Exception types
│   │   ├── result/          # Result<Success|Failure>
│   │   ├── extensions/
│   │   ├── usecase/
│   │   ├── utils/           # Validators
│   │   └── domain/entities/ # Cross-feature entities (User, Address, Cart, Order, ...)
│   ├── common/
│   │   ├── widgets/         # Buttons, inputs, dialogs, loading/error/empty states
│   │   ├── dialogs/
│   │   ├── extensions/
│   │   └── formatters/
│   └── features/
│       ├── auth/            # Login, Sign Up, Forgot Password — one AuthCubit
│       ├── home/
│       ├── catalog/
│       ├── cart/            # scaffold only
│       ├── checkout/        # scaffold only
│       ├── orders/          # scaffold only
│       ├── notifications/   # scaffold only
│       └── profile/         # scaffold only
├── test/
├── docs/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

Each feature follows `presentation/{view,cubit,intent,state}` → `domain/{entities,repositories,use_cases}` → `data/{models,repositories,data_sources}` — layers that aren't actually needed for a given feature (e.g. no `use_cases/` where a repository call needs no orchestration) aren't manufactured just to fill the template.

---

## Figma

Figma is the **source of truth for UI/UX** — layout, spacing, components, and visual structure.

- **Design file:** [Figma — Flower app](https://www.figma.com/design/jefwMXqsdkzUdJgfyM9otG/Flower-app?node-id=217-640&t=O9aY9pm7bCpMdofy-0)
- **Full flow analysis:** [`docs/Flower_App_Figma_Analysis.md`](docs/Flower_App_Figma_Analysis.md) — screen inventory, navigation flows, and open design questions. Read it before implementing a screen.

---

## Design system

Centralized under `lib/core/` so tokens and shared widgets are never scattered through the UI:

- **Colors, typography, spacing, and radii** as named tokens (`AppColors`, `AppDimens`, `AppTextStyles` in `core/constants/` and `core/theme/`) — never hardcode a raw value in a widget.
- **Theme** — one `ThemeData` (`AppTheme.light`).
- **Shared components** — buttons, text fields, dialogs, loading/error/empty states, in `lib/common/widgets/`.
- **Assets** — every asset path is a constant on `AppAssets`/`AppAnimations`, never a raw string literal; physical files live under `assets/`.
- **English / Arabic** — translation files (`assets/translations/*.json`) drive `AppStrings`' `.tr()`-backed getters; no screen calls `Text('Login')` directly.
- **RTL / LTR** — shared widgets use Flutter's standard directionality-aware layout; no language switcher is wired up yet.

---

## Current status

| Area | Status |
|---|---|
| Auth (login, sign up, forgot/reset password) | ✅ Implemented |
| Splash | ✅ Implemented |
| Home / Catalog | 🟡 In progress (data + Cubit exist, views pending) |
| Cart, Checkout, Orders, Notifications, Profile | ⬜ Planned |
| Routing | ✅ Auth flow + Splash wired via `GetPage`; remaining screens pending |
| API / backend integration | ⬜ Not started — data sources are in-memory placeholders |

---

## Setup

**Requirements:** Flutter/Dart SDK compatible with `^3.5.0`.

```bash
git clone https://github.com/menna3lwan/flower_app.git
cd flower_app
flutter pub get
flutter run
```

Analyze and test:

```bash
flutter analyze
flutter test
```

---

## Contribution

1. Create a feature branch (`feature/<short-description>`) off `development`.
2. Follow Clean Architecture + MVI — `presentation/domain/data` per feature, business logic in Cubits/repositories only.
3. Follow the existing naming and architecture conventions already established in `lib/core`/`lib/common`.
4. Match the linked Figma design.
5. Run `flutter analyze` and `flutter test` before opening a PR.
6. Open a Pull Request against `development`.

---

## Documentation

| File | Contents |
|---|---|
| `README.md` | This file — project overview, architecture, setup |
| `docs/Flower_App_Figma_Analysis.md` | Full Figma flow analysis, screen inventory, and design system reference |
| `docs/FLOWERY_CODEBASE_GUIDE_AR.md` | Arabic-language deep dive into the codebase and architecture |
| `docs/ECOMMERCE_MVI_REFACTOR_REPORT.md` | Report of the refactor that removed the old Rider app and introduced MVI for Auth (superseded — see below) |
| `docs/SINGLE_APP_RESTRUCTURE_REPORT.md` | Report of the refactor that collapsed the monorepo into this single Flutter project |
