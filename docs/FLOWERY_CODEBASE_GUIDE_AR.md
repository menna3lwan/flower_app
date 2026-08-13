FLOWERY — Codebase & Architecture Guide

> ملحوظة مهمة قبل ما نبدأ: المشروع فيه حاجات كتير لسه Scaffold بس (فولدرات فاضية فيها README فقط). في أي مكان الكود مش موجود، هقول كده صريح، مش هخترع منطق مش موجود.
>
> **تحديث مهم (تاريخي)**: الريبو ده كان فيه تطبيقين (Customer + Rider) في مرحلة سابقة، وبعدين اتعمله Refactor عشان يبقى تطبيق E-commerce واحد بس لكن لسه Monorepo (`apps/customer_app` + `packages/{core,common,design_system}`). بعد كده اتعمله Refactor تاني وأخير: اتشال الـ Monorepo layer خالص — الريبو دلوقتي **مشروع Flutter عادي واحد بس**، مفيهوش `apps/` ولا `packages/`. كل حاجة كانت في الـ 3 packages اتنقلت جوه `lib/core/` و `lib/common/`. الجايد ده بيوصف الحالة الحالية بعد الـ Refactor الأخير ده.

---

## 1) نظرة عامة على المشروع

**Flowery** مشروع Flutter لتوصيل ورد (زي e-commerce app بس متخصص في الورد). المشروع عبارة عن **مشروع Flutter عادي واحد** — مفيش Monorepo، مفيش `apps/`، مفيش packages منفصلة. الريبو نفسه هو الـ App.

**ليه اتشال الـ Monorepo؟** لأن الهدف بقى صريح: تطبيق E-commerce واحد بس، من غير خطة حقيقية لتطبيق تاني في المستقبل. إبقاء `core`/`common`/`design_system` كـ packages منفصلة كان بيضيف overhead (كل واحد ليه `pubspec.yaml` و`path:` dependency و`.dart_tool` خاص بيه) من غير فايدة حقيقية طالما فيه مستهلك واحد بس. الحدود المعمارية (UI لا تعرف Data، إلخ) اتحافظ عليها بالـ **فولدرات** (`lib/core/`, `lib/common/`, `lib/features/`) بدل الـ **packages**.

```text
                       FLOWERY (App واحد)
                             │
              ┌──────────────┼──────────────┐
              │              │              │
            core/          common/       features/
      (DI, Network,    (Widgets عامة:    (كل فيتشر:
       Result/Failure,  زرار، تكست       presentation/
       Base Cubit,      فيلد، Dialog)     domain/data)
       Theme, Routing,
       Entities...)
```

- **`lib/core/`**: البنية التحتية التقنية + الـ Design System (DI, Network contract, Result/Failure, Base Cubit, Storage contract, Theme/Colors/Dimens, Routing, Entities المشتركة) — مفيهاش Business logic خاص بفيتشر معين.
- **`lib/common/`**: Widgets عامة قابلة لإعادة الاستخدام (زرار، تكست فيلد، Dialog...) — مفيهاش نص Hardcoded خاص بفيتشر معين.
- **`lib/features/`**: كل فيتشر (Auth, Home, Catalog...) بمعماريته الكاملة (presentation/domain/data).

---

## 2) هيكل الفولدرات

```text
flower_app/
├── android/, ios/
├── assets/ (images, icons, fonts, translations, animations)
├── lib/
│   ├── core/
│   │   ├── base/            ← BaseCubit
│   │   ├── constants/       ← AppAssets, AppAnimations, AppColors, AppDimens
│   │   ├── theme/           ← AppTextStyles, AppTheme
│   │   ├── localization/    ← AppStrings
│   │   ├── network/         ← ApiClient, ApiEndpoints, NetworkInfo
│   │   ├── storage/         ← LocalStorageService
│   │   ├── routing/         ← GetX routes/pages
│   │   ├── di/              ← composition root بتاع GetIt
│   │   ├── error/           ← Failure/Exception types
│   │   ├── result/          ← Result<Success|Failure>
│   │   ├── extensions/, usecase/, utils/
│   │   └── domain/entities/ ← entities مشتركة بين الفيتشرز (User, Address, Cart, Order...)
│   ├── common/
│   │   ├── widgets/         ← زرار، تكست فيلد، Dialog، Loading/Error/Empty states
│   │   ├── dialogs/, extensions/, formatters/
│   ├── features/            ← كل فيتشر ليه presentation/domain/data
│   ├── app.dart
│   └── main.dart
├── test/
└── docs/
```

