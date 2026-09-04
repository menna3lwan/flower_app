# Commerce Module — Architecture & Branching Proposal

**Status: analysis only — nothing in this document has been implemented.**
Scope: Home, Categories, Best Seller, Occasions, Product Details. No other Commerce feature is included.

> **Revision (2026-08-24):** Section 4 below and Open Item #1 originally
> recommended keeping the shared module as flat `lib/features/catalog/`
> with the 5 features as flat siblings, matching the rest of the
> codebase's convention. That was superseded by explicit direction: the
> Commerce foundation is now nested as a real `lib/features/commerce/`
> folder (`shared/` + the 5 feature folders), so the folder structure
> mirrors the `commerce` git branch directly. All paths in this document
> have been updated to reflect that; the reasoning in Section 4 about
> *why* things are shared is unchanged, only *where they live* changed.

Sources used:
- Architecture Figma (FigJam board) — `Module Git Flow`, node `100:229`
- UI/UX Figma (design file) — `Flower-app`, node `19:1916`, page "E-commerce app"
- Existing codebase — `lib/core/`, `lib/common/`, `lib/features/auth/` (reference implementation), `lib/features/commerce/shared/`, `lib/features/commerce/home/`

---

## 0. What the architecture Figma actually says

The board is not abstract — it documents a pattern the team already used once, for Auth, and explains *why*:

> No duplicated repos/data sources/API clients — one AuthRepository serves login, signup, forget password, instead of three copies. Shared state has a proper home — tokens, AuthStatusNotifier, session logic live inside auth/, not leaked into core/. Stable structure — business domains (Auth, Orders, Profile) rarely change; Jira tickets under them change every sprint. Clean DI — one registration per repository/service. Parallel team work without collisions — devs can own a whole module (Commerce, Orders) independently, with clear boundaries. Matches official Flutter guidance — group by feature with a shared core that features depend on, never grouping by task.

The board's own org chart names the Flowery App's top-level business modules explicitly:

```
Flowery App
 ├── Auth
 ├── Commerce      ← this task
 ├── Orders
 ├── Addresses
 └── Profile
```

And it shows the exact git-flow already used for Auth, which this proposal mirrors 1:1 for Commerce:

```
main → develop → [someone builds the base clean-architecture skeleton] → auth module
                                                                              │
                                              ┌───────────────┬──────────────┘
                                              ▼               ▼
                                            login           sign_up
                                              │               │
                                              └── Merge after PR approval ──┐
                                                                            ▼
                                                                      auth module
                                                                            │
                                                            PR without Code Review
                                                            ("already reviewed feature-
                                                             by-feature, no need to
                                                             re-review the merge up")
                                                                            ▼
                                                                        develop
```

A second sticky note gives a concrete folder sketch for Commerce specifically (it names `commerce_mapper.dart`, `categories_response.dart`, `category_dto.dart`, and `UI/categories/manager/pages/widgets`), confirming the intended shape: **one shared `data/` + `domain/` for the whole module, one `UI/<feature>/` per screen.** Section 2 below adapts that sketch to how this codebase is already organized (see Section 1).

---

## 1. Critical finding: most of the shared layer already exists

Before proposing anything new, here is what a `git status`-level read of the repo shows already built, unregistered, or half-built. **The proposal in this document is deliberately written to complete and wire this up, not replace it** — creating a parallel structure here would itself violate the "no duplicated architecture" rule the Figma board insists on.

