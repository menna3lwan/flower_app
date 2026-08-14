import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/utils/validators.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/views/login_view.dart';

import '../../support/fake_auth_repository.dart';
import '../../support/localization_harness.dart';

Widget _harness(AuthRepository repository, {Locale? locale}) {
  return localizedApp(
    locale: locale,
    home: BlocProvider(
      create: (_) => AuthCubit(repository),
      child: const LoginView(),
    ),
  );
}

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('renders every Login field, button and link', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    expect(find.text(AppStrings.email), findsOneWidget);
    expect(find.text(AppStrings.password), findsOneWidget);
    expect(find.text(AppStrings.rememberMe), findsOneWidget);
    expect(find.text(AppStrings.forgetPassword), findsOneWidget);
    expect(
        find.widgetWithText(ElevatedButton, AppStrings.login), findsOneWidget);
    expect(
      find.widgetWithText(OutlinedButton, AppStrings.continueAsGuest),
      findsOneWidget,
    );
    expect(find.text(AppStrings.signUp), findsOneWidget);
  });

  testWidgets('an empty submit reports each field as missing, not malformed',
      (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.emailRequired), findsOneWidget);
    expect(find.text(AppStrings.passwordRequired), findsOneWidget);
    // The old behaviour showed "This Email is not valid" for a blank field.
    expect(find.text(AppStrings.invalidEmail), findsNothing);
  });

  testWidgets('a malformed email reports the format rule', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.invalidEmail), findsOneWidget);
    expect(find.text(AppStrings.emailRequired), findsNothing);
  });

  testWidgets('a too-short password reports the length rule', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.enterText(find.byType(TextFormField).at(1), 'abc');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pumpAndSettle();

    expect(
      find.text(AppStrings.passwordTooShort(Validators.minPasswordLength)),
      findsOneWidget,
    );
  });

  testWidgets('validation errors render below their field', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pumpAndSettle();

    // Label above the box, error below it — the order Figma specifies.
    final labelY = tester.getTopLeft(find.text(AppStrings.email)).dy;
    final fieldY = tester.getTopLeft(find.byType(TextFormField).at(0)).dy;
    final errorY = tester.getTopLeft(find.text(AppStrings.emailRequired)).dy;

    expect(labelY, lessThan(fieldY));
    expect(errorY, greaterThan(fieldY));
  });

  testWidgets('a submitting login shows the PrimaryButton loading spinner',
      (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@flowery.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Password123');

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    // One frame only: the fake repository's Future never resolves within
    // the test, so this captures the in-flight `AuthLoading` state.
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text(AppStrings.login), findsNothing);
  });

  testWidgets('a failed login shows the localized failure message',
      (tester) async {
    await pumpLocalized(
      tester,
      _harness(
        FakeAuthRepository(
          loginResult: const Result.failure(InvalidCredentialsFailure()),
        ),
      ),
    );

    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@flowery.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Password123');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.invalidCredentials), findsOneWidget);
  });

  testWidgets('renders in Arabic under RTL', (tester) async {
    await pumpLocalized(
        tester, _harness(FakeAuthRepository(), locale: const Locale('ar')));

    expect(find.text(AppStrings.email), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(LoginView))),
      TextDirection.rtl,
    );
  });

  testWidgets('failure messages follow the active locale', (tester) async {
    await pumpLocalized(
      tester,
      _harness(
        FakeAuthRepository(
          loginResult: const Result.failure(InvalidCredentialsFailure()),
        ),
        locale: const Locale('ar'),
      ),
    );

    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@flowery.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Password123');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pumpAndSettle();

    // Would fail if the message were baked in English at the data layer.
    expect(find.text(AppStrings.invalidCredentials), findsOneWidget);
    expect(find.text('Invalid email or password'), findsNothing);
  });
}