**قاعدة مهمة:** جوه `features/<feature>/` المفروض تلاقي `presentation/` (View + Cubit + Intent + State) و `domain/` (Repository interface + Entities لو خاصة) و `data/` (Repository impl + DataSource). ملحوظش تحط Business logic جوه `common/` أو `core/theme` — دول للـ UI/tokens العامة بس.

---

## 3+4+5) الفايلات والكلاسات والفنكشنز

تفصيل كل ملف وكل كلاس وكل فنكشن هنا هياخد أكتر بكتير من 4 صفحات، فأنا هعمل **جدول مكثف لكل حاجة**، وهحجز الشرح الكامل ملف-بملف وكلاس-بكلاس وفنكشن-بفنكشن لفيتشر **Auth** في قسم 20 (هو المطلوب يكون "المثال اللي يشرح المعمارية كلها").

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
| `AppTextField` | تكست فيلد بالـ Label فوق الفيلد | `label, hint, controller, validator, inputFormatters, ...` |
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
Presentation  →  View + Cubit + Intent + State
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

- **Presentation**: الـ `View` (Widget) بتعرض الـ `State` وبس وبتـ dispatch `Intent`s، مبتكلمش الـ Repository مباشرة. الـ `Cubit` هو اللي بياخد قرارات ويكلم الـ Domain.
- **Domain**: `Repository` هنا Interface بس (`abstract interface class`) — مفيهوش أي تفاصيل عن إزاي البيانات بتيجي (API ولا Local). الـ Entities هنا Pure Dart، مفيهاش أي حاجة Flutter.
- **Data**: `RepositoryImpl` بيـ implement الـ interface، وبيكلم `DataSource` (اللي فيه التفاصيل الفعلية — API call أو In-memory mock).

**ليه الاتجاه ده بالذات؟** عشان الـ Presentation والـ Domain **مايعرفوش** حاجة عن التفاصيل التقنية (HTTP, Local DB...). لو حبينا نبدل من In-memory mock لـ API حقيقي، بنغير `AuthRepositoryImpl` وبس — الـ `AuthCubit` والـ Views مش هيتلمسوا خالص. ده اللي حصل فعليًا في المشروع: كل الـ Repositories دلوقتي مبنية على DataSources محلية (mock)، والـ Interfaces جاهزة عشان تستبدلها بـ API حقيقي براحتك.

---

## 7) MVI Flow (زي ما هو متطبق فعليًا)

```text
   USER (يدوس Login)
         │
         ↓
     LoginView          ← بس widget، بيعرض الـ state وبيـ dispatch الـ Intent
         │
         ↓
   LoginRequested (AuthIntent — sealed class حقيقية)
         │
         ↓
   AuthCubit.onIntent(intent)  ← switch expression بيوزع الـ Intent على الـ handler المناسب
         │
         ↓
   safeEmit(AuthLoading())
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
   result.fold(failure → AuthFailed, success → AuthLoginSuccess)
         │
         ↓
     AuthState (sealed class)
         │
         ↓
     LoginView (BlocConsumer بيعمل rebuild)
```

**الفرق بين الأربعة (من الكود الفعلي):**
- **View**: `StatefulWidget`، بيمسك الـ `TextEditingController`s والـ `Form` والـ Validation المحلية، وبيستخدم `BlocConsumer` عشان يسمع للـ Cubit، وبيـ dispatch `Intent` عن طريق `context.read<AuthCubit>().onIntent(...)`.
- **Intent**: `AuthIntent` — sealed class فعلية في `presentation/intent/auth_intent.dart`، فيها `LoginRequested, GuestLoginRequested, SignUpRequested, ForgotPasswordRequested`. كل واحدة بتحمل البيانات اللي محتاجاها بس (زي email/password).
- **Cubit**: `AuthCubit extends BaseCubit<AuthState>` — Cubit واحد بيغطي الـ Login و الـ Sign Up و الـ Forgot Password التلاتة، مسؤول عن الـ orchestration بس عن طريق `onIntent()` اللي بيوزع كل `Intent` لـ handler method خاص بيه (`_login, _continueAsGuest, _signUp, _sendPasswordResetEmail`)، مايعملش أي validation جواه.
- **State**: `AuthState` — sealed class فيها `AuthInitial, AuthLoading, AuthLoginSuccess(UserEntity), AuthSignUpSuccess(UserEntity), AuthPasswordResetEmailSent(String email), AuthFailed(String message)` — دي الـ "Model" في MVI.

