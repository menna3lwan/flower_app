# Flowery — monorepo

Two independent Flutter apps sharing one brand and one technical
foundation, managed as a [Melos](https://melos.invertase.dev) workspace.

```text
flowery_workspace/
├── apps/
│   ├── customer_app/   # Flowery — customer / e-commerce app
│   └── rider_app/      # Flowery Rider — delivery / tracking app
├── packages/
│   ├── core/           # network, error/result types, storage, DI helper, base Cubit
│   ├── common/         # reusable UI: buttons, inputs, dialogs, loading/error/empty states
│   ├── design_system/  # colors, typography, dimens, theme, shared brand assets
│   └── shared/         # genuinely shared domain models (User, Address) only
├── docs/                # Figma flow analysis, this repo's architecture notes
├── melos.yaml
└── pubspec.yaml         # workspace root — not a buildable app, holds only the melos dev-dependency
```

## Getting started

```bash
dart pub global activate melos
melos bootstrap   # or: melos bs
```

Then, per app:

```bash
cd apps/customer_app && flutter run
cd apps/rider_app && flutter run   # architecture scaffold only — no screens yet
```

## Workspace scripts

```bash
melos run analyze   # flutter analyze in every package/app
melos run test       # flutter test in every package/app with a test/ dir
melos run format     # dart format --set-exit-if-changed .
melos run clean       # flutter clean everywhere
```

## Dependency rules

`apps/*` may depend on any `packages/*`. `packages/*` must never depend on
an app, and — in this workspace — do not depend on each other either
(`core`, `common`, `design_system`, `shared` are each independent leaves).
See `docs/MONOREPO.md` for the full rationale and current status.
