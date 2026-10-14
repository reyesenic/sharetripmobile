import 'package:flutter/material.dart';

class SafetySection extends StatelessWidget {
  final VoidCallback? onSafetyCenterTap;

  const SafetySection({super.key, this.onSafetyCenterTap});

  static const _features = [
    'Verified Drivers',
    'Ride Tracking',
    'Emergency Assistance',
    'Report a Problem',
  ];

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF4C35E0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE3FB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Safety Matters',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Protected throughout every trip',
                      style: TextStyle(fontSize: 12, color: accent),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 5.2,
            children: [
              for (final feature in _features)
                _SafetyFeatureItem(label: feature),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onSafetyCenterTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Safety Center',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.chevron_right_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyFeatureItem extends StatelessWidget {
  final String label;

  const _SafetyFeatureItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFC7D2FE)),
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 11,
            color: Color(0xFF4C35E0),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3730A3),
            ),
          ),
        ),
      ],
    );
  }
}
