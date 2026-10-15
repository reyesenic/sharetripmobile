import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sharetrip_mobile/main.dart';
import 'package:sharetrip_mobile/screens/safety_center_screen.dart';
import 'package:sharetrip_mobile/screens/vehicle_details_screen.dart';
import 'package:sharetrip_mobile/widgets/available_rides.dart';
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
    expect(find.byTooltip('Back'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Manage your current and upcoming trips'), findsNothing);
    expect(find.text('Where are you going today?'), findsOneWidget);
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

  testWidgets('Safety Center button opens the Safety Center screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ShareTripApp());
    Navigator.of(tester.element(find.text('ShareTrip')))
        .pushNamed(AppRoutes.dashboard);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.ensureVisible(find.text('Safety Center'));
    await tester.tap(find.text('Safety Center'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Your safety matters on every trip.'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Safety Guidelines'),
      300,
      scrollable: find.descendant(
        of: find.byType(SafetyCenterScreen),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Safety Guidelines'), findsOneWidget);
  });

  testWidgets('Safety Center opens the tracking, emergency, and report screens',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(key: UniqueKey(), home: const SafetyCenterScreen()),
    );

    await tester.scrollUntilVisible(
      find.text('Ride Tracking & Sharing'),
      250,
      scrollable: find.descendant(
        of: find.byType(SafetyCenterScreen),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('Ride Tracking & Sharing'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('No active ride'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(key: UniqueKey(), home: const SafetyCenterScreen()),
    );
    await tester.scrollUntilVisible(
      find.text('Emergency / SOS'),
      250,
      scrollable: find.descendant(
        of: find.byType(SafetyCenterScreen),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('Emergency / SOS'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Need emergency help?'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(key: UniqueKey(), home: const SafetyCenterScreen()),
    );
    await tester.scrollUntilVisible(
      find.text('Report a Driver or Ride'),
      250,
      scrollable: find.descendant(
        of: find.byType(SafetyCenterScreen),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('Report a Driver or Ride'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Report Type'), findsOneWidget);
  });

  testWidgets('confirming a ride shows the request sent screen',
      (WidgetTester tester) async {
    final ride = sampleRides.first;
    await tester.pumpWidget(
      MaterialApp(home: VehicleDetailsScreen(ride: ride)),
    );

    await tester.tap(find.textContaining('Request Ride'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Confirm Ride'), findsOneWidget);

    await tester.tap(find.text('Confirm Ride'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Request Sent!'), findsOneWidget);
    expect(
      find.text('Your request has been sent to ${ride.driverName}.'),
      findsOneWidget,
    );
    expect(find.text('Check Ride Details'), findsOneWidget);
  });
}
