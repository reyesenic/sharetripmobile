import 'package:flutter/material.dart';

class UpcomingRideCard extends StatelessWidget {
  final String route;
  final String date;
  final String time;
  final String driverName;
  final String vehicle;
  final String fare;
  final VoidCallback? onViewDetails;
  final VoidCallback? onCancel;

  const UpcomingRideCard({
    super.key,
    required this.route,
    required this.date,
    required this.time,
    required this.driverName,
    required this.vehicle,
    required this.fare,
    this.onViewDetails,
    this.onCancel,
  });

  static const Color _textDark = Color(0xFF1F2937);
  static const Color _textGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    const detailStyle = TextStyle(fontSize: 13, color: _textGrey);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  route,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Upcoming',
                  style: TextStyle(
                    color: Color(0xFF0284C7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              Text(date, style: detailStyle),
              Text(time, style: detailStyle),
              Text('Driver: $driverName', style: detailStyle),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              Text('Vehicle: $vehicle', style: detailStyle),
              Text('Fare: $fare', style: detailStyle),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _RideButton(
                  label: 'View Details',
                  onTap: onViewDetails ?? () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RideButton(
                  label: 'Cancel Ride',
                  textColor: const Color(0xFFE11D48),
                  borderColor: const Color(0xFFFBCFE8),
                  bgColor: const Color(0xFFFFF1F5),
                  onTap: onCancel ?? () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RideButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color borderColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _RideButton({
    required this.label,
    required this.onTap,
    this.textColor = const Color(0xFF1F2937),
    this.borderColor = const Color(0xFFE5E7EB),
    this.bgColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}