| Piece | Status | Location |
|---|---|---|
| `ProductEntity`, `CategoryEntity`, `OccasionEntity` | ✅ exists | `lib/core/domain/entities/` |
| `CatalogRepository` (contract, 8 methods incl. search) | ✅ exists | `lib/features/commerce/shared/domain/repositories/catalog_repository.dart` |
| `CatalogRepositoryImpl` | ✅ exists (wraps local only) | `lib/features/commerce/shared/data/repositories/` |
| `CatalogLocalDataSource` (dummy/offline data) | ✅ exists | `lib/features/commerce/shared/data/datasources/` |
| Remote data source / API service / DTOs / mappers | ❌ missing | would live under `lib/features/commerce/shared/data/{api,models,mappers,datasources}/` |
| `domain/usecases/` for catalog | ❌ missing | `HomeCubit` currently calls `CatalogRepository` directly — inconsistent with Auth's own UseCase layer |
| `ProductCard` (shared widget, compact **and** full grid variant via a nullable `onAddToCart`) | ✅ exists | `lib/common/widgets/product_card.dart` |
| `AppSectionHeader` ("Title + View All") | ✅ exists | `lib/common/widgets/app_section_header.dart` |
| `EmptyState` / `ErrorView` / `LoadingView` | ✅ exist | `lib/common/widgets/states/` |
| `AppImagePlaceholder` | ✅ exists (explicit "no real images yet" placeholder) | `lib/common/widgets/media/` |
| `HomeCubit` / `HomeState` (sealed `Loading/Loaded/Error`) | 🟡 skeleton exists, not wired to DI or a route | `lib/features/commerce/home/presentation/` |
| Route **name constants** for all 5 screens | ✅ already reserved | `lib/core/routing/customer_routes.dart` (`categories`, `bestSellerListing`, `occasionListing`, `productDetails`, `search`) |
| Route **registrations** (`GetPage`) for any of the 5 | ❌ none registered | `lib/core/routing/customer_pages.dart` |
| DI registration for `CatalogRepository`/data source | ❌ not registered anywhere | would live in a new `lib/features/commerce/shared/di/catalog_module.dart`, wired into `customer_app_injector.dart` |
| `core/usecase/usecase.dart` (`UseCase<T, Params>` base contract) | ✅ exists, already used by Auth | ready to reuse for catalog use cases |

Conclusion: **`lib/features/commerce/shared/` already *is* the shared Commerce data+domain foundation** the architecture Figma calls for — it's just incomplete and disconnected. The `commerce` base branch's job is to finish and connect it, not invent a competing `lib/features/commerce/data/...` tree next to it.

---

## 2. Final Commerce structure

**Superseded by the 2026-08-24 revision above.** `commerce` is now a real
`lib/features/commerce/` folder that mirrors the `commerce` git branch —
`shared/` holds the data+domain foundation, and the 5 features live
underneath it as their own presentation-only folders. `auth`, `cart`,
`checkout`, `orders`, `profile` remain flat siblings under `lib/features/`
as before; only Commerce is nested, because Commerce is the module that
explicitly needs a shared base multiple feature branches build on top of.

