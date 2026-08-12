FLOWERY — Codebase & Architecture Guide

> ملحوظة مهمة قبل ما نبدأ: المشروع فيه حاجات كتير لسه Scaffold بس (فولدرات فاضية فيها README فقط). في أي مكان الكود مش موجود، هقول كده صريح، مش هخترع منطق مش موجود.

---

## 1) نظرة عامة على المشروع

**Flowery** مشروع Flutter لتوصيل ورد (زي e-commerce app بس متخصص في الورد). المشروع عبارة عن **Monorepo** — يعني ريبو واحدة فيها أكتر من تطبيق (Apps) وأكتر من مكتبة مشتركة (Packages)، بدل ما كل تطبيق يبقى ليه ريبو لوحده.

**ليه Monorepo؟** لأن فيه تطبيقين بيشتركوا في نفس الـ Design System، ونفس الـ Base classes، ونفس بعض الـ Entities (زي `UserEntity`). لو كل تطبيق في ريبو لوحده كنا هنكرر الكود ده مرتين ونصعب المزامنة بينهم.

**ليه تطبيقين؟**
- **Customer App** (`apps/customer_app`): تطبيق العميل اللي بيتصفح الورد ويشتري (Login, Sign up, هيكون فيه Catalog, Cart, Checkout...).
- **Rider App** (`apps/rider_app`): تطبيق المندوب اللي بيوصل الطلبات (Onboarding, Apply, Delivery...) — **دلوقتي Skeleton بس، مفيش فيه أي فيتشر شغال**.

**اللي مشترك بينهم:** الـ 4 packages (`core`, `common`, `design_system`, `shared`) — كل تطبيق بيعتمد عليهم عن طريق `path:` dependency في الـ `pubspec.yaml` بتاعه.

```text
                    FLOWERY MONOREPO
                           │
              ┌────────────┴────────────┐
              │                         │
        Customer App                Rider App
              │                         │
        E-commerce                 Delivery
        (شغال: Auth)              (Skeleton بس)
              │                         │
              └────────────┬────────────┘
                           │
                    Shared Packages
                           │
          ┌────────┬───────┼───────┐
          │        │       │       │
        Core    Common   Design  Shared
                         System
```

- **Core**: البنية التحتية التقنية (DI, Network contract, Result/Failure, Base Cubit, Storage contract) — مفيهاش UI ولا Business logic.
- **Common**: Widgets عامة قابلة لإعادة الاستخدام (زرار، تكست فيلد، Dialog...) — مفيهاش نص Hardcoded خاص بفيتشر معين.
- **Design System**: الألوان، المسافات، الخطوط، الـ Theme — مستخرجة من Figma.
- **Shared**: Entities مشتركة فعليًا بين التطبيقين، دلوقتي بس `UserEntity` و `AddressEntity`.

---

## 2) هيكل الفولدرات

```text
flower_app/
├── apps/
│   ├── customer_app/
│   │   ├── lib/
│   │   │   ├── features/      ← كل فيتشر ليه presentation/domain/data
│   │   │   ├── core/domain/entities/  ← entities خاصة بالـ app ده بس
│   │   │   ├── constants/     ← AppStrings, AppAssets, AppAnimations
│   │   │   ├── di/            ← composition root بتاع GetIt
│   │   │   ├── routing/       ← GetX routes/pages
│   │   │   ├── common/widgets/ ← widgets خاصة بالـ app بس (زي ProductCard)
│   │   │   ├── app.dart
│   │   │   └── main.dart
│   │   └── assets/ (images, icons, translations, animations)
│   └── rider_app/
│       ├── lib/ (نفس الهيكل، بس المعظم فاضي)
│       └── assets/
├── packages/
│   ├── core/, common/, design_system/, shared/
└── docs/
```

**قاعدة مهمة:** جوه `features/<feature>/` المفروض تلاقي `presentation/` (View + Cubit + State) و `domain/` (Repository interface + Entities لو خاصة) و `data/` (Repository impl + DataSource). ملحوظش تحط Business logic جوه `common/` أو `design_system/` — دول للـ UI/tokens العامة بس.

---

## 3+4+5) الفايلات والكلاسات والفنكشنز

