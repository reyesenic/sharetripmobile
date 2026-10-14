import 'package:flutter/material.dart';

class CurrentRideCard extends StatelessWidget {
  const CurrentRideCard({super.key});

  static const Color _bg = Color(0xFF4F3AF7);
  static const Color _tile = Color(0x26FFFFFF); // white @ ~15%
  static const Color _muted = Color(0xB3FFFFFF); // white @ ~70%

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: badge + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _tile,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'CURRENT RIDE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Color(0xFF1E9BD7),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Driver Arriving',
                    style: TextStyle(color: _muted, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Driver row
          const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF8B5CF6),
                child: Text(
                  'AS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alex Santos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.verified_user_outlined,
                          size: 16, color: _muted),
                      SizedBox(width: 6),
                      Text(
                        'Verified Student Driver',
                        style: TextStyle(color: _muted, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Info grid
          const Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Vehicle',
                  value: 'Toyota Vios · White · ABC 1234',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _InfoTile(
                  label: 'Route',
                  value: 'Campus → Town Center',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Pickup',
                  value: 'Main Campus Gate',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _InfoTile(
                  label: 'Departure',
                  value: '5:30 PM · 1 passenger',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Track Ride',
                  filled: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  label: 'View Details',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  label: 'Contact Driver',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: CurrentRideCard._tile,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: CurrentRideCard._muted, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? Colors.white : CurrentRideCard._tile,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  color: filled ? CurrentRideCard._bg : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}