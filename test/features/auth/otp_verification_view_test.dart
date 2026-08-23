import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinput/pinput.dart';

import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/auth/presentation/views/otp_verification_view.dart';

import '../../support/auth_cubit_harness.dart';
import '../../support/fake_auth_repository.dart';
import '../../support/localization_harness.dart';

Widget _harness(AuthRepository repository, {Locale? locale}) {
  return localizedApp(
    locale: locale,
    home: BlocProvider(
      create: (_) => buildAuthCubit(repository),
      child: const OtpVerificationView(),
    ),
  );
}

/// Types [code] into the Pinput field in one go. `enterText` locates the
/// `EditableText` Pinput renders internally (its exact wrapper — `TextField`
/// vs a bare `EditableText` — is a pinput-package implementation detail
/// this suite deliberately doesn't depend on) and sets its full value,
/// which drives Pinput's own onChanged/onCompleted exactly like a user
/// finishing entry would.
Future<void> _enterCode(WidgetTester tester, String code) async {
  await tester.enterText(find.byType(Pinput), code);
  await tester.pump();
}

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('renders a 4-digit Pinput field', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    final pinput = find.byType(Pinput);
    expect(pinput, findsOneWidget);
    expect(tester.widget<Pinput>(pinput).length, 4);
  });

  testWidgets('an incomplete code reports inline, not in a SnackBar',
      (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await _enterCode(tester, '12');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.verificationCodeIncomplete), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('an empty code reports the required rule', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.verificationCodeRequired), findsOneWidget);
  });

  testWidgets('a rejected code shows the failure below the field',
      (tester) async {
    await pumpLocalized(
      tester,
      _harness(
        FakeAuthRepository(
          verifyCodeResult:
              const Result.failure(InvalidVerificationCodeFailure()),
        ),
      ),
    );

    // A full 4-digit code auto-submits via Pinput's onCompleted, exactly
    // like a real user finishing entry — no explicit Confirm tap needed.
    await _enterCode(tester, '9999');
    await tester.pumpAndSettle();

    final message = find.text(AppStrings.invalidVerificationCode);
    expect(message, findsOneWidget);
    expect(
      tester.getTopLeft(message).dy,
      greaterThan(tester.getTopLeft(find.byType(Pinput)).dy),
    );
  });

  testWidgets('typing again clears a previous error', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.verificationCodeRequired), findsOneWidget);

    await _enterCode(tester, '1');
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.verificationCodeRequired), findsNothing);
  });

  testWidgets('shows a loading spinner while verifying', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    // Completing the code auto-submits (see `_OtpPinInput.onCompleted`),
    // so the loading state should appear without an explicit tap.
    await _enterCode(tester, '1234');

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('resend is disabled during its cooldown window',
      (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    // A code was just sent to reach this screen, so the cooldown starts
    // immediately — the resend link should read as a countdown, not a
    // bare "Resend" action, and tapping it must be a no-op.
    expect(find.text(AppStrings.resendCodeAction), findsNothing);

    // Advance less than the full cooldown; the resend action must still
    // be unavailable.
    await tester.pump(const Duration(seconds: 5));
    expect(find.text(AppStrings.resendCodeAction), findsNothing);
  });

  testWidgets('renders in Arabic under RTL', (tester) async {
    await pumpLocalized(
        tester, _harness(FakeAuthRepository(), locale: const Locale('ar')));

    expect(find.text(AppStrings.verificationCodeTitle), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(OtpVerificationView))),
      TextDirection.rtl,
    );
  });
}
