import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/common/widgets/inputs/app_text_field.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/views/forgot_password_view.dart';

import '../../support/fake_auth_repository.dart';
import '../../support/localization_harness.dart';

Widget _harness(AuthRepository repository, {Locale? locale}) {
  return localizedApp(
    locale: locale,
    home: BlocProvider(
      create: (_) => AuthCubit(repository),
      child: const ForgotPasswordView(),
    ),
  );
}

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('renders the title, description and a single email field',
      (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    expect(find.text(AppStrings.forgotPasswordTitle), findsOneWidget);
    expect(find.text(AppStrings.forgotPasswordSubtitle), findsOneWidget);
    expect(find.byType(AppTextField), findsOneWidget);
    expect(find.text(AppStrings.email), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, AppStrings.confirm),
        findsOneWidget);
  });

  testWidgets('an empty email reports the required rule', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.emailRequired), findsOneWidget);
  });

  testWidgets('a malformed email reports the format rule', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.enterText(find.byType(TextFormField), 'not-an-email');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.invalidEmail), findsOneWidget);
  });

  testWidgets('shows a loading spinner while the request is in flight',
      (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.enterText(find.byType(TextFormField), 'test@flowery.com');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('the email placeholder is localized, not a built English string',
      (tester) async {
    await pumpLocalized(
        tester, _harness(FakeAuthRepository(), locale: const Locale('ar')));

    expect(find.text(AppStrings.enterYourEmail), findsOneWidget);
    expect(find.text('enter email'), findsNothing);
    expect(
      Directionality.of(tester.element(find.byType(ForgotPasswordView))),
      TextDirection.rtl,
    );
  });
}