الريبو فيها حوالي **74 ملف Dart فعلي** (مش عد الـ generated/build). تفصيل كل ملف وكل كلاس وكل فنكشن هنا هياخد أكتر بكتير من 4 صفحات، فأنا هعمل **جدول مكثف لكل حاجة**، وهحجز الشرح الكامل ملف-بملف وكلاس-بكلاس وفنكشن-بفنكشن لفيتشر **Login** في قسم 20 (هو المطلوب يكون "المثال اللي يشرح المعمارية كلها").

### أهم الكلاسات في `core`

| الكلاس | الملف | بيعمل إيه |
|---|---|---|
| `BaseCubit<State>` | `base/base_cubit.dart` | كل الـ Cubits بترث منه؛ فيه `safeEmit()` بس اللي بتعمل emit لو الـ Cubit لسه مش `closed` (حماية من crash). |
| `Result<T>` (sealed) | `result/result.dart` | `Success<T>` أو `ResultFailure<T>`؛ فيه `fold()` بياخد دالتين (للـ failure وللـ success). |
| `Failure` (sealed) | `error/failures.dart` | `NetworkFailure, ServerFailure, ValidationFailure, NotFoundFailure, AuthFailure, UnexpectedFailure`. |
| `ServerException/CacheException/NetworkException` | `error/exceptions.dart` | استثناءات بترمى من الـ DataSource بس، والـ Repository بيمسكها. |
| `ApiClient` (interface) + `UnimplementedApiClient` | `network/api_client.dart` | **مفيش HTTP client حقيقي** — أي method بترمي Exception. تفصيل في قسم 9. |
| `LocalStorageService` (interface) + `InMemoryLocalStorageService` | `storage/local_storage_service.dart` | تخزين مؤقت في `Map` في الـ memory، مش بيفضل بعد إغلاق الـ app. |
| `Validators` | `utils/validators.dart` | `email, password, confirmPassword, required, phone` — كل واحدة بترجع `String?` (null = valid). |
| `sl` (GetIt instance) + `setupCoreDependencies()` | `di/injector.dart` | تفصيل في قسم 8. |

### أهم الـ Widgets في `common`

| الـ Widget | بيحل مشكلة إيه | Params أهم |
|---|---|---|
| `PrimaryButton` | زرار Pill مليان بلون الـ primary، فيه Loading state جاهزة | `label, onPressed, isLoading, icon` |
| `SecondaryButton` | زرار Outlined | `label, onPressed` |
| `AppTextField` | تكست فيلد بالـ Label فوق الفيلد | `label, hint, controller, validator, ...` |
| `AppOutlinedTextField` | تكست فيلد بنمط M3 (اللابل جوه البوردر) — مستخدم في Sign Up بس | نفس بارامترات `AppTextField` تقريبًا |
| `AppBackAppBar` | AppBar موحد فيه زرار رجوع | `title, actions, onBackTap` |
| `ConfirmDialog` + `showConfirmDialog()` | Dialog تأكيد عام (زي Logout) | `title, message, confirmLabel, cancelLabel` |
| `LoadingView / ErrorView / EmptyState` | الحالات التلاتة القياسية لأي شاشة List/Data | `message`, وفي `ErrorView` كمان `onRetry` |
| `QuantityStepper` | زرار +/- للكمية في الكارت | `quantity, onIncrement, onDecrement` |
| `AppImagePlaceholder` | بديل مؤقت للصور لحد ما نربط API حقيقي للصور | `icon, size` |
| `CapitalizeFirstLetterFormatter` | `TextInputFormatter` بيخلي أول حرف كابيتال وانت بتكتب | مفيش params (formatter بس) |

**ليه دول في `common` مش جوه الفيتشر؟** لأنهم عامين ومفيهمش أي نص أو منطق خاص بفيتشر معين — أي فيتشر جديد ممكن يستخدمهم من غير ما يكرر كود.

---

## 6) Clean Architecture

```text
Presentation  →  View + Cubit + State
     │
     ↓
  Domain      →  Entity + Repository (interface)
     │
     ↓
   Data       →  Model/Entity + Repository (impl) + DataSource
     │
     ↓
 API / Local Storage
```

- **Presentation**: الـ `View` (Widget) بتعرض الـ `State` وبس، مبتكلمش الـ Repository مباشرة. الـ `Cubit` هو اللي بياخد قرارات ويكلم الـ Domain.
- **Domain**: `Repository` هنا Interface بس (`abstract interface class`) — مفيهوش أي تفاصيل عن إزاي البيانات بتيجي (API ولا Local). الـ Entities هنا Pure Dart، مفيهاش أي حاجة Flutter.
- **Data**: `RepositoryImpl` بيـ implement الـ interface، وبيكلم `DataSource` (اللي فيه التفاصيل الفعلية — API call أو In-memory mock).

