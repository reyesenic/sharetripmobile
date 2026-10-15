import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sharetrip_mobile/main.dart';
import 'package:sharetrip_mobile/widgets/navigation_bar_card.dart';

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

  testWidgets('dashboard navigation bar opens My Rides',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ShareTripApp());
    Navigator.of(tester.element(find.text('ShareTrip')))
        .pushNamed(AppRoutes.dashboard);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final navigationBar = find.byType(AppBottomNav);
    expect(navigationBar, findsOneWidget);

    await tester.tap(
      find.descendant(
        of: navigationBar,
        matching: find.text('My Rides'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('Ride History quick action opens the ride history screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ShareTripApp());
    Navigator.of(tester.element(find.text('ShareTrip')))
        .pushNamed(AppRoutes.dashboard);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.ensureVisible(find.text('Ride History'));
    await tester.tap(find.text('Ride History'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('View your previous trips'), findsOneWidget);
    expect(find.text('Ramon Dela Rosa'), findsOneWidget);
  });
}
