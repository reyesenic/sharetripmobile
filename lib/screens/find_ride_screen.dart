import 'package:flutter/material.dart';
import '../widgets/available_rides.dart';

class FindRideScreen extends StatefulWidget {
  final dynamic ride;

  const FindRideScreen({super.key, this.ride});

  @override
  State<FindRideScreen> createState() => _FindRideScreenState();
}

class _FindRideScreenState extends State<FindRideScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final rides = sampleRides.where((ride) {
      if (!ride.available || ride.seatsLeft <= 0) return false;
      if (query.isEmpty) return true;
      return ride.vehicleName.toLowerCase().contains(query) ||
          ride.vehicleType.toLowerCase().contains(query) ||
          ride.driverName.toLowerCase().contains(query) ||
          ride.pickup.toLowerCase().contains(query) ||
          ride.destination.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        title: const Text('Find a Ride'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search pickup, destination, vehicle or driver',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AVAILABLE RIDES NEAR YOU',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: RideColors.label,
                  ),
                ),
                Text(
                  '${rides.length} available',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: RideColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: rides.isEmpty
                  ? const Center(child: Text('No rides found'))
                  : ListView.builder(
                      itemCount: rides.length,
                      itemBuilder: (context, index) {
                        final ride = rides[index];
                        return RideCard(
                          ride: ride,
                          onRequest: () => Navigator.pushNamed(
                            context,
                            '/vehicle_details',
                            arguments: ride.toRouteArguments(),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
