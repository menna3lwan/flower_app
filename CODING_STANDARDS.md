# Flower App — Coding Standards

This document codifies the engineering rules enforced across this codebase. It is normative: new code that doesn't comply should not be merged, and existing code that doesn't comply should be refactored when touched.

## Architecture

Clean Architecture with a feature-first layout. Each feature owns `presentation/`, `domain/`, `data/`; cross-feature concepts (entities five+ features share, like `ProductEntity`) live in `core/domain` as a shared kernel rather than being duplicated per feature.

Dependency direction is one-way: `presentation → domain → data`. Presentation depends on domain's abstract repository interfaces, never on a data-layer implementation class directly. `data/repositories/*_impl.dart` is the only place that imports both a domain interface and a concrete data source.

## State management: MVI via Cubit

MVI is implemented pragmatically on top of `flutter_bloc`'s Cubit, not as a separate Intent class hierarchy:

- **Model** = the sealed `*State` class for the feature (e.g. `LoginState`).
- **Intent** = the public method call on the Cubit (e.g. `loginCubit.login(...)`). The method call itself is the intent — there is no separate `LoginIntent` object dispatched through a stream, because Cubit's public API already gives every intent a name, a type-checked signature, and a single handler. Introducing a parallel Intent class hierarchy on top of that would duplicate the Cubit's own method table without adding predictability.
- **State handler** = the Cubit method body, which calls into the domain layer and emits a new state.
- **View** = a `StatelessWidget`/`StatefulWidget` that renders from `BlocBuilder`/`BlocConsumer` and calls Cubit methods on user interaction. It never branches on domain data itself — only on the sealed state.

Every feature state is a `sealed class` extending `Equatable`, with `Initial`/`Submitting or Loading`/`Success or Loaded`/`Failed or Error` variants (naming follows what reads best for that screen — a form uses `Submitting`/`Failed`, a data screen uses `Loading`/`Error`). Sealed classes make it a compile error to add a new state variant without updating every `switch` that pattern-matches on it.

Every Cubit extends `BaseCubit` (`core/base/base_cubit.dart`), which adds `safeEmit()` — a guard against emitting after the Cubit has closed. No business logic lives in a Cubit beyond orchestration: calling a repository method and mapping the `Result` to a state. Validation rules live in `Validators` (`core/utils/validators.dart`); domain rules live in the repository/use case.

## Dependency injection: GetIt

`sl` (`core/di/injector.dart`) is the single `GetIt` instance. `core/di/injector.dart` registers only cross-feature infrastructure (network, storage, locale). Each feature registers its own bindings from its own `di/<feature>_injector.dart`, called from `main.dart` in dependency order — a feature that resolves another feature's repository (e.g. `home` resolves `CatalogRepository`) must be registered after that feature.

Repositories and data sources are `registerLazySingleton` (stateless, safe to share). Cubits are `registerFactory` — every screen push must get its own instance, never a disposed leftover from a previous visit.

Nothing constructs a repository, data source, or Cubit with `SomeClass()` outside its own `di/` file. Everything else asks `sl<T>()`.

## GetX: navigation and locale only

`GetMaterialApp`/`Get.toNamed`/`Get.offAllNamed`/`Get.back` for navigation, and `Get.updateLocale` for locale switching (the one exception — see `core/localization/locale_controller.dart` — because `Get.updateLocale` is what actually triggers `Directionality` to rebuild). GetX is never used for feature state; that is Cubit's job exclusively. Do not introduce `GetxController`/`Obx`/`.obs` anywhere in this codebase.

## Comments

Every comment is a single line. No `///`/`//` block spans more than one line — if an idea needs more than one line to explain, either the code needs a better name/structure, or the explanation belongs in this document instead of inline.

Comments exist only for: a non-obvious architectural decision (why a shared kernel entity lives in `core/domain`), a technical constraint (why `ApiClient` has no `dio` import yet), a workaround, or a call-out of something a reader would otherwise assume is a mistake (why `AppStrings` holds key names, not English text). Comments are never a paraphrase of the line below them.

## Magic numbers and strings

Anything that repeats, or that expresses a design-system value (spacing, radius, color, duration, type scale), is a named constant in `core/constants` or `core/theme` — never a literal at the call site.

Genuinely one-off, widget-local layout numbers (a 28px stepper button, a 64px OTP box, a `SizedBox(width: 6)` between a price and its strikethrough) are left as literals. Promoting every such number to a named token would create a constant for every pixel in the design with no reuse, which is over-engineering, not consistency. The dividing line: if the same value shows up in a second place, or it comes directly from the Figma type/spacing scale, name it; if it is a one-off implementation detail of a single small widget, leave it inline.

All user-facing strings render via `context.l10n.xxx`. `AppStrings` holds translation *key names* only, kept in the same order as the getters in `AppLocalizations` so the two stay diffable — nothing renders `AppStrings.xxx` directly as display text.

## Localization and RTL

Every UI string goes through `assets/translations/{en,ar}.json` via `AppLocalizations`/`context.l10n`. Adding a language means adding a `Locale` to `SupportedLocales` and a matching JSON file — no other file changes. RTL is never hand-rolled: `Directionality` is derived automatically from the active `Locale`, and widgets that need direction-awareness use `PositionedDirectional`/`EdgeInsetsDirectional`/`matchTextDirection: true` rather than hardcoded `left`/`right`.

## Repository pattern and DIP

Every repository is an abstract interface in `domain/repositories/`, implemented in `data/repositories/`. The implementation is the only place `try/catch` appears for that feature's operations — it translates data-layer `Exception`s into domain `Failure`s and returns a `Result<T>`, so Cubits are exception-free. A repository implementation depends on its data source's *interface*, never a concrete `*Impl` class, even when only one implementation exists yet (this was caught and fixed once already in `CatalogRepositoryImpl`, which is why it is called out explicitly here).

## What "UI skeleton" currently means

No feature does real network I/O yet. Every data source returns deterministic dummy data after a simulated `Future.delayed`. `AppImagePlaceholder` stands in for every product/avatar photo. This is intentional for the current phase — swapping in a real `ApiClient` implementation and real media should not require touching a single Cubit or View, because both only ever depended on the abstract repository interface.

## Code review checklist

Before merging any change, confirm: business logic is not in a View; the Cubit only orchestrates; new states are sealed and exhaustive; GetIt is used for every cross-class dependency instead of a concrete constructor call; GetX is not used for state; every user-facing string and design-system value is centralized, with only genuinely widget-local numbers left inline; every comment is one line and explains a *why*; and the change does not duplicate an abstraction that already exists elsewhere in `core`/`common`.