**ليه الاتجاه ده بالذات؟** عشان الـ Presentation والـ Domain **مايعرفوش** حاجة عن التفاصيل التقنية (HTTP, Local DB...). لو حبينا نبدل من In-memory mock لـ API حقيقي، بنغير `AuthRepositoryImpl` وبس — الـ `LoginCubit` والـ `LoginView` مش هيتلمسوا خالص. ده اللي حصل فعليًا في المشروع: كل الـ Repositories دلوقتي مبنية على DataSources محلية (mock)، والـ Interfaces جاهزة عشان تستبدلها بـ API حقيقي براحتك.

---

## 7) MVI Flow (زي ما هو متطبق فعليًا)

```text
   USER (يدوس Login)
         │
         ↓
     LoginView          ← بس widget، بيعرض الـ state
         │  (بينادي method في الـ Cubit مباشرة، مفيش Intent class منفصل)
         ↓
     LoginCubit.login()  ← ده هو الـ "Intent" فعليًا في المشروع ده
         │
         ↓
   safeEmit(LoginSubmitting())
         │
         ↓
   AuthRepository.login()  (Domain interface)
         │
         ↓
   AuthRepositoryImpl.login()  (Data)
         │
         ↓
   AuthLocalDataSource.login()  (Mock/Local)
         │
         ↓
      Result<UserEntity>
         │
         ↓
   result.fold(failure → LoginFailed, success → LoginSuccess)
         │
         ↓
     LoginState (sealed class)
         │
         ↓
     LoginView (BlocConsumer بيعمل rebuild)
```

**الفرق بين الأربعة (من الكود الفعلي، مش نظري):**
- **View**: `StatefulWidget`، بيمسك الـ `TextEditingController`s والـ `Form` والـ Validation المحلية، وبيستخدم `BlocConsumer` عشان يسمع للـ Cubit.
- **Intent**: **مفيش كلاس اسمه Intent في المشروع** — الـ Public methods بتاعت الـ Cubit (زي `login()`, `continueAsGuest()`) هي نفسها الـ Intent. دي حاجة مهمة تعرفها عشان متدورش على فولدر `intent/` مش هتلاقيه.
- **Cubit**: بيرث من `BaseCubit<State>`، مسؤول عن الـ orchestration بس — بينادي الـ Repository، مايعملش أي validation أو business logic جواه.
- **State**: `sealed class` فيها كل الحالات الممكنة (`Initial, Submitting, Success, Failed`) — دي الـ "Model" في MVI.

---

## 8) Dependency Injection (GetIt)

```text
main.dart
   │
   ↓ setupCustomerAppDependencies()
   │
   ├── setupCoreDependencies()   (من core/di/injector.dart)
   │       ├── registerLazySingleton<NetworkInfo>(AlwaysOnlineNetworkInfo.new)
   │       ├── registerLazySingleton<ApiClient>(UnimplementedApiClient.new)
   │       └── registerLazySingleton<LocalStorageService>(InMemoryLocalStorageService.new)
   │
   └── setupAuthDependencies()   (من customer_app/di/auth_injector.dart)
           ├── registerLazySingleton<AuthLocalDataSource>(...)
           ├── registerLazySingleton<AuthRepository>(...)
           ├── registerFactory<LoginCubit>(...)
           ├── registerFactory<SignUpCubit>(...)
           ├── registerFactory<ForgotPasswordCubit>(...)
           └── registerFactory<ResetPasswordCubit>(...)
```

