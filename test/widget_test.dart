import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sharetrip_mobile/main.dart';

void main() {
  testWidgets('app shows the welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ShareTripApp());

    expect(find.text('ShareTrip'), findsOneWidget);
    expect(find.text('Share the Ride. Connect with Students.'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });

  testWidgets('tap Log In navigates to the login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ShareTripApp());

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Student Login'), findsOneWidget);
  });

  testWidgets('Saved Places quick action opens the saved places screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ShareTripApp());
    Navigator.of(tester.element(find.text('ShareTrip')))
        .pushNamed(AppRoutes.dashboard);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.ensureVisible(find.text('Saved Places'));
    await tester.tap(find.text('Saved Places'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Your frequently visited destinations'), findsOneWidget);
    expect(find.text('San Jose Village'), findsOneWidget);
  });
}