```
lib/
├── core/
│   └── domain/entities/
│       ├── product_entity.dart          # ✅ existing — shared kernel, features depend on it, never edit per-feature
│       ├── category_entity.dart         # ✅ existing
│       └── occasion_entity.dart         # ✅ existing
│
├── common/widgets/                       # ✅ existing — shared presentation, app-wide (not Commerce-only)
│   ├── product_card.dart                 #    compact variant (onAddToCart: null) + full grid variant (onAddToCart: set)
│   ├── app_section_header.dart           #    "Title + View All" — Home's 3 sections all use this
│   ├── route_placeholder_view.dart       #    app-wide "coming soon" screen, reused by all 4 reserved Commerce routes
│   └── states/{loading_view,error_view,empty_state}.dart
│
├── features/
│   ├── commerce/                         # 🆕 the Commerce base module/branch
│   │   ├── shared/                       # 🟡 THE shared Commerce data+domain module — completed, not recreated
│   │   │   ├── domain/
│   │   │   │   ├── repositories/catalog_repository.dart        # ✅ exists — single contract, 8 methods
│   │   │   │   └── usecases/                                   # ❌ add: one thin UseCase per repository method
│   │   │   │       (GetCategoriesUseCase, GetOccasionsUseCase, GetBestSellersUseCase,
│   │   │   │        GetProductsByCategoryUseCase, GetProductsByOccasionUseCase,
│   │   │   │        GetProductByIdUseCase, SearchProductsUseCase)
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── catalog_local_data_source.dart          # ✅ exists (dummy data, kept as offline/dev fallback)
│   │   │   │   │   └── catalog_remote_data_source.dart         # ❌ add, once a real backend exists (mirrors auth's pattern)
│   │   │   │   ├── api/catalog_api_service.dart                # ❌ add — Retrofit, one shared client
│   │   │   │   ├── models/ (category_dto.dart, product_dto.dart, occasion_dto.dart, ...)  # ❌ add
│   │   │   │   ├── mappers/catalog_mapper.dart                 # ❌ add — DTO ⇄ Entity, one file, not one per feature
│   │   │   │   └── repositories/catalog_repository_impl.dart   # ✅ exists — extend to pick local vs remote
│   │   │   ├── di/catalog_module.dart                          # ❌ add — Injectable registrations (mirrors features/auth/di/auth_module.dart)
│   │   │   ├── routing/commerce_pages.dart                     # ✅ exists — Commerce's own GetPage slice, names still sourced from core/routing/customer_routes.dart
│   │   │   ├── widgets/selectable_tab_bar.dart                 # ❌ add — shared Categories/Occasions tab row, one copy
│   │   │   └── constants/commerce_constants.dart                # ❌ add once Commerce-only constants are identified
│   │   │
│   │   ├── home/                         # 🟡 skeleton exists — presentation only
│   │   │   └── presentation/{cubit,state,views,widgets}/
│   │   ├── categories/                   # ❌ create
│   │   │   └── presentation/{cubit,state,views,widgets}/
│   │   ├── best_seller/                  # ❌ create
│   │   │   └── presentation/{cubit,state,views,widgets}/
│   │   ├── occasions/                    # ❌ create
│   │   │   └── presentation/{cubit,state,views,widgets}/
│   │   └── product_details/              # ❌ create
│   │       └── presentation/{cubit,state,views,widgets}/
│
└── core/routing/
    ├── customer_routes.dart              # ✅ names already reserved for all 5 — still the single source of truth
    └── customer_pages.dart               # ✅ spreads in `CommercePages.pages`, `/main` stays app-shell-owned here
```

### Purpose of each folder
- **`core/domain/entities/`** — the shared kernel. `ProductEntity`/`CategoryEntity`/`OccasionEntity` already model everything Figma shows (price, discount, rating, stock, description, includes, gallery). No feature may define its own product/category/occasion model.
- **`common/widgets/`** — shared, app-wide presentation. `ProductCard` and `AppSectionHeader` are the two widgets every one of the 5 screens visually depends on (confirmed by Figma: the same card renders on Home, Categories, Best Seller, Occasions, and Search).
- **`features/commerce/shared/`** — the single shared data+domain module for Commerce: one repository contract, one implementation, one set of use cases, one API client, one mapper. This is the direct answer to "no duplicated repos/data sources/API clients" from the architecture Figma.
- **`features/<feature>/presentation/`** — each of the 5 screens owns only its own Cubit, State, View, and screen-specific widgets. Nothing here is shared with another feature; nothing here defines its own copy of data already in `catalog`/`core`/`common`.
- **`core/routing/`** — the single navigation seam between features. Features never import each other's Cubit/View/Widget files directly; they only navigate to a route name and pass an argument.

---

## 3. Five feature boundaries

| | Responsibility | Data it needs | Consumes from shared | Feature-private |
|---|---|---|---|---|
| **Home** | Landing screen: header (logo/search entry/location), Categories row, Best Seller row, Occasion row, each with "View All" | `getCategories()`, `getBestSellers()`, `getOccasions()` | `ProductCard` (compact, no `onAddToCart`), `AppSectionHeader`, entities | greeting/location-selector header widget |
| **Categories** | Full category browsing: search+filter bar, category tab row (All + named categories), 2-col product grid, Sort-by sheet | `getCategories()` (tabs), `getProductsByCategory(id)` / `getAllProducts()` | `ProductCard` (full, with `onAddToCart`), entities | category tab-row widget*, Sort-by bottom sheet |
| **Best Seller** | Full best-seller listing: back+title+subtitle, 2-col product grid — no search/filter/tabs in Figma | `getBestSellers()` | `ProductCard` (full) | nothing beyond the screen scaffold |
| **Occasions** | Full occasion browsing: back+title+subtitle, occasion tab row (Wedding/Graduation/Birthday/Katb Ketab…), 2-col grid | `getOccasions()` (tabs), `getProductsByOccasion(id)` | `ProductCard` (full) | occasion tab-row widget* |
| **Product Details** | Single product view: image carousel w/ dot indicator, price+stock, title, description, "bouquet include" list, sticky Add-to-Cart | `getProductById(id)` | entity only | image-carousel widget, description/includes layout |