- **`sl` = `GetIt.instance`** — تعريفه في `packages/core/lib/di/injector.dart`، واحد بس لكل الـ app (Global service locator).
- **`registerLazySingleton`**: بيعمل instance واحدة بس أول مرة حد يطلبها، وبعدين بيرجعلك نفسها كل مرة — مستخدمة للـ Repositories والـ DataSources لأنهم مفيهمش حالة بتتغير لكل شاشة.
- **`registerFactory`**: بيعمل instance **جديدة كل مرة** — مستخدمة للـ Cubits لأن كل شاشة محتاجة نسخة لوحدها من الـ Cubit بحالتها الخاصة.
- **ليه بنسجل Interface مش Implementation؟** `registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(...))` — يعني لما أي حد يطلب `sl<AuthRepository>()` هيرجعله الـ implementation، بس هو مش عارف ولا محتاج يعرف إن اللي وراه `AuthRepositoryImpl`. لو غيرناها بكرة لـ `AuthRepositoryRemoteImpl` — كل حاجة تانية في الكود مش هتتغير.
- **الوصول للـ Cubit**: في الـ Routing (`customer_pages.dart`) بيتلف بـ `BlocProvider(create: (_) => sl<LoginCubit>(), child: LoginView())`.
- **المسجل دلوقتي**: بس Core + Auth. **مفيش تسجيل لـ Catalog ولا Home** — `CatalogRepository` و`HomeCubit` موجودين في الكود بس مش متسجلين في أي Injector، يعني `sl<HomeCubit>()` هيرمي Exception لو حد نادى عليها دلوقتي.

---

## 9) API Flow — **مهم جدًا: الـ API مش متوصل حاليًا**

```text
Cubit → Repository Interface → Repository Implementation → DataSource → (لازم API لكن مفيش) → ApiClient
```

- **`ApiClient`** (في `core/network/api_client.dart`) عبارة عن Interface بس (`get/post/put/delete`)، والـ implementation الوحيدة الموجودة هي **`UnimplementedApiClient`** — أي method فيها بترمي `ServerException('No ApiClient implementation is registered yet...')`.
- **`ApiEndpoints`** فيه بس `baseUrl` و`timeouts` — **مفيش أي endpoint path متسجل فعليًا**.
- **Auth و Catalog حاليًا شغالين على DataSources محلية (Mock)** مش API حقيقي:
  - `AuthLocalDataSourceImpl.login()`: بيتأخر `600ms` (`Future.delayed`)، وبيقارن الـ email/password بقيم Hardcoded (`test@flowery.com` / `Password123`) — لو مطابقين بيرجع `UserEntity` ثابتة اسمها "Nour Mohamed".
  - `CatalogLocalDataSourceImpl`: نفس الفكرة، فيه Lists ثابتة لـ Categories/Occasions/Products (10 منتجات، كلهم `imageUrl: ''`)، وبيتأخر `500ms`.
- **الخلاصة**: مفيش أي endpoint حقيقي اتعمله call، ومش هخترع أسماء endpoints مش موجودة في الكود.

---

## 10) Error Handling

```text
DataSource → throw ServerException (زي "Invalid email or password")
      ↓
Repository → try/catch → Result.failure(AuthFailure(e.message))
      ↓
Cubit → result.fold(failure → safeEmit(LoginFailed(failure.message)))
      ↓
LoginState.LoginFailed(message)
      ↓
View → BlocConsumer.listener → context.showSnackBar(state.message)
```

كل الـ Repositories بتعمل نفس الـ pattern: `try { ... } on ServerException catch (e) { return Result.failure(AuthFailure(e.message)); } catch (_) { return Result.failure(UnexpectedFailure()); }`. يعني أي error متوقع بيترجم لرسالة واضحة، وأي error مش متوقع بيترجم لـ `UnexpectedFailure` عشان الـ UI ميتعلقش.

---

## 11) Localization

```text
en.json / ar.json  (في assets/translations/)
        ↓
'key'.tr()   (من easy_localization)
        ↓
AppStrings.xxx   (getter بيلف الـ .tr())
        ↓
UI (زي Text(AppStrings.login))
```

- الـ locales المدعومة: **English + Arabic** (fallback: English) — متسجلين في `main.dart` عن طريق `EasyLocalization(supportedLocales: [en, ar], ...)`.
- **RTL/LTR**: بيتظبط أوتوماتيك من `easy_localization` بناءً على الـ locale، مفيش كود يدوي بيعمل flip للـ Direction.
- **مشكلة موجودة فعليًا**: مفتاح `enterYourEmail` في `en.json` قيمته `"Enter you email"` (فيها Typo — ناقص "r")، ونفس الـ Typo موجود في الـ Login hint. اتصلح خصيصًا لشاشة الـ Sign Up بس (مفاتيح جديدة زي `signUpEmailHint`)، لكن Login لسه فيه الـ Typo القديم.

---

## 12) Design System