**ملحوظة مهمة**: `ResetPasswordCubit` (شاشة "Reset password" بعد الـ OTP) **متسيبش لوحدها عن قصد** ومندمجتش جوه `AuthCubit` — لأنها منطقيًا مش جزء من الـ Login/SignUp/ForgotPassword flow (بتيجي بعد التحقق من OTP، مش قبله)، وليها Repository call مختلف (`resetPassword()` مش `login()`).

---

## 8) Dependency Injection (GetIt)

```text
main.dart
   │
   ↓ setupCustomerAppDependencies()
   │
   ├── setupCoreDependencies()   (من lib/core/di/injector.dart)
   │       ├── registerLazySingleton<NetworkInfo>(AlwaysOnlineNetworkInfo.new)
   │       ├── registerLazySingleton<ApiClient>(UnimplementedApiClient.new)
   │       └── registerLazySingleton<LocalStorageService>(InMemoryLocalStorageService.new)
   │
   └── setupAuthDependencies()   (من lib/core/di/auth_injector.dart)
           ├── registerLazySingleton<AuthLocalDataSource>(...)
           ├── registerLazySingleton<AuthRepository>(...)
           ├── registerFactory<AuthCubit>(...)
           └── registerFactory<ResetPasswordCubit>(...)
```

- **`sl` = `GetIt.instance`** — تعريفه في `lib/core/di/injector.dart`، واحد بس لكل الـ app (Global service locator).
- **`registerLazySingleton`**: بيعمل instance واحدة بس أول مرة حد يطلبها، وبعدين بيرجعلك نفسها كل مرة — مستخدمة للـ Repositories والـ DataSources لأنهم مفيهمش حالة بتتغير لكل شاشة.
- **`registerFactory`**: بيعمل instance **جديدة كل مرة** — مستخدمة للـ Cubits لأن كل شاشة محتاجة نسخة لوحدها من الـ Cubit بحالتها الخاصة. الـ 3 شاشات (Login/SignUp/ForgotPassword) كل واحدة بتاخد نسخة `AuthCubit` جديدة، عشان الـ Form/Error state متتسربش من شاشة للتانية، بس الكلاس نفسه واحد.
- **ليه بنسجل Interface مش Implementation؟** `registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(...))` — يعني لما أي حد يطلب `sl<AuthRepository>()` هيرجعله الـ implementation، بس هو مش عارف ولا محتاج يعرف إن اللي وراه `AuthRepositoryImpl`. لو غيرناها بكرة لـ `AuthRepositoryRemoteImpl` — كل حاجة تانية في الكود مش هتتغير.
- **الوصول للـ Cubit**: في الـ Routing (`customer_pages.dart`) بيتلف بـ `BlocProvider(create: (_) => sl<AuthCubit>(), child: LoginView())` (ونفس الشيء لـ SignUp و ForgotPassword).
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
Cubit → result.fold(failure → safeEmit(AuthFailed(failure.message)))
      ↓
AuthState.AuthFailed(message)
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
| `AppAssets` | مسارات كل الصور/الأيقونات/الترجمات + اللوجو والأيقونة البراند — كلاس واحد بس دلوقتي بعد ما اتدمجوا (كانوا كلاسين منفصلين قبل شيل الـ Monorepo) |

**ليه ماينفعش تكتب `Color(0xFF...)` أو `fontSize: 18` جوه شاشة؟** لأن ده بيكسر الـ Single Source of Truth — لو الـ Design تغير لون الـ primary بكرة، هتدور على كل مكان استخدمته يدويًا بدل ما تغير قيمة واحدة في `AppColors`. كمان بيبوظ التناسق بين الشاشات المختلفة.

---

## 13-14) Common Package & Core Entities

اتغطوا بالتفصيل في قسم 3 (الـ widgets) — الجدول فوق فيه كل الـ widgets المهمة.

