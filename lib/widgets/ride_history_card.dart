import 'package:flutter/material.dart';

enum RideStatus { completed, cancelled }

class RideHistoryItem {
  final String date;
  final String origin;
  final String destination;
  final String driverName;
  final String vehicle;
  final String time;
  final int fare;
  final RideStatus status;
  final Color avatarColor;

  const RideHistoryItem({
    required this.date,
    required this.origin,
    required this.destination,
    required this.driverName,
    required this.vehicle,
    required this.time,
    required this.fare,
    required this.status,
    required this.avatarColor,
  });

  String get initials {
    final parts = driverName.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class RideHistoryCard extends StatelessWidget {
  final RideHistoryItem ride;
  final VoidCallback? onViewDetails;

  const RideHistoryCard({
    super.key,
    required this.ride,
    this.onViewDetails,
  });

  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF9CA3AF);
  static const Color _green = Color(0xFF059669);
  static const Color _red = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    final isCompleted = ride.status == RideStatus.completed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ride.date,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _textGrey,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          _buildRoute(),
          const SizedBox(height: 12),
          _buildDriver(),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 2,
            children: [
              Text('Vehicle: ${ride.vehicle}',
                  style: const TextStyle(fontSize: 12, color: _textGrey)),
              Text('Time: ${ride.time}',
                  style: const TextStyle(fontSize: 12, color: _textGrey)),
              Text('Fare: ₱${ride.fare}',
                  style: const TextStyle(fontSize: 12, color: _textGrey)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(isCompleted ? Icons.check : Icons.close,
                  size: 14, color: isCompleted ? _green : _red),
              const SizedBox(width: 4),
              Text(
                isCompleted ? 'Completed' : 'Cancelled',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isCompleted ? _green : _red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                foregroundColor: _textDark,
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoute() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.location_on_outlined,
              size: 16, color: Color(0xFF8B5CF6)),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            ride.origin,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.chevron_right, size: 16, color: _textGrey),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.flag_outlined, size: 16, color: _green),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            ride.destination,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriver() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: ride.avatarColor,
          child: Text(
            ride.initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ride.driverName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 2),
            const Row(
              children: [
                Icon(Icons.verified_user_outlined, size: 13, color: _green),
                SizedBox(width: 4),
                Text(
                  'Verified Student Driver',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
