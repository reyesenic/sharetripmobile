import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/safety_card.dart';
import '../widgets/safety_header_widgets.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _callEmergency(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: '911');
    final ok = await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the phone dialer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: SafeArea(
        child: Column(
          children: [
            const SafetyHeader(
              title: 'Emergency Assistance',
              subtitle: 'Get help and access important ride information',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SafetyCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFDE8EC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.help_outline_rounded,
                              color: Color(0xFFE11D48), size: 22),
                        ),
                        const SizedBox(height: 12),
                        const Text('Need emergency help?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        const Text(
                          'ShareTrip does not automatically contact emergency services. The SOS button opens your phone dialer for 911.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () => _callEmergency(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE11D48),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('SOS — Call 911',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SafetyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CURRENT RIDE DETAILS',
                            style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: Color(0xFF6B7280))),
                        SizedBox(height: 10),
                        Text('No active ride information is available.',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF4B5563))),
                      ],
                    ),
                  ),
                  const SafetyCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _ContactTile(
                          icon: Icons.phone_outlined,
                          iconColor: Color(0xFFE11D48),
                          iconBg: Color(0xFFFDE8EC),
                          title: 'National Emergency Hotline',
                          subtitle: '911',
                        ),
                        Divider(height: 1, color: Color(0xFFF1F2F6)),
                        _ContactTile(
                          icon: Icons.person_outline,
                          iconColor: Color(0xFF4F46E5),
                          iconBg: Color(0xFFEEF0FB),
                          title: 'Trusted contact',
                          subtitle: 'No trusted contact added',
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

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;

  const _ContactTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }
}