**Cross-feature entities في `customer_app/lib/core/domain/entities/`**: `UserEntity` (id, firstName, lastName, email, phoneNumber?, avatarUrl?, gender, isGuest) و`AddressEntity` (id, label, city, details, recipientName?, phoneNumber?, area?, isDefault)، بالإضافة لـ `CartItemEntity`, `OrderEntity`, `NotificationEntity`. دول في `core/` مش جوه فيتشر معين لأنهم Cross-feature — أكتر من فيتشر هيحتاجهم (مثلاً `UserEntity` هيستخدمها Auth دلوقتي، وProfile/Checkout بعدين).

**ملحوظة تاريخية**: `UserEntity` و`AddressEntity` كانوا قبل كده في باكدج منفصل اسمه `packages/shared` (لأنه كان مشترك بين تطبيقين — Customer و Rider). بعد ما اتشال الـ Rider app، الباكدج ده بقى مالوش مبرر يستمر لوحده (مستهلك واحد بس)، فاتنقل محتواه لـ `core/domain/entities/` جوه `customer_app` نفسه، متسقًا مع باقي الـ Entities المشتركة زي `CartItemEntity`.

---

## 15) Customer App — الفيتشرز

| الفيتشر | الحالة | التفاصيل |
|---|---|---|
| **Auth** | ✅ شغال بالكامل (بس على بيانات محلية) | Login, Sign up, Forgot password (كلهم عن طريق `AuthCubit` واحد)، OTP verification (بدون منطق تحقق حقيقي — أي 4 أرقام بتعدي)، Reset password (عن طريق `ResetPasswordCubit` منفصل). كله متسجل في DI والـ Routing. |
| **Catalog** | ⚠️ Data + Domain بس | الـ Repository والـ DataSource موجودين وشغالين (بيانات ثابتة)، **بس مفيش View ولا Cubit ولا حتى تسجيل في DI**. |
| **Home** | ⚠️ Cubit بس، مش متوصل | `HomeCubit`/`HomeState` موجودين ومكتوبين كويس، بس **مفيش View خالص**، ومش متسجل في أي DI، فهو "ميت" — مش بيتنفذ في الـ app فعليًا. |
| **Splash** | ✅ مبني ومتوصل | `SplashView` كاملة وشغالة (بتستنى شوية وتروح للـ Login)، ومتسجلة في `customer_pages.dart` كـ `initialRoute`. |
| **Cart, Checkout, Orders, Notifications, Profile** | ❌ Scaffold بس | كل فولدر فيه ملف `README.md` بس بيقول "Not yet implemented" — **صفر ملفات Dart**. الـ Entities بتاعتهم (`CartItemEntity`, `OrderEntity`, `NotificationEntity`) اتعملت في `core/domain/entities/` استعدادًا بس. |

**رسم لفيتشر Auth (الوحيد الكامل فعليًا):**
```text
Auth
│
├── Login              ✅ View + AuthCubit + AuthIntent + AuthState + Repository + DataSource
├── Sign Up            ✅ نفس الـ AuthCubit، Intent مختلف (SignUpRequested)
├── Forgot Password    ✅ نفس الـ AuthCubit، Intent مختلف (ForgotPasswordRequested)
├── OTP Verification   ⚠️ View بس، مفيش Cubit (شاشة ثابتة)
└── Reset Password     ✅ Cubit منفصل (ResetPasswordCubit) عن قصد
```

---

## 16) Routing

```text
main.dart → runApp(FlowerApp) → GetMaterialApp(getPages: CustomerPages.pages, initialRoute: CustomerRoutes.splash)
```

**الـ Routes المسجلة فعليًا في `customer_pages.dart`:**

| Route name | بتوصل لإيه |
|---|---|
| `/splash` | `SplashView` (الـ `initialRoute`) |
| `/login` | `LoginView` (جوه `BlocProvider<AuthCubit>`) |
| `/sign-up` | `SignUpView` (جوه `BlocProvider<AuthCubit>`) |
| `/forgot-password` | `ForgotPasswordView` (جوه `BlocProvider<AuthCubit>`) |
| `/otp-verification` | `OtpVerificationView` (من غير BlocProvider) |
| `/reset-password` | `ResetPasswordView` (جوه `BlocProvider<ResetPasswordCubit>`) |

**مشكلة موجودة**: `CustomerRoutes.main` (الوجهة بعد نجاح تسجيل الدخول، عن طريق `Get.offAllNamed(CustomerRoutes.main)`) **مالهاش `GetPage` متسجل خالص** — يعني لو حد سجل دخول فعلًا دلوقتي، الـ navigation هتفشل لأن مفيش شاشة على الـ route ده. كل باقي الـ Routes في `CustomerRoutes` (categories, cart, checkout, orders...) معرّفة كـ Strings بس بدون `GetPage`.

