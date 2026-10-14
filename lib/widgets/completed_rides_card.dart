 import 'package:flutter/material.dart';

class CompletedRideCard extends StatelessWidget {
  final String vehicle;
  final String dateTime;
  final String fare;
  final String from;
  final String to;
  final String driverName;
  final String driverInitials;
  final double rating;
  final VoidCallback? onViewDetails;

  const CompletedRideCard({
    super.key,
    required this.vehicle,
    required this.dateTime,
    required this.fare,
    required this.from,
    required this.to,
    required this.driverName,
    required this.driverInitials,
    required this.rating,
    this.onViewDetails,
  });

  static const Color _purple = Color(0xFF4F3AF7);
  static const Color _textDark = Color(0xFF1F2937);
  static const Color _textGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.electric_rickshaw,
                    color: Color(0xFFF59E0B), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateTime,
                      style: const TextStyle(fontSize: 12, color: _textGrey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    fare,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _purple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: _purple),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  from,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: _textGrey),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.chevron_right,
                    size: 16, color: Color(0xFFD1D5DB)),
              ),
              const Icon(Icons.flag_outlined,
                  size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  to,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: _textGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFF59E0B),
                child: Text(
                  driverInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(driverName,
                  style: const TextStyle(fontSize: 13, color: _textGrey)),
              const SizedBox(width: 10),
              const Icon(Icons.star_border_rounded,
                  size: 18, color: Color(0xFFF59E0B)),
              const SizedBox(width: 2),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onViewDetails ?? () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: _textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}