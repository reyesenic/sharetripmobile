import 'package:flutter/material.dart';

class RideStatusScreen extends StatefulWidget {
  const RideStatusScreen({super.key});

  @override
  State<RideStatusScreen> createState() => _RideStatusScreenState();
}

class _RideStatusScreenState extends State<RideStatusScreen> {
  final List<String> _status = [
    'Requested',
    'Accepted',
    'Driver Arriving',
    'Picked Up',
    'In Progress',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your trip is on the way',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Driver: Ramon Dela Rosa • ETA: 4 mins'),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _status.length,
                itemBuilder: (context, index) {
                  final item = _status[index];
                  final active = index <= 2;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Icon(
                            active ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: active ? const Color(0xFF6C2BD9) : Colors.grey,
                          ),
                          if (index < _status.length - 1)
                            Container(
                              width: 2,
                              height: 28,
                              color: active ? const Color(0xFF6C2BD9) : Colors.grey,
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/rate_ride'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C2BD9),
                ),
                child: const Text(
                  'Rate Ride',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
