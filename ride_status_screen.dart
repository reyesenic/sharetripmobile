import 'package:flutter/material.dart';
import 'rate_ride_screen.dart';

// ==========================================
// PANEL 10.1 & 10.2: RIDE STATUS & LIVE GPS TRACKING
// ==========================================
class RideStatusScreen extends StatefulWidget {
  const RideStatusScreen({super.key});

  @override
  State<RideStatusScreen> createState() => _RideStatusScreenState();
}

class _RideStatusScreenState extends State<RideStatusScreen> {
  int _currentStep = 1; // 0: Requested, 1: Accepted, 2: Driver Arriving, 3: Picked Up, 4: In Progress, 5: Completed

  final List<Map<String, dynamic>> _statusSteps = [
    {'title': 'Requested', 'subtitle': '6:28 AM'},
    {'title': 'Accepted', 'subtitle': 'Now'},
    {'title': 'Driver Arriving', 'subtitle': 'Est. 4 min'},
    {'title': 'Picked Up', 'subtitle': 'Pending'},
    {'title': 'In Progress', 'subtitle': 'Pending'},
    {'title': 'Completed', 'subtitle': 'Pending'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle Details', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('LAG-7841', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Vehicle Details Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.two_wheeler, color: Color(0xFFD97706), size: 30),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('Tricycle', style: TextStyle(color: Color(0xFFD97706), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 4),
                          const Text('Kawasaki Tricycle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildStatusBadge('Available', Colors.green, Colors.green.shade50),
                              const SizedBox(width: 6),
                              _buildStatusBadge('Verified Driver', const Color(0xFF059669), const Color(0xFFD1FAE5)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Driver Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DRIVER', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.amber.shade700,
                          child: const Text('RD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ramon Dela Rosa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          style: IconButton.styleFrom(backgroundColor: const Color(0xFFF3E8FF)),
                          icon: const Icon(Icons.share_outlined, color: Color(0xFF6C2BD9), size: 18),
                          onPressed: () {},
                        ),
                        IconButton(
                          style: IconButton.styleFrom(backgroundColor: const Color(0xFFFEE2E2)),
                          icon: const Icon(Icons.phone_outlined, color: Colors.redAccent, size: 18),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Route Summary
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ROUTE', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFF6C2BD9), size: 20),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pickup', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                            const Text('Bitin Junction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 9.0),
                      child: Container(height: 16, width: 2, color: Colors.grey.shade300),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.flag_outlined, color: Colors.green, size: 20),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Destination', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                            const Text('CMDI Main Campus Gate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Metrics Row (Fare, Seats, ETA)
            Row(
              children: [
                _buildMetricCard('Fare', '₱15', const Color(0xFF6C2BD9)),
                const SizedBox(width: 8),
                _buildMetricCard('Seats', '2 left', Colors.blue.shade700),
                const SizedBox(width: 8),
                _buildMetricCard('ETA', '4 min', Colors.teal.shade600),
              ],
            ),
            const SizedBox(height: 16),

            // PANEL 10.2: REAL-TIME GPS MAP CONTAINER
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Stack(
                children: [
                  // Map Grid Lines Mock
                  CustomPaint(
                    size: Size.infinite,
                    painter: MapGridPainter(),
                  ),
                  // Location Pin - User
                  Positioned(
                    top: 30,
                    left: 40,
                    child: _buildMapBadge('Your Location', Icons.location_on, const Color(0xFF6C2BD9)),
                  ),
                  // Pin - Destination
                  Positioned(
                    bottom: 60,
                    left: 90,
                    child: _buildMapBadge('Destination', Icons.flag, Colors.green),
                  ),
                  // Pin - Driver
                  Positioned(
                    top: 70,
                    right: 40,
                    child: _buildMapBadge('Driver', Icons.two_wheeler, const Color(0xFFD97706)),
                  ),
                  // Bottom Map Overlay Banner
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Your request is being processed.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('Estimated arrival: 4 minutes', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF6C2BD9)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onPressed: () {},
                            child: const Text('Center Map', style: TextStyle(color: Color(0xFF6C2BD9), fontSize: 12)),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // PANEL 10.2: RIDE STATUS TIMELINE
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('RIDE STATUS', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    const SizedBox(height: 16),
                    ...List.generate(_statusSteps.length, (index) {
                      final isCompleted = index < _currentStep;
                      final isCurrent = index == _currentStep;
                      return _buildTimelineStep(
                        stepIndex: index + 1,
                        title: _statusSteps[index]['title'],
                        subtitle: _statusSteps[index]['subtitle'],
                        isCompleted: isCompleted,
                        isCurrent: isCurrent,
                        isLast: index == _statusSteps.length - 1,
                      );
                    }),
                    const SizedBox(height: 16),
                    // Safety Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.add_circle_outline, color: Colors.redAccent, size: 16),
                            label: const Text('SOS', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.share, color: Colors.grey, size: 16),
                            label: const Text('Share Ride', style: TextStyle(color: Colors.black87, fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.amber),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 16),
                            label: const Text('Report', style: TextStyle(color: Colors.amber, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Quick step increment button for demo purposes
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C2BD9)),
                        onPressed: () {
                          if (_currentStep < _statusSteps.length - 1) {
                            setState(() => _currentStep++);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const RateRideScreen()),
                            );
                          }
                        },
                        child: Text(
                          _currentStep < _statusSteps.length - 1 ? 'Simulate Next Step' : 'Finish Ride & Rate',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMetricCard(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildMapBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required int stepIndex,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFF3E8FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? Colors.green.shade100
                  : isCurrent
                      ? const Color(0xFF6C2BD9)
                      : Colors.grey.shade200,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.green)
                  : Text(
                      '$stepIndex',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? Colors.white : Colors.grey,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isCurrent || isCompleted ? FontWeight.bold : FontWeight.normal,
                color: isCurrent
                    ? const Color(0xFF6C2BD9)
                    : isCompleted
                        ? Colors.black
                        : Colors.grey,
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent ? const Color(0xFF6C2BD9) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Map Grid Mock
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo.shade50
      ..strokeWidth = 1.0;

    const step = 25.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}