---

## 17) Assets

```text
assets/images/         → images (المنتجات + اللوجو) — 15 ملف
assets/icons/           → icons (تطبيق + البراند) — 47 ملف
assets/fonts/           → Inter, Outfit, Roboto, IMFellEnglish (Inter بس مسجل فعليًا في pubspec fonts:, الباقي ملفات موجودة بس مش مستخدمة — ملحوظة تحت)
assets/translations/    → en.json, ar.json
assets/animations/      → 3 ملفات، لسه مش متربطة بأي widget
```

كل الـ assets متسجلة في `pubspec.yaml` تحت `flutter: assets:` (مسار واحد لكل نوع)، و`flutter: fonts:` لخط Inter بس.

**ملحوظة موجودة فعليًا (قبل شيل الـ Monorepo كمان)**: `AppTextStyles` بتستخدم `GoogleFonts.inter()` من مكتبة `google_fonts` (بتجيب الخط ديناميكيًا)، مش الخط المحلي المسجل في `pubspec.yaml`. يعني تسجيل `assets/fonts/inter.ttf` في الـ `fonts:` section **مش بيتستخدم فعليًا حاليًا**، وملفات `Outfit.ttf`/`roboto.ttf`/`IMFellEnglish.ttf` مش متسجلة ولا مستخدمة خالص. سيبتهم زي ما هم من غير حذف أو تسجيل جديد — ده تغيير سلوك (بندل حجمه ممكن يتأثر) مش جزء من مهمة الـ Restructuring.

---

## 18) Architecture Rules (حدود الاعتماد بين الأجزاء)

مبقاش فيه packages منفصلة يبقى ليها `pubspec.yaml` خاص، فالحدود دلوقتي بتتفرض بالـ **اتفاق على الفولدرات** مش بحدود Package حقيقية:

```text
lib/features/*  ──→  lib/core/, lib/common/     (مسموح)
lib/common/     ──→  lib/core/                   (مسموح: common بيستخدم design tokens من core)
lib/core/       ──→  ❌ ماينفعش يعتمد على lib/features/* ولا lib/common/
```

يعني: أي فيتشر جديد يقدر يستورد من `core`/`common` براحته، بس `core` نفسه لازم يفضل معزول عن تفاصيل أي فيتشر معين — ده بيتفحص يدويًا في الـ Code Review (Analyzer مش بيفرضه زي ما كانت الـ packages المنفصلة بتعمل قبل كده). هي المرة الوحيدة اللي فيها تراجع فعلي عن صرامة أعلى (package boundaries) مقابل بساطة أكتر (مشروع Flutter عادي واحد) — قرار واعي اتاخد بناءً على طلب المستخدم.

---

## 19) مثال كامل: فيتشر Auth (Login) من الأول للآخر

```text
User يدوس "Login"
      ↓
LoginView._submit()
      ↓
context.read<AuthCubit>().onIntent(LoginRequested(email, password))
      ↓
AuthCubit.onIntent()  → switch expression → _login(intent)
      ↓
safeEmit(AuthLoading())
      ↓
AuthRepository.login()  (interface)
      ↓
AuthRepositoryImpl.login()  (impl)
      ↓
AuthLocalDataSource.login()  (mock, delay 600ms)
      ↓
Result<UserEntity>
      ↓
result.fold(...)
      ↓
AuthState (AuthLoginSuccess/AuthFailed)
      ↓
LoginView (BlocConsumer rebuild)
```

### الملفات والكلاسات بالتفصيل

**`login_view.dart` → `LoginView` (StatefulWidget)**
- بتمسك `_emailController, _passwordController, _rememberMe (ValueNotifier<bool>)`.
- `_validateEmail()/_validatePassword()`: بتنادي `Validators.email/password` من `core`، ولو فيه error بترجع رسالة من `AppStrings` (مترجمة).
- `_submit()`: لو `_formKey.currentState.validate()` نجح، بينادي `context.read<AuthCubit>().onIntent(LoginRequested(email: email, password: password))`.
- زرار "متابعة كـ زائر" بيبعت `const GuestLoginRequested()`.
- الـ `BlocConsumer<AuthCubit, AuthState>`: في الـ `listener` — لو `AuthLoginSuccess` يروح `CustomerRoutes.main` (Get.offAllNamed)، لو `AuthFailed` يعرض SnackBar. في الـ `builder` — بيقفل الفورم ويعرض Spinner لو `AuthLoading`.

