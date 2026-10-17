import 'package:flutter/material.dart';

enum NotificationCategory {
  rideUpdates,
  messages,
  reminders,
  reportsSafety,
  updates,
  lostFound,
}

extension NotificationCategoryX on NotificationCategory {
  String get label => switch (this) {
        NotificationCategory.rideUpdates => 'Ride Updates',
        NotificationCategory.messages => 'Messages',
        NotificationCategory.reminders => 'Reminders',
        NotificationCategory.reportsSafety => 'Reports & Safety',
        NotificationCategory.updates => 'Updates',
        NotificationCategory.lostFound => 'Lost & Found',
      };

  /// Accent color used for the icon box and category pill.
  Color get color => switch (this) {
        NotificationCategory.rideUpdates => const Color(0xFF6D5BF5),
        NotificationCategory.messages => const Color(0xFF06B6D4),
        NotificationCategory.reminders => const Color(0xFFF59E0B),
        NotificationCategory.reportsSafety => const Color(0xFFEF4444),
        NotificationCategory.updates => const Color(0xFF8B5CF6),
        NotificationCategory.lostFound => const Color(0xFF10B981),
      };

  String get defaultNextStep => switch (this) {
        NotificationCategory.rideUpdates =>
          'Open My Rides to view the latest status of your trip.',
        NotificationCategory.messages =>
          'Open the conversation and reply if needed.',
        NotificationCategory.reminders =>
          'Be at your pickup point a few minutes early.',
        NotificationCategory.reportsSafety =>
          'Review the details and contact support if something looks wrong.',
        NotificationCategory.updates => 'No action is needed.',
        NotificationCategory.lostFound =>
          'Wait for a response and do not arrange a private meeting outside the app.',
      };
}

class NotificationRideInfo {
  const NotificationRideInfo({
    required this.driverName,
    required this.rating,
    required this.route,
    required this.departs,
    required this.seats,
    required this.fare,
  });

  final String driverName;
  final double rating;
  final String route;
  final String departs;
  final String seats;
  final String fare;
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.timeLabel,
    this.isRead = false,
    this.details,
    this.nextStep,
    this.ride,
  });

  final String id;
  final NotificationCategory category;
  final String title;
  final String message;
  final String timeLabel; // "5m ago", "Yesterday", ...
  final bool isRead;
  final String? details;
  final String? nextStep;
  final NotificationRideInfo? ride;

  String get detailsText => details ?? message;
  String get nextStepText => nextStep ?? category.defaultNextStep;

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        category: category,
        title: title,
        message: message,
        timeLabel: timeLabel,
        isRead: isRead ?? this.isRead,
        details: details,
        nextStep: nextStep,
        ride: ride,
      );
}

/// Sample data that mirrors your screenshots (33 total, 12 unread).
/// Items you didn't show me are placeholders - replace with real data.
List<AppNotification> sampleNotifications() {
  const r = NotificationCategory.rideUpdates;
  const m = NotificationCategory.messages;
  const rem = NotificationCategory.reminders;
  const s = NotificationCategory.reportsSafety;
  const u = NotificationCategory.updates;
  const l = NotificationCategory.lostFound;

  var i = 0;
  AppNotification n(
    NotificationCategory c,
    String title,
    String message,
    String time, {
    bool unread = false,
    String? details,
    String? nextStep,
    NotificationRideInfo? ride,
  }) =>
      AppNotification(
        id: 'n${i++}',
        category: c,
        title: title,
        message: message,
        timeLabel: time,
        isRead: !unread,
        details: details,
        nextStep: nextStep,
        ride: ride,
      );

  return [
    n(r, 'Ride Request Accepted',
        'Ramon Dela Rosa accepted your ride request to CMDI Main Campus.',
        '5m ago',
        unread: true,
        details:
            'Your seat is reserved for the 6:30 AM departure from Bitin Junction.',
        nextStep:
            'Review the driver, vehicle, pickup point, and departure time before the ride.',
        ride: const NotificationRideInfo(
          driverName: 'Ramon Dela Rosa',
          rating: 4.8,
          route: 'Bitin → CMDI Main Campus',
          departs: '6:30 AM',
          seats: '2 left',
          fare: '₱15',
        )),
    n(r, 'Driver Is on the Way', 'Your driver is heading to Bitin Junction.',
        '12m ago',
        unread: true),
    n(r, 'Ride Completed', 'Your ride with Ligaya Reyes has been completed.',
        '2h ago',
        unread: true,
        nextStep: 'You can rate your ride from the Completed tab in My Rides.'),
    n(r, 'New Matching Ride Available',
        'A ride matching Bitin → CMDI Main Campus is available at 6:30 AM.',
        '3h ago'),
    n(m, 'New Message from Driver',
        'Ramon sent a message about your pickup point.', '20m ago',
        unread: true),
    n(rem, 'Upcoming Ride Reminder', 'Your ride departs tomorrow at 6:30 AM.',
        '4h ago'),
    n(rem, 'Scheduled Departure Reminder',
        'Your ride is scheduled to leave in 30 minutes.', 'Yesterday'),
    n(s, 'Safety Advisory for Your Route',
        'Temporary road congestion has been reported near CMDI Main Campus.',
        'Yesterday',
        unread: true,
        nextStep: 'Allow extra travel time and check your ride before leaving.'),
    n(s, 'Report Is Under Review',
        'Your vehicle-information report was received for review.', '1d ago'),
    n(u, 'Password Changed Successfully',
        'Your ShareTrip account password was updated.', '2d ago',
        nextStep:
            'If this was not you, change your password and contact support.'),
    n(u, 'New Campus Pickup Point',
        'CMDI Bay 2 Annex Gate is now available as a pickup point.', '3d ago'),
    n(u, 'New Feature Announcement',
        'ShareTrip now shows departure times on all ride cards.', '4d ago'),
    n(r, 'Ride Request Declined',
        'The driver could not accept your request for the 7:00 AM ride.',
        '6d ago'),
    n(r, 'Ride Schedule Changed',
        'Your ride departure time was updated by the driver.', '1w ago',
        unread: true),
    n(r, 'Ride Started', 'Your ride to CMDI Main Campus has started.', '1w ago'),
    n(r, 'Pickup Point Updated',
        'The driver changed the pickup point for your ride.', '1w ago'),
    n(r, 'Ride Cancelled',
        'A ride you were waiting for was cancelled by the driver.', '2w ago'),
    n(m, 'Reply from ShareTrip Support',
        'Support replied to your question.', '1h ago',
        unread: true),
    n(m, 'New Message from Driver',
        'Maria sent a message about the departure time.', '1d ago'),
    n(m, 'Message from Ligaya Reyes',
        'Ligaya sent you a message about your last ride.', '3d ago'),
    n(rem, 'Be Ready at the Pickup Point',
        'Your driver is expected to arrive in approximately 10 minutes.',
        '2w ago',
        unread: true),
    n(rem, 'Confirm Your Ride Details',
        "Please review tomorrow's pickup, destination, and passenger count.",
        '2w ago'),
    n(rem, 'Waiting-List Availability Reminder',
        'A waiting-list seat is being held for 10 minutes.', '2w ago'),
    n(s, 'New Device Login Detected',
        'Your account was accessed from a new device.', '2w ago',
        unread: true,
        nextStep:
            'If this was not you, change your password right away.'),
    n(s, 'Additional Report Information Requested',
        'More details are needed for report ST-2026-0918.', '2w ago'),
    n(s, 'Vehicle Safety Concern Reported',
        'A safety concern was reported for a vehicle on your saved route.',
        '2w ago'),
    n(u, 'Scheduled Maintenance',
        'ShareTrip will be briefly unavailable this weekend.', '1w ago',
        unread: true),
    n(u, 'App Update Available',
        'A new version of ShareTrip is ready to install.', '2w ago'),
    n(u, 'Terms Updated', 'We updated our Terms & Conditions.', '3w ago',
        unread: true),
    n(l, 'Lost Item Report Submitted',
        'Your lost-item inquiry was recorded for ride r2.', '5d ago',
        details:
            'The inquiry concerns an item reported after the Maitim to CMDI Main Campus trip.',
        nextStep:
            'Wait for a driver response and do not arrange a private meeting outside the app.'),
    n(l, 'Driver Responded to Lost Item Inquiry',
        'The driver found an item matching your description.', '5d ago',
        unread: true),
    n(l, 'Lost Item Details Requested',
        'Support needs more information to identify your missing item.',
        '3w ago'),
    n(l, 'Lost Item Case Closed',
        'Your lost-item case was marked as resolved.', '3w ago'),
  ];
}