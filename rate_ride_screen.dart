import 'package:flutter/material.dart';
class RateRideScreen extends StatefulWidget {
  const RateRideScreen({super.key});

  @override
  State<RateRideScreen> createState() => _RateRideScreenState();
}

class _RateRideScreenState extends State<RateRideScreen> {
  int _selectedRating = 0;
  final TextEditingController _experienceController = TextEditingController();

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
        title: const Text('Rate Your Ride', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Green Checkmark Icon Container
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 44, color: Color(0xFF166534)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ride Completed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'How was your ride with Ramon Dela Rosa?',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Interactive Star Rating Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  iconSize: 38,
                  icon: Icon(
                    starIndex <= _selectedRating ? Icons.star : Icons.star_border,
                    color: starIndex <= _selectedRating ? Colors.amber : Colors.grey.shade300,
                  ),
                  onPressed: () => setState(() => _selectedRating = starIndex),
                );
              }),
            ),
            const SizedBox(height: 28),

            // Interactive Text Area: Share experience
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _experienceController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Share your experience (optional)...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Rating Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedRating > 0 ? const Color(0xFF6C2BD9) : const Color(0xFFC4B5FD),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you for your feedback!')),
                  );
                  Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
                },
                child: const Text('Submit Rating', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),

            // Skip for Now Button
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
              },
              child: const Text('Skip for now', style: TextStyle(color: Colors.grey, fontSize: 14)),
            )
          ],
        ),
      ),
    );
  }
}