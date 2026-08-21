import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/common/widgets/inputs/app_text_field.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/views/sign_up_view.dart';

import '../../support/fake_auth_repository.dart';
import '../../support/localization_harness.dart';

Widget _harness(AuthRepository repository, {Locale? locale}) {
  return localizedApp(
    locale: locale,
    home: BlocProvider(
      create: (_) => AuthCubit(repository),
      child: const SignUpView(),
    ),
  );
}

List<String> _fieldLabels(WidgetTester tester) => tester
    .widgetList<AppTextField>(find.byType(AppTextField))
    .map((field) => field.label)
    .toList();

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('renders all six fields through the shared AppTextField',
      (tester) async {
    useTallSurface(tester);
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    // Sign Up previously used a second, floating-label input widget, which
    // put its labels inside the border instead of above it.
    expect(find.byType(AppTextField), findsNWidgets(6));
    expect(_fieldLabels(tester), [
      AppStrings.firstName,
      AppStrings.lastName,
      AppStrings.email,
      AppStrings.password,
      AppStrings.confirmPassword,
      AppStrings.phoneNumber,
    ]);
  });

  testWidgets('each empty field reports its own message', (tester) async {
    useTallSurface(tester);
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.signUp));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.firstNameRequired), findsOneWidget);
    expect(find.text(AppStrings.lastNameRequired), findsOneWidget);
    expect(find.text(AppStrings.emailRequired), findsOneWidget);
    expect(find.text(AppStrings.passwordRequired), findsOneWidget);
    expect(find.text(AppStrings.confirmPasswordRequired), findsOneWidget);
    expect(find.text(AppStrings.phoneRequired), findsOneWidget);
  });

  testWidgets('a confirm-password mismatch is reported', (tester) async {
    useTallSurface(tester);
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(3), 'Password123');
    await tester.enterText(fields.at(4), 'Password124');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.signUp));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.passwordsDoNotMatch), findsOneWidget);
  });

  testWidgets('first and last name capitalize their first letter',
      (tester) async {
    useTallSurface(tester);
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'nour');
    await tester.enterText(fields.at(1), 'mohamed');
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      'Nour',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      'Mohamed',
    );
  });

  testWidgets('email, password and phone are left exactly as typed',
      (tester) async {
    useTallSurface(tester);
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(2), 'test@flowery.com');
    await tester.enterText(fields.at(3), 'password123');
    await tester.enterText(fields.at(5), '01012345678');
    await tester.pumpAndSettle();

    // Capitalization must not leak beyond the two name fields.
    final controllers = tester
        .widgetList<TextField>(find.byType(TextField))
        .map((f) => f.controller!.text)
        .toList();
    expect(controllers[2], 'test@flowery.com');
    expect(controllers[3], 'password123');
    expect(controllers[5], '01012345678');
  });

  testWidgets('renders in Arabic under RTL', (tester) async {
    useTallSurface(tester);
    await pumpLocalized(
        tester, _harness(FakeAuthRepository(), locale: const Locale('ar')));

    expect(_fieldLabels(tester).first, AppStrings.firstName);
    expect(
      Directionality.of(tester.element(find.byType(SignUpView))),
      TextDirection.rtl,
    );
  });
}