\* **Categories' and Occasions' tab rows are visually identical in Figma** (a horizontal list of selectable chips, one active with an underline). Recommend extracting one shared `common/widgets` chip-row component before either branch starts, so neither developer builds a competing version (see Risks).

**Product Details' relationship to the other four:** it receives a product id as a route argument from whichever screen the user tapped a card on. It has no outgoing dependency on Home/Categories/Best Seller/Occasions — it doesn't need to know who sent it. Its `getProductById(id)` call must work standalone (not just "whatever the caller already had"), so deep links / notifications can open it directly.

**Product Details' Add to Cart button** is a boundary with a feature outside this task's scope (`features/cart/`, currently an empty placeholder). Product Details should call a `cart` contract, never own cart state itself — and `cart` must never depend back on `product_details`.

---

## 4. Shared layer — what's centralized and why

| Shared thing | Why it must not be duplicated |
|---|---|
| `ProductEntity` / `CategoryEntity` / `OccasionEntity` | All 5 screens (plus Search, Cart, Orders later) render the exact same product concept. A per-feature copy immediately drifts — confirmed as the explicit reasoning already written into `ProductEntity`'s own doc comment. |
| `CatalogRepository` + its future remote data source/API/DTOs/mappers | One backend surface for categories/occasions/products/search. Four screens hitting four separate "repositories" means four dummy datasets to keep in sync — exactly the problem the architecture Figma calls out for Auth. |
| `ProductCard` | The single card component renders identically (image, name, price, strikethrough original price, discount badge, optional Add-to-Cart) across Home (compact), Categories/Best Seller/Occasions/Search (full) — one widget, driven by a nullable callback, not five copies. |
| `AppSectionHeader` | Home's three "Title + View All" rows are pixel-identical in Figma. |
| Loading/Error/Empty state widgets | Figma shows none of these states explicitly (typical design-file gap) — the app already has one canonical shared answer for each, so no feature should invent its own spinner/error layout. |
| Route names + registrations | The single seam between features. Features talk to each other only through `Get.toNamed(CustomerRoutes.x, arguments: ...)`, never through direct imports. |

---

## 5. Dependency diagram

Confirmed against the actual Figma navigation (View All / tap-through), not assumed:

```
                                   Home
                     (search entry • location • 3 preview
                      sections, each with "View All")
              ┌────────────┬────────────┬────────────┐
              ▼            ▼            ▼            ▼
         Categories   Best Seller   Occasions    (any product
              │             │            │        card, anywhere)
              └─────────────┼────────────┘             │
                             ▼                          │
                       Product Details ◄─────────────────┘
                             │
                             ▼
                   features/cart (out of scope,
                   not yet built — Add to Cart only)
```

- Home depends on **all four** other features only via navigation (route name + optional argument), never via import.
- Categories, Best Seller, Occasions are **siblings** — none depends on another.
- Product Details is the **single convergence point** — every product card everywhere routes to it. It has zero outgoing dependency on any of the other four.
- All five depend on `catalog` (shared domain) and `common/widgets` (shared UI). None of them may be depended on *by* `catalog` or `common` — that would invert the dependency direction the architecture Figma explicitly warns against ("shared core that features depend on," never the reverse).

---

## 6. Branch diagram