**`auth_intent.dart` → `AuthIntent` (sealed)**
- `LoginRequested(email, password), GuestLoginRequested(), SignUpRequested(...), ForgotPasswordRequested(email)` — كل واحدة `Equatable`، بتحمل بيانات الفورم بس، مفيهاش أي منطق.

**`auth_cubit.dart` → `AuthCubit extends BaseCubit<AuthState>`**
- Constructor: `AuthCubit(this._authRepository) : super(const AuthInitial())`.
- `onIntent(AuthIntent intent)`: `switch` expression بيوزع كل نوع `Intent` على الـ handler بتاعه (`_login, _continueAsGuest, _signUp, _sendPasswordResetEmail`).
- كل handler: `safeEmit(AuthLoading())` → `await _authRepository.<method>(...)` → `result.fold(failure → AuthFailed(failure.message), success → AuthXxxSuccess(...))`.
- **مفيهاش أي Validation جواها** — دي مسؤولية الـ View + Validators بس.

**`auth_state.dart` → `AuthState` (sealed)**
- `AuthInitial, AuthLoading, AuthLoginSuccess(UserEntity), AuthSignUpSuccess(UserEntity), AuthPasswordResetEmailSent(String email), AuthFailed(String message)` — كلهم `Equatable`.

**`auth_repository.dart` → `AuthRepository` (abstract interface)**
- `login()`, `signUp()`, `continueAsGuest()`, `sendPasswordResetEmail()`, `resetPassword()` — كلهم بيرجعوا `Result<T>`.

**`auth_repository_impl.dart` → `AuthRepositoryImpl implements AuthRepository`**
- `login()`: `try { user = await _dataSource.login(...); await _localStorageService.setString('auth_access_token', 'placeholder-access-token-${user.id}'); return Result.success(user); } on ServerException catch (e) { return Result.failure(AuthFailure(e.message)); }`.
- ملحوظة: الـ Token المخزن **مش JWT حقيقي**، مجرد String ثابت شكله `placeholder-access-token-user-1`.

**`auth_local_data_source.dart` → `AuthLocalDataSourceImpl implements AuthLocalDataSource`**
- `login()`: `await Future.delayed(600ms)` → لو الـ email/password متطابقين مع `test@flowery.com` / `Password123` يرجع `UserEntity` ثابتة (Nour Mohamed) — غير كده يرمي `ServerException('Invalid email or password')`.

**DI (`auth_injector.dart`)**: `registerLazySingleton<AuthLocalDataSource>`, `registerLazySingleton<AuthRepository>`, `registerFactory<AuthCubit>`, `registerFactory<ResetPasswordCubit>`.

**Routing (`customer_pages.dart`)**: `GetPage(name: '/login', page: () => BlocProvider(create: (_) => sl<AuthCubit>(), child: LoginView()))`.

---

## Quick Mental Model

```text
                         FLOWERY
                      (App واحد، مفيش Monorepo)
                    (Auth شغال بالكامل,
                    باقي Scaffold/جزئي)
                            │
              ┌─────────────┼─────────────┐
              │             │             │
        lib/core/      lib/common/   lib/features/
                            │
                            ↓
                     Clean Architecture
                            │
                            ↓
                          MVI
              (Intent sealed class حقيقية لـ Auth،
               Cubit.onIntent() بيوزعها)
                            │
                            ↓
                 View → Intent → Cubit → Domain
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

**خلاصة نهائية لو نسيت كل حاجة وعايز تفتكر نقطة واحدة بس**: الريبو دلوقتي تطبيق E-commerce واحد بس، معماريته جاهزة ونضيفة ومتبعة Clean Architecture + MVI صح (Intent → Cubit → State)، بس **فيتشر Auth بس هو الكامل فعليًا** — كل حاجة تانية إما Scaffold (فولدر + README) أو Data-layer-بس-من-غير-UI (Catalog, Home). ولما تيجي تبني API حقيقي، هتلاقي كل حاجة جاهزة تستقبله من غير ما تغير حرف في الـ Cubits أو الـ Views.
