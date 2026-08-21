import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/views/otp_verification_view.dart';

import '../../support/fake_auth_repository.dart';
import '../../support/localization_harness.dart';

Widget _harness(AuthRepository repository, {Locale? locale}) {
  return localizedApp(
    locale: locale,
    home: BlocProvider(
      create: (_) => AuthCubit(repository),
      child: const OtpVerificationView(),
    ),
  );
}

Future<void> _enterCode(WidgetTester tester, String code) async {
  final boxes = find.byType(TextField);
  for (var index = 0; index < code.length; index++) {
    await tester.enterText(boxes.at(index), code[index]);
    await tester.pump();
  }
}

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('renders exactly four single-digit boxes', (tester) async {
    await pumpLocalized(tester, _harness(FakeAuthRepository()));

    final boxes = find.byType(TextField);
    expect(boxes, findsNWidgets(4));

    for (var index = 0; index < 4; index++) {
      expect(tester.widget<TextField>(boxes.at(index)).maxLength, 1);
    }
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

  testWidgets('a rejected code shows the failure below the boxes',
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

    await _enterCode(tester, '9999');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pumpAndSettle();

    final message = find.text(AppStrings.invalidVerificationCode);
    expect(message, findsOneWidget);
    expect(
      tester.getTopLeft(message).dy,
      greaterThan(tester.getTopLeft(find.byType(TextField).first).dy),
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

    await _enterCode(tester, '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
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
