import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/common/widgets/inputs/app_text_field.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/views/reset_password_view.dart';

import '../../support/fake_auth_repository.dart';
import '../../support/localization_harness.dart';

Widget _harness(AuthRepository repository, {Locale? locale}) {
  return localizedApp(
    locale: locale,
    home: BlocProvider(
      create: (_) => AuthCubit(repository),
      child: const ResetPasswordView(),
    ),
  );
}

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('asks only for the new password and its confirmation',
      (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    expect(find.byType(AppTextField), findsNWidgets(2));
    expect(find.text(AppStrings.newPassword), findsOneWidget);
    expect(find.text(AppStrings.confirmPassword), findsOneWidget);

    // A user who reached this screen through Forgot Password cannot supply
    // a current password — that is the whole reason they are here.
    expect(find.text(AppStrings.currentPassword), findsNothing);
  });

  testWidgets('both fields are obscured', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    for (var index = 0; index < 2; index++) {
      expect(
        tester
            .widget<AppTextField>(find.byType(AppTextField).at(index))
            .obscureText,
        isTrue,
      );
    }
  });

  testWidgets('empty fields report their own messages', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.update));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.passwordRequired), findsOneWidget);
    expect(find.text(AppStrings.confirmPasswordRequired), findsOneWidget);
  });

  testWidgets('a mismatch between the two passwords is reported',
      (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'NewPassword123');
    await tester.enterText(fields.at(1), 'NewPassword124');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.update));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.passwordsDoNotMatch), findsOneWidget);
  });

  testWidgets('shows a loading spinner while submitting', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'NewPassword123');
    await tester.enterText(fields.at(1), 'NewPassword123');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.update));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders in Arabic under RTL', (tester) async {
    await pumpLocalized(
        tester, _harness(FakeAuthRepository(), locale: const Locale('ar')));

    expect(find.text(AppStrings.newPassword), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(ResetPasswordView))),
      TextDirection.rtl,
    );
  });
}
