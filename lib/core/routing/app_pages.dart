import 'package:get/get.dart';

/// GetX route table mapping every [AppRoutes] name to a page; empty by design until features are wired.
abstract final class AppPages {
  const AppPages._();

  static final List<GetPage> pages = <GetPage>[
    // Each feature appends its own GetPage(name: ..., page: () => BlocProvider(...)) entry here once wired.
  ];
}