```
main
 └── develop
      └── commerce                     ← base branch, built once (mirrors "auth module")
           │   Contains (see Section 1 checklist):
           │   • features/commerce/shared/ (use cases added, DI registered)
           │   • core/domain/entities/{product,category,occasion}_entity.dart (already exist)
           │   • common/widgets/{product_card,app_section_header,states/*} (already exist)
           │   • customer_pages.dart — all 5 GetPage slots reserved (placeholder views OK)
           │
           ├── feat/commerce-home
           ├── feat/commerce-categories
           ├── feat/commerce-best-seller
           ├── feat/commerce-occasions
           └── feat/commerce-product-details
                    │
                    ▼  "Merge after PR approval" (code-reviewed, same as login/sign_up → auth module)
                 commerce
                    │
                    ▼  "PR without code review" (already reviewed feature-by-feature —
                    │   per the architecture board's own sticky note)
                 develop
```

**Workflow per developer**, exactly as specified:
```
git checkout commerce
git checkout -b feat/commerce-home
```
- **Gets from `commerce`**: finished `catalog` use cases + DI, all shared entities/widgets, and their own screen's route slot already reserved in `customer_pages.dart`.
- **Allowed to modify**: only their own `features/<feature>/` folder, plus a single one-line edit in `customer_pages.dart` to swap their reserved placeholder for the real view.
- **Must not duplicate**: `ProductEntity`/`CategoryEntity`/`OccasionEntity`, `CatalogRepository`/its use cases, `ProductCard`, `AppSectionHeader`, route name constants.
- **Treat as stable** (change only via a reviewed PR that every consumer signs off on): `catalog`'s repository interface, `ProductCard`, `AppSectionHeader`, the three shared entities.
- **Cross-branch dependency**: Product Details is the only feature with an implicit dependency on the other four (it must exist and accept a product-id argument before Home/Categories/Best Seller/Occasions can wire up their "tap card" navigation end-to-end) — see Implementation Order.

---

## 7. Implementation order

1. **Finish `catalog`'s use-case layer** — one `UseCase<T, Params>` per existing repository method. Small and mechanical; unblocks every feature Cubit from depending on use cases instead of the repository directly (also fixes `HomeCubit`'s current direct-repository-call inconsistency with Auth's own established pattern).
2. **Register `catalog` in DI** (`catalog_module.dart` → wired into `setupCustomerAppDependencies`). Nothing currently registers `CatalogRepository`/`CatalogLocalDataSource` — every feature Cubit will fail to resolve without this.
3. **Reserve all 5 route slots** in `customer_pages.dart` (placeholder views are fine — same approach already used for `/main`). This is the single most conflict-prone file; claiming all 5 lines once, upfront, on `commerce` avoids five developers editing the same file later.
4. **Extract the shared category/occasion tab-row widget** into `common/widgets/` before Categories or Occasions branches start (see Risks).
5. **Open the 5 feature branches.** Each developer builds their own `presentation/` layer only.
6. **Product Details should land its route + accept-a-product-id contract early** (even before its UI is finished), since Home/Categories/Best Seller/Occasions all need a real destination to navigate to in order to finish their own "tap card" flow.
7. **Cart integration on Product Details' Add-to-Cart button stays a stub/TODO** until `features/cart/` exists — explicitly out of this task's scope.

---

## 8. Risks

