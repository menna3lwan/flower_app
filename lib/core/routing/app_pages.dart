import 'package:get/get.dart';

/// GetX route table: maps every [AppRoutes] name to the page it renders.
///
/// Empty for now by design — this pass builds the `core`/`common`/
/// `assets` foundation only, no feature screens are wired yet. Each
/// feature appends its own `GetPage` entries here as it's built (see the
/// project task breakdown); the shape is ready so that step is additive,
/// not a refactor.
abstract final class AppPages {
  const AppPages._();

  static final List<GetPage> pages = <GetPage>[
    // Example of the pattern each feature will follow once wired:
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => BlocProvider(
    //     create: (_) => sl<LoginCubit>(),
    //     child: const LoginView(),
    //   ),
    // ),
  ];
}