| الملف | بيتحكم في إيه |
|---|---|
| `AppColors` | كل الألوان (`primary=#D21E6A, background=#F9F9F9, gray=#535353, error=#CC1010, ...`) |
| `AppDimens` | المسافات (`space4→space48`) والـ radius (`radiusExtraSmall=4 → radiusPill=100`) وأحجام مكونات (`buttonHeight=48, inputHeight=56`) |
| `AppTextStyles` | كل الـ Text styles (خط Inter عن طريق `google_fonts`) — `displayLarge, titleMedium, bodySmall, link, ...` |
| `AppTheme.light` | بيجمع كل اللي فوق في `ThemeData` واحدة بتتحط في `MaterialApp.theme` |
| `AppAssets` | مسارات اللوجو والأيقونة البراند بس (كل app ليه `AppAssets` تاني لصوره هو) |

**ليه ماينفعش تكتب `Color(0xFF...)` أو `fontSize: 18` جوه شاشة؟** لأن ده بيكسر الـ Single Source of Truth — لو الـ Design تغير لون الـ primary بكرة، هتدور على كل مكان استخدمته يدويًا بدل ما تغير قيمة واحدة في `AppColors`. كمان بيبوظ التناسق بين الشاشات المختلفة.

---

## 13-14) Common & Shared Packages

اتغطوا بالتفصيل في قسم 3 (الـ widgets) — الجدول فوق فيه كل الـ widgets المهمة.

**Shared package**: فيه `UserEntity` (id, firstName, lastName, email, phoneNumber?, avatarUrl?, gender, isGuest) و`AddressEntity` (id, label, city, details, recipientName?, phoneNumber?, area?, isDefault). دول مشتركين لأن **الاتنين التطبيقين بيتعاملوا مع Users وAddresses** (العميل بيسجل دخول، والمندوب برضو بيسجل دخول ويشوف عنوان التوصيل).

**ليه Product/Cart/Order متتنقلش لـ `shared`؟** لأن دول خاصين بالـ Customer app بس دلوقتي — الـ Rider app لسه مالوش أي Cart أو Product. لو نقلناهم دلوقتي هنجر معاهم كل الـ Catalog domain لباكدج المندوب مايحتاجهاش. القاعدة: تحط حاجة في `shared` لما تبقى **فعلاً** مستخدمة في الاتنين، مش لمجرد إنها تشبه بعض.

---

## 15) Customer App — الفيتشرز

| الفيتشر | الحالة | التفاصيل |
|---|---|---|
| **Auth** | ✅ شغال بالكامل (بس على بيانات محلية) | Login, Sign up, Forgot password, OTP verification (بدون منطق تحقق حقيقي — أي 4 أرقام بتعدي)، Reset password. كله متسجل في DI والـ Routing. |
| **Catalog** | ⚠️ Data + Domain بس | الـ Repository والـ DataSource موجودين وشغالين (بيانات ثابتة)، **بس مفيش View ولا Cubit ولا حتى تسجيل في DI**. |
| **Home** | ⚠️ Cubit بس، مش متوصل | `HomeCubit`/`HomeState` موجودين ومكتوبين كويس، بس **مفيش View خالص**، ومش متسجل في أي DI، فهو "ميت" — مش بيتنفذ في الـ app فعليًا. |
| **Splash** | ⚠️ مبني بس مش متوصل | `SplashView` كاملة وشغالة (بتستنى 1.2 ثانية وتروح للـ Login)، بس **مش متسجلة في `customer_pages.dart`** والـ app بيبدأ من `CustomerRoutes.login` مباشرة مش من الـ Splash. |
| **Cart, Checkout, Orders, Notifications, Profile** | ❌ Scaffold بس | كل فولدر فيه ملف `README.md` بس بيقول "Not yet implemented" — **صفر ملفات Dart**. الـ Entities بتاعتهم (`CartItemEntity`, `OrderEntity`, `NotificationEntity`) اتعملت في `core/domain/entities/` استعدادًا بس. |

**رسم لفيتشر Auth (الوحيد الكامل فعليًا):**
```text
Auth
│
├── Login              ✅ View + Cubit + State + Repository + DataSource
├── Sign Up            ✅ نفس الهيكل
├── Forgot Password    ✅ نفس الهيكل
├── OTP Verification   ⚠️ View بس، مفيش Cubit (شاشة ثابتة)
└── Reset Password     ✅ نفس الهيكل
```

---

## 16) Rider App

**كل الفيتشرز = Planned / لسه ماتبداش.** الفولدرات موجودة (`onboarding, auth, apply, home, delivery, orders, profile`) لكن كل واحدة فيها `README.md` بنفس النص بالظبط: *"Not yet implemented... No screens, Cubits, or business logic exist here yet."* — صفر كود.

