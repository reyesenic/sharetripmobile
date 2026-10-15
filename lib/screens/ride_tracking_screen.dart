import 'package:flutter/material.dart';
import '../widgets/safety_card.dart';
import '../widgets/safety_header_widgets.dart';

class RideTrackingScreen extends StatelessWidget {
  /// Called when "View My Rides" is tapped (e.g. switch your bottom nav tab).
  final VoidCallback? onViewMyRides;

  const RideTrackingScreen({super.key, this.onViewMyRides});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: SafeArea(
        child: Column(
          children: [
            const SafetyHeader(
              title: 'Ride Tracking & Sharing',
              subtitle: 'Stay informed and keep someone you trust updated',
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
                            color: Color(0xFFE8F4FD),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on_outlined,
                              color: Color(0xFF0284C7), size: 22),
                        ),
                        const SizedBox(height: 12),
                        const Text('No active ride',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        const Text(
                          'Your ride tracking details will appear here after a ride is confirmed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: onViewMyRides ??
                                () => Navigator.of(context).maybePop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4F46E5),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('View My Rides',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 13)),
                          ),
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
