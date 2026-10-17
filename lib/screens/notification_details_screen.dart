import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import 'notification_models.dart';
import '../widgets/settings_widget.dart';

/// Images 7 & 8 - Notification Details. Shows a "Ride Information" section
/// when the notification has [AppNotification.ride] data.
class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key, required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    final n = notification;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final accent = n.category.color;
    final pillText = isDark
        ? accent
        : HSLColor.fromColor(accent).withLightness(0.30).toColor();

    return SubScreenScaffold(
      title: 'Notification Details',
      subtitle: n.timeLabel,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(16),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: accent.withAlpha(36),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.notifications_none_rounded,
                            color: accent, size: 26),
                      ),
                      const SizedBox(height: 16),
                      Text(n.title,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      Text(n.message,
                          style: TextStyle(
                              fontSize: 16, height: 1.4, color: c.mutedText)),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accent.withAlpha(36),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(n.category.label,
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: pillText)),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: c.divider),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel('Details'),
                      const SizedBox(height: 2),
                      Text(n.detailsText,
                          style: const TextStyle(fontSize: 16, height: 1.45)),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: c.primaryTint,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recommended next step',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? c.text : const Color(0xFF2B2A6E))),
                            const SizedBox(height: 6),
                            Text(n.nextStepText,
                                style: TextStyle(
                                    fontSize: 14.5,
                                    height: 1.4,
                                    color: primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (n.ride != null) ...[
                  Divider(height: 1, thickness: 1, color: c.divider),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: _RideInfoSection(ride: n.ride!),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text('Back to Notifications'),
          ),
        ],
      ),
    );
  }
}

class _RideInfoSection extends StatelessWidget {
  const _RideInfoSection({required this.ride});
  final NotificationRideInfo ride;

  String get _initials {
    final name = ride.driverName.trim();
    if (name.isEmpty) return '?';
    final p = name.split(RegExp(r'\s+'));
    return p.length == 1
        ? p.first[0].toUpperCase()
        : (p.first[0] + p.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    final primary = Theme.of(context).colorScheme.primary;

    Widget stat(String label, String value, {Color? color}) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: c.mutedText)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: color)),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Ride Information'),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFF59E0B),
                shape: BoxShape.circle,
              ),
              child: Text(_initials,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ride.driverName,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.successBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield_outlined,
                                size: 14, color: c.success),
                            const SizedBox(width: 5),
                            Text('Verified Driver',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: c.success)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.star_border_rounded,
                          size: 20, color: Color(0xFFF5B301)),
                      const SizedBox(width: 3),
                      Text(ride.rating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Route',
                  style: TextStyle(fontSize: 13, color: c.mutedText)),
              const SizedBox(height: 2),
              Text(ride.route,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Row(
                children: [
                  stat('Departs', ride.departs, color: primary),
                  stat('Seats', ride.seats),
                  stat('Fare', ride.fare, color: c.success),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}