اللي شغال فعليًا في الـ Rider app: `main.dart` (بيعمل `setupRiderAppDependencies()` اللي بينادي `setupCoreDependencies()` بس)، و`RiderApp` widget (بتفتح على `RiderFoundationPreviewScreen` مش على شاشة حقيقية)، و`RiderRoutes` (أسماء Routes معرّفة بس)، و`RiderPages.pages` اللي هي **List فاضية تمامًا**.

| الفيتشر | الحالة |
|---|---|
| Onboarding, Auth, Apply, Home, Delivery, Orders, Profile | ❌ Planned — README بس |

---

## 17) Routing

```text
main.dart → runApp(FlowerApp) → GetMaterialApp(getPages: CustomerPages.pages, initialRoute: CustomerRoutes.login)
```

**Customer App — الـ Routes المسجلة فعليًا في `customer_pages.dart`:**

| Route name | بتوصل لإيه |
|---|---|
| `/login` | `LoginView` (جوه `BlocProvider<LoginCubit>`) |
| `/sign-up` | `SignUpView` |
| `/forgot-password` | `ForgotPasswordView` |
| `/otp-verification` | `OtpVerificationView` (من غير BlocProvider) |
| `/reset-password` | `ResetPasswordView` |

**مشكلة موجودة**: `CustomerRoutes.main` (الوجهة بعد نجاح تسجيل الدخول، عن طريق `Get.offAllNamed(CustomerRoutes.main)`) **مالهاش `GetPage` متسجل خالص** — يعني لو حد سجل دخول فعلًا دلوقتي، الـ navigation هتفشل لأن مفيش شاشة على الـ route ده. كل باقي الـ Routes في `CustomerRoutes` (categories, cart, checkout, orders...) معرّفة كـ Strings بس بدون `GetPage`.

**Rider App**: `RiderRoutes` فيها كل الأسماء المتوقعة، بس `RiderPages.pages` فاضية تمامًا.

---

## 18) Assets

```text
design_system/assets/   → لوجو + أيقونة براند + خطوط (Inter, Outfit, Roboto, IMFellEnglish)
customer_app/assets/    → images (14) + icons (46) + translations (en/ar) + animations (3, لسه مش متربطة بأي widget)
rider_app/assets/       → images/ فيها README بس، مفيش صور حقيقية
```

كل app بيسجل الـ assets بتاعته في `pubspec.yaml` تحت `flutter: assets:`. الـ `design_system` هو الوحيد اللي بيسجل `fonts:`.

---

## 19) Architecture Rules (حدود الاعتماد بين الأجزاء)

```text
customer_app ──┐
               ├──→ packages/* (core, common, design_system, shared)
rider_app ─────┘

packages/*   ❌ ماينفعش يعتمد على customer_app أو rider_app
customer_app ❌ ماينفعش يعتمد على rider_app
rider_app    ❌ ماينفعش يعتمد على customer_app
```

اتأكدت من الـ `pubspec.yaml` بتاع كل package — كل الـ 4 packages بتعتمد على Flutter/packages تانية بس، **مفيش ولا واحدة فيهم بتعمل `path: ../../apps/...`**. ده بيضمن إن أي package تقدر تتبني لوحدها وتتستخدم من أي app من غير ما تجر معاها كود خاص بـ app تاني.

**ليه القاعدة دي مهمة؟** لو `common` عملت import لحاجة من `customer_app`، بقى الـ `rider_app` مجبور ياخد كود مالوش لازمة بيه، وبيبقى فيه Circular dependency logic خطر.

---

## 20) مثال كامل: فيتشر Login من الأول للآخر

```text
User يدوس "Login"
      ↓
LoginView._submit()
      ↓
LoginCubit.login(email, password)
      ↓
AuthRepository.login()  (interface)
      ↓
AuthRepositoryImpl.login()  (impl)
      ↓
AuthLocalDataSource.login()  (mock, delay 600ms)
      ↓
Result<UserEntity>
      ↓
LoginCubit: result.fold(...)
      ↓
LoginState (Success/Failed)
      ↓
LoginView (BlocConsumer rebuild)
```

### الملفات والكلاسات بالتفصيل

**`login_view.dart` → `LoginView` (StatefulWidget)**
- بتمسك `_emailController, _passwordController, _rememberMe (ValueNotifier<bool>)`.
- `_validateEmail()/_validatePassword()`: بتنادي `Validators.email/password` من `core`، ولو فيه error بترجع رسالة من `AppStrings` (مترجمة).
- `_submit()`: لو `_formKey.currentState.validate()` نجح، بينادي `context.read<LoginCubit>().login(email, password)`.
- الـ `BlocConsumer<LoginCubit, LoginState>`: في الـ `listener` — لو `LoginSuccess` يروح `CustomerRoutes.main` (Get.offAllNamed)، لو `LoginFailed` يعرض SnackBar. في الـ `builder` — بيقفل الفورم ويعرض Spinner لو `LoginSubmitting`.

**`login_cubit.dart` → `LoginCubit extends BaseCubit<LoginState>`**
- Constructor: `LoginCubit(this._authRepository) : super(const LoginInitial())`.
- `login({email, password})`: `safeEmit(LoginSubmitting())` → `await _authRepository.login(...)` → `result.fold(failure → LoginFailed(failure.message), user → LoginSuccess(user))`.
- `continueAsGuest()`: نفس الـ pattern، بينادي `_authRepository.continueAsGuest()`.
- **مفيهاش أي Validation جواها** — دي مسؤولية الـ View + Validators بس.

**`login_state.dart` → `LoginState` (sealed)**
- `LoginInitial, LoginSubmitting, LoginSuccess(UserEntity user), LoginFailed(String message)` — كلهم `Equatable`.

**`auth_repository.dart` → `AuthRepository` (abstract interface)**
- `login()`, `signUp()`, `continueAsGuest()`, `sendPasswordResetEmail()`, `resetPassword()` — كلهم بيرجعوا `Result<T>`.

**`auth_repository_impl.dart` → `AuthRepositoryImpl implements AuthRepository`**
- `login()`: `try { user = await _dataSource.login(...); await _localStorageService.setString('auth_access_token', 'placeholder-access-token-${user.id}'); return Result.success(user); } on ServerException catch (e) { return Result.failure(AuthFailure(e.message)); }`.
- ملحوظة: الـ Token المخزن **مش JWT حقيقي**، مجرد String ثابت شكله `placeholder-access-token-user-1`.

**`auth_local_data_source.dart` → `AuthLocalDataSourceImpl implements AuthLocalDataSource`**
- `login()`: `await Future.delayed(600ms)` → لو الـ email/password متطابقين مع `test@flowery.com` / `Password123` يرجع `UserEntity` ثابتة (Nour Mohamed) — غير كده يرمي `ServerException('Invalid email or password')`.

**DI (`auth_injector.dart`)**: `registerLazySingleton<AuthLocalDataSource>`, `registerLazySingleton<AuthRepository>`, `registerFactory<LoginCubit>`.

**Routing (`customer_pages.dart`)**: `GetPage(name: '/login', page: () => BlocProvider(create: (_) => sl<LoginCubit>(), child: LoginView()))`.

---

## Quick Mental Model

```text
                         FLOWERY
                            │
              ┌─────────────┴─────────────┐
              │                           │
        Customer App                 Rider App
        (Auth شغال,                  (Skeleton
      باقي Scaffold)                  بس، مفيش
              │                       فيتشرز)
              └─────────────┬─────────────┘
                            │
                     Shared Packages
                            │
        ┌───────────┬───────┼────────┐
        │           │       │        │
       Core       Common  Design   Shared
                         System
                            │
                            ↓
                     Clean Architecture
                            │
                            ↓
                          MVI
              (Cubit method = Intent, مفيش كلاس Intent منفصل)
                            │
                            ↓
                 View → Cubit → Domain
                            │
                            ↓
                     Repository (interface → impl)
                            │
                            ↓
                    Data Source (محلي/Mock دلوقتي، مش API حقيقي)
                            │
                            ↓
                     API (لسه مش متوصلة — ApiClient = Unimplemented)
```

**خلاصة نهائية لو نسيت كل حاجة وعايز تفتكر نقطة واحدة بس**: المعمارية جاهزة ونضيفة ومتبعة Clean Architecture + MVI صح، بس **فيتشر Auth بس هو الكامل فعليًا** — كل حاجة تانية إما Scaffold (فولدر + README) أو Data-layer-بس-من-غير-UI (Catalog, Home). ولما تيجي تبني API حقيقي، هتلاقي كل حاجة جاهزة تستقبله من غير ما تغير حرف في الـ Cubits أو الـ Views.
