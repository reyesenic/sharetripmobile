import 'package:flutter/material.dart';

import '../widgets/available_rides.dart';

/// ---------------------------------------------------------------
/// confirm_ride_sheet.dart
///
/// Usage:
///   final confirmed = await showConfirmRideSheet(context, ride);
///   if (confirmed == true) { /* save request to backend */ }
/// ---------------------------------------------------------------

Future<bool?> showConfirmRideSheet(BuildContext context, Ride ride) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => ConfirmRideSheet(ride: ride),
  );
}

class ConfirmRideSheet extends StatelessWidget {
  final Ride ride;

  const ConfirmRideSheet({super.key, required this.ride});

  static const _btn = Color(0xFF4F36F5);

  @override
  Widget build(BuildContext context) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Pickup', ride.pickup),
      MapEntry('Destination', ride.destination),
      MapEntry('Driver', ride.driverName),
      MapEntry('Vehicle', ride.vehicleName),
      MapEntry('Estimated Fare', '₱${ride.fare.toStringAsFixed(0)}'),
      MapEntry('Departure', ride.departTime),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm Your Ride',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: RideColors.dark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Review your trip before requesting.',
              style: TextStyle(fontSize: 15, color: RideColors.label),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF0F1F5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  for (int i = 0; i < rows.length; i++) ...[
                    _row(rows[i].key, rows[i].value),
                    if (i != rows.length - 1)
                      const Divider(height: 1, color: Color(0xFFF3F4F7)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: RideColors.dark,
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btn,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Confirm Ride',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: RideColors.label),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: RideColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
