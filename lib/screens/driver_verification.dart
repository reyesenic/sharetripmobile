import 'package:flutter/material.dart';
import '../widgets/safety_card.dart';
import '../widgets/safety_header_widgets.dart';

class DriverVerificationScreen extends StatelessWidget {
  // Sample data. Replace with real driver data passed in via constructor.
  final String driverName;
  final String initials;
  final double rating;
  final String vehicleName;
  final String vehicleType;
  final String plateNumber;

  const DriverVerificationScreen({
    super.key,
    this.driverName = 'Ramon Dela Rosa',
    this.initials = 'RD',
    this.rating = 4.8,
    this.vehicleName = 'Kawasaki Tricycle',
    this.vehicleType = 'Tricycle · Yellow',
    this.plateNumber = 'LAG-7841',
  });

  static const _green = Color(0xFF059669);
  static const _greenBg = Color(0xFFE6F8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: SafeArea(
        child: Column(
          children: [
            const SafetyHeader(
              title: 'Driver Verification Details',
              subtitle: 'Passenger-safe driver and vehicle information',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Driver card
                  SafetyCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFFF59E0B),
                          child: Text(initials,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(driverName,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _greenBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified_outlined,
                                        size: 12, color: _green),
                                    SizedBox(width: 4),
                                    Text('Verified Driver',
                                        style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w600,
                                            color: _green)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 14, color: Color(0xFFF59E0B)),
                                  const SizedBox(width: 3),
                                  Text(rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(width: 6),
                                  const Text('Passenger reviews',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF6B7280))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Vehicle details
                  SafetyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('VEHICLE DETAILS',
                            style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: Color(0xFF6B7280))),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF5DC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.electric_rickshaw,
                                  size: 20, color: Color(0xFFD97706)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vehicleName,
                                    style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(vehicleType,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF6B7280))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoBox(
                                label: 'Plate number',
                                value: plateNumber,
                                bg: const Color(0xFFF7F8FA),
                                labelColor: const Color(0xFF9CA3AF),
                                valueColor: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: _InfoBox(
                                label: 'Verification',
                                value: 'Verified',
                                bg: _greenBg,
                                labelColor: _green,
                                valueColor: Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Verification checks
                  const SafetyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.verified_user_outlined,
                                size: 16, color: _green),
                            SizedBox(width: 8),
                            Text('Verification checks',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                        SizedBox(height: 12),
                        _CheckRow('Student driver status confirmed'),
                        _CheckRow('Vehicle details reviewed'),
                        _CheckRow('Plate information matched'),
                        SizedBox(height: 4),
                        Text(
                          'Private identity documents are never shown to passengers.',
                          style: TextStyle(
                              fontSize: 10.5, color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color bg;
  final Color labelColor;
  final Color valueColor;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.bg,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: labelColor)),
          const SizedBox(height: 3),
          Text(value,
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: valueColor)),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String text;
  const _CheckRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 15, color: Color(0xFF059669)),
          const SizedBox(width: 10),
          Text(text,
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF4B5563))),
        ],
      ),
    );
  }
}
