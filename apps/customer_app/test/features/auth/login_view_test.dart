import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/error/failures.dart';
import 'package:core/result/result.dart';
import 'package:design_system/theme/app_theme.dart';
import 'package:shared/domain/entities/user_entity.dart';

import 'package:customer_app/constants/app_strings.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:customer_app/features/auth/presentation/views/login_view.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.loginResult});

  final Result<UserEntity>? loginResult;

  @override
  Future<Result<UserEntity>> login({required String email, required String password}) async {
    return loginResult ?? Future<Result<UserEntity>>.delayed(const Duration(days: 1));
  }

  @override
  Future<Result<UserEntity>> continueAsGuest() async {
    return const Result.success(UserEntity(id: 'guest', firstName: 'Guest', lastName: '', email: '', isGuest: true));
  }

  @override
  Future<Result<UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required Gender gender,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) => throw UnimplementedError();

  @override
  Future<Result<void>> resetPassword({required String currentPassword, required String newPassword}) =>
      throw UnimplementedError();
}

Widget _harness(AuthRepository repository) {
  return EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.light,
        home: BlocProvider(
          create: (_) => LoginCubit(repository),
          child: const LoginView(),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('renders every Login field, button and link from the Figma frame', (tester) async {
    await tester.pumpWidget(_harness(_FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.email), findsOneWidget);
    expect(find.text(AppStrings.password), findsOneWidget);
    expect(find.text(AppStrings.rememberMe), findsOneWidget);
    expect(find.text(AppStrings.forgetPassword), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, AppStrings.login), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, AppStrings.continueAsGuest), findsOneWidget);
    expect(find.text(AppStrings.signUp), findsOneWidget);
    // Figma: `Trailing icon: False` on the Password field — no
    // show/hide-password toggle should be rendered.
    expect(find.byIcon(Icons.visibility_outlined), findsNothing);
    expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
  });

  testWidgets('submitting an empty form shows the Figma-exact validation errors', (tester) async {
    await tester.pumpWidget(_harness(_FakeAuthRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.invalidEmail), findsOneWidget);
    expect(find.text(AppStrings.invalidPassword), findsOneWidget);
  });

  testWidgets('a submitting login shows the PrimaryButton loading spinner', (tester) async {
    await tester.pumpWidget(_harness(_FakeAuthRepository()));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'test@flowery.com');
    await tester.enterText(fields.at(1), 'Password123');

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    // One frame only: the fake repository's Future never resolves within
    // the test, so this captures the in-flight `LoginSubmitting` state.
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text(AppStrings.login), findsNothing);
  });

  testWidgets('a failed login shows the API error message in a SnackBar', (tester) async {
    await tester.pumpWidget(
      _harness(_FakeAuthRepository(loginResult: const Result.failure(AuthFailure('Invalid email or password')))),
    );
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'test@flowery.com');
    await tester.enterText(fields.at(1), 'Password123');

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password'), findsOneWidget);
  });
}