- **`customer_pages.dart` contention** — five developers each adding one `GetPage` entry to the same file. Mitigated by reserving all 5 slots on `commerce` before branching (step 3 above).
- **Duplicate tab-row widget** — Categories and Occasions need visually identical chip/tab rows; without an early shared extraction, two slightly different implementations will likely get built independently.
- **`ProductCard` / `AppSectionHeader` scope creep** — shared widgets used by all 5 screens; an uncoordinated tweak "just for my screen" breaks the other four. Treat as stable/frozen except via a PR every consumer reviews.
- **`CatalogRepositoryImpl` / `CatalogLocalDataSource` ownership** — one shared implementation file; the full method surface is already defined in the interface, so feature branches should only ever *call* existing methods, never add new ones mid-feature-branch (that belongs on `commerce`, reviewed once).
- **Entity drift** — `ProductEntity` already models discount/rating/stock/gallery/includes; a feature dev who feels a field is "missing" must extend the shared entity via a reviewed PR, not bolt on a feature-local model.
- **`ProductCard`'s dual role via `onAddToCart: null` vs set** — easy to get backwards (e.g. passing a callback on Home's compact preview cards, or omitting it in a full listing grid); worth a one-line convention note in the widget's own doc comment.
- **Search screen ambiguity** — `CatalogRepository.searchProducts()` and a full "Search" Figma screen already exist, but Search is **not** one of the 5 features in this task's scope. Left undocumented, a Commerce developer might build it anyway, assuming it's implied by Home's search bar. Must be explicitly flagged as unassigned/out-of-scope until a separate decision is made.
- **Cart dependency direction** — Product Details → `cart` (future), never the reverse.
- **No backend yet** — `catalog` only has a local/dummy data source today (unlike Auth, which now has a real backend). The architecture Figma's sketched `data/api/`, `data/models/`, `data/mappers/commerce_mapper.dart` are target future work, not blocking — `CatalogRepository`'s contract already abstracts local vs. remote, so UI work should not be blocked waiting for a real API.
- **Minor existing doc drift** — `CatalogRepository`'s own doc comment lists "Home, Categories, Product details and Search" as its consumers but omits Best Seller and Occasions, even though methods for both already exist. Worth a one-line fix whenever that file is next touched (not urgent, not part of this analysis's scope to change).

---

## 9. MVI / Clean Architecture placement

| Piece | Lives at | Owned by |
|---|---|---|
| Intent | `features/<feature>/presentation/intent/<feature>_intent.dart` (sealed) | each feature — only where more than one user action exists (e.g. Categories: `LoadCategories`, `SelectCategoryTab`, `ApplySort`; Home/Best Seller likely need only a single `Load...` call and may skip a formal Intent class, same as a simple screen would) |
| State | `features/<feature>/presentation/state/<feature>_state.dart` (sealed `Loading/Loaded/Error`, matching `HomeState`'s existing pattern) | each feature |
| Cubit | `features/<feature>/presentation/cubit/<feature>_cubit.dart` (extends `BaseCubit`) | each feature — calls **use cases only**, never `CatalogRepository` directly |
| Repository (contract) | `features/commerce/shared/domain/repositories/catalog_repository.dart` | shared — already exists, features never define their own |
| Repository implementation | `features/commerce/shared/data/repositories/catalog_repository_impl.dart` | shared — already exists |
| Remote Data Source | `features/commerce/shared/data/datasources/catalog_remote_data_source.dart` | shared — to add |
| API | `features/commerce/shared/data/api/catalog_api_service.dart` | shared — to add |
| DTO | `features/commerce/shared/data/models/*.dart` | shared — to add |
| Mapper | `features/commerce/shared/data/mappers/catalog_mapper.dart` | shared — to add |
| Entity | `core/domain/entities/{product,category,occasion}_entity.dart` | shared kernel — already exists |
| Use Case | `features/commerce/shared/domain/usecases/*.dart` | shared — to add, one per repository method |

**Dependency direction check:** `presentation (feature)` → `domain (catalog use cases/contract)` → `data (catalog impl → data sources)`. Features never import each other's Cubit/State/View/widgets — they converge only through navigation (route name + argument). Nothing in `catalog`, `core`, or `common` may import from any of the 5 feature folders — that would invert the "shared core that features depend on" rule the architecture Figma states explicitly.

---

## 10. Open items for review (not decided unilaterally in this document)

1. ~~Keep the shared module's folder name as `features/catalog/`, or rename/nest to `features/commerce/`?~~ **Resolved 2026-08-24:** nested — `features/commerce/shared/` + the 5 feature folders underneath, matching the `commerce` branch structure exactly. `home_cubit.dart`'s import and all other affected relative imports have been updated accordingly.
2. Confirm the shared tab-row widget extraction (Categories/Occasions) before those two branches open.
3. Confirm whether Product Details should accept a pre-fetched `ProductEntity` via route arguments (fast path) in addition to always supporting `getProductById(id)` (deep-link path), or only ever fetch by id.
4. Confirm Search stays explicitly unassigned/out of scope for this phase.
