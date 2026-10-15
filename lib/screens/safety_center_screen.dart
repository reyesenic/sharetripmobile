import 'package:flutter/material.dart';
import 'emergency_screen.dart';
import 'report_problem_screen.dart';
import 'ride_tracking_screen.dart';

class SafetyCenterScreen extends StatelessWidget {
  const SafetyCenterScreen({super.key});

  static const Color _bg = Color(0xFFF7F8FD);
  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);
  static const Color _primary = Color(0xFF4F46E5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      'SAFETY TOOLS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: _textGrey,
                      ),
                    ),
                  ),
                  _SafetyToolCard(
                    icon: Icons.fact_check_outlined,
                    iconColor: const Color(0xFF059669),
                    iconBg: const Color(0xFFE6F8F0),
                    title: 'Verified Drivers',
                    description:
                        'Driver identity, student status, vehicle details, and plate information are reviewed before a ride is listed.',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Driver verification details are available on each ride listing.',
                        ),
                      ),
                    ),
                  ),
                  _SafetyToolCard(
                    icon: Icons.share_outlined,
                    iconColor: const Color(0xFF0284C7),
                    iconBg: const Color(0xFFE8F4FD),
                    title: 'Ride Tracking & Sharing',
                    description:
                        'Follow your trip progress and share your ride details with someone you trust.',
                    onTap: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const RideTrackingScreen(),
                      ),
                    ),
                  ),
                  _SafetyToolCard(
                    icon: Icons.help_outline_rounded,
                    iconColor: const Color(0xFFBE123C),
                    iconBg: const Color(0xFFFDE8EC),
                    title: 'Emergency / SOS',
                    description:
                        'Access emergency assistance and your trip information when you need help.',
                    onTap: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const EmergencyScreen(),
                      ),
                    ),
                  ),
                  _SafetyToolCard(
                    icon: Icons.flag_outlined,
                    iconColor: const Color(0xFFD97706),
                    iconBg: const Color(0xFFFEF5DC),
                    title: 'Report a Driver or Ride',
                    description:
                        'Report unsafe behavior, vehicle concerns, incorrect ride details, or another safety issue.',
                    onTap: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const ReportProblemScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildGuidelines(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            customBorder: const CircleBorder(),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F2F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: _textDark),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Center',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your safety matters on every trip.',
                  style: TextStyle(fontSize: 12.5, color: _textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelines() {
    const guidelines = [
      'Verify the driver\'s identity and vehicle before boarding.',
      'Confirm the pickup location and destination.',
      'Share ride details with someone you trust.',
      'Remain aware of your surroundings.',
      'Report suspicious behavior or unsafe conditions.',
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_user_outlined, size: 18, color: _primary),
              SizedBox(width: 8),
              Text(
                'Safety Guidelines',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...guidelines.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEF0FB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 13, color: _primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

class _SafetyToolCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _SafetyToolCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: SafetyCenterScreen._cardDecoration(),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 20, color: iconColor),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: SafetyCenterScreen._textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: SafetyCenterScreen._textGrey,
                      ),
                    ),
                  ],
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Color(0xFFB0B5C0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
