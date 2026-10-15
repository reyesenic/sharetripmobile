import 'package:flutter/material.dart';
import '../widgets/available_rides.dart';
import '../widgets/completed_rides_card.dart';
import '../widgets/current_ride_card.dart';
import '../widgets/upcoming_ride_card.dart';

// ======================= MODELS =======================

class ActiveRide {
  final String driverName;
  final String driverStatus; // "Driver Arriving"
  final String vehicle; // Toyota Vios · White · ABC 1234
  final String route; // Campus → Town Center
  final String pickup;
  final String departure; // 5:30 PM · 1 passenger

  const ActiveRide({
    required this.driverName,
    required this.driverStatus,
    required this.vehicle,
    required this.route,
    required this.pickup,
    required this.departure,
  });
}

class UpcomingRide {
  final String route; // Campus → Residential Area
  final String date; // September 22, 2026
  final String time; // 5:00 PM
  final String driverName;
  final String vehicle;
  final double fare;

  const UpcomingRide({
    required this.route,
    required this.date,
    required this.time,
    required this.driverName,
    required this.vehicle,
    required this.fare,
  });
}

class CompletedRide {
  final String vehicleName;
  final String dateTime; // Sep 20, 2026 · 6:20 AM
  final String pickup;
  final String destination;
  final String driverName;
  final double rating;
  final double fare;
  final IconData icon;
  final Color color;
  final Color bg;

  const CompletedRide({
    required this.vehicleName,
    required this.dateTime,
    required this.pickup,
    required this.destination,
    required this.driverName,
    required this.rating,
    required this.fare,
    required this.icon,
    required this.color,
    required this.bg,
  });
}

// ======================= SAMPLE DATA =======================
// Replace with your Firebase / API data.

const _sampleActive = [
  ActiveRide(
    driverName: 'Alex Santos',
    driverStatus: 'Driver Arriving',
    vehicle: 'Toyota Vios · White · ABC 1234',
    route: 'Campus → Town Center',
    pickup: 'Main Campus Gate',
    departure: '5:30 PM · 1 passenger',
  ),
];

const _sampleUpcoming = [
  UpcomingRide(
    route: 'Campus → Residential Area',
    date: 'September 22, 2026',
    time: '5:00 PM',
    driverName: 'Maria Santos',
    vehicle: 'School Shuttle',
    fare: 30,
  ),
];

const _sampleCompleted = [
  CompletedRide(
    vehicleName: 'Kawasaki Tricycle',
    dateTime: 'Sep 20, 2026 · 6:20 AM',
    pickup: 'Bitin Junction',
    destination: 'CMDI Main Campus Gate',
    driverName: 'Ramon Dela Rosa',
    rating: 4.8,
    fare: 15,
    icon: Icons.electric_rickshaw,
    color: Color(0xFFF59E0B),
    bg: Color(0xFFFFF4E5),
  ),
  CompletedRide(
    vehicleName: 'Toyota Hiace Commuter',
    dateTime: 'Sep 19, 2026 · 6:05 AM',
    pickup: 'Maitim Rotunda',
    destination: 'CMDI Main Campus Gate',
    driverName: 'Ligaya Reyes',
    rating: 4.9,
    fare: 18,
    icon: Icons.directions_bus_outlined,
    color: Color(0xFF10B981),
    bg: Color(0xFFE6F8F1),
  ),
  CompletedRide(
    vehicleName: 'Toyota Hi-Ace',
    dateTime: 'Sep 18, 2026 · 5:55 AM',
    pickup: 'Tranca Waiting Shed',
    destination: 'CMDI Main Campus Gate',
    driverName: 'Sherwin Manalo',
    rating: 4.9,
    fare: 20,
    icon: Icons.airport_shuttle_outlined,
    color: Color(0xFF4F36F5),
    bg: Color(0xFFEEF0FF),
  ),
];
// ======================= SCREEN =======================

class MyRidesScreen extends StatefulWidget {
  final List<ActiveRide> activeRides;
  final List<UpcomingRide> upcomingRides;
  final List<CompletedRide> completedRides;

  const MyRidesScreen({
    super.key,
    this.activeRides = _sampleActive,
    this.upcomingRides = _sampleUpcoming,
    this.completedRides = _sampleCompleted,
  });

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  static const _bg = Color(0xFFF7F8FC);
  static const _tabs = ['Active', 'Upcoming', 'Completed'];

  int _tab = 0; // Active first
  late List<UpcomingRide> _upcoming;

  @override
  void initState() {
    super.initState();
    _upcoming = List.of(widget.upcomingRides);
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _cancelRide(UpcomingRide ride) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel ride?'),
        content: Text('Cancel your ride "${ride.route}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel Ride',
                style: TextStyle(color: Color(0xFFE11D48))),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _upcoming.remove(ride));
      _toast('Ride cancelled');
      // TODO: update the ride in Firebase / backend here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _header(context),
          Expanded(child: _content()),
        ],
      ),
    );
  }

// ---------------- HEADER + TABS ----------------
  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 28, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/dashboard',
                  (_) => false,
                ),
                tooltip: 'Back',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF3F4F6),
                  fixedSize: const Size(40, 40),
                  padding: EdgeInsets.zero,
                ),
                icon: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Rides',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: RideColors.dark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage your current and upcoming trips',
                      style: TextStyle(fontSize: 14, color: RideColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  Expanded(child: _tabButton(i)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(int i) {
    final selected = _tab == i;
    return GestureDetector(
      onTap: () => setState(() => _tab = i),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          _tabs[i],
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF4F36F5) : RideColors.label,
          ),
        ),
      ),
    );
  }

  // ---------------- CONTENT ----------------
  Widget _content() {
    switch (_tab) {
      case 0:
        return _list(
          count: widget.activeRides.isEmpty ? 0 : 1,
          emptyText: 'No active rides right now',
          builder: (_) => const CurrentRideCard(),
        );
      case 1:
        return _list(
          count: _upcoming.length,
          emptyText: 'No upcoming rides',
          builder: (i) {
            final ride = _upcoming[i];
            return UpcomingRideCard(
              route: ride.route,
              date: ride.date,
              time: ride.time,
              driverName: ride.driverName,
              vehicle: ride.vehicle,
              fare: '₱${ride.fare.toStringAsFixed(0)}',
              onViewDetails: () => _toast('View details'),
              onCancel: () => _cancelRide(ride),
            );
          },
        );
      default:
        return _list(
          count: widget.completedRides.length,
          emptyText: 'No completed rides yet',
          builder: (i) {
            final ride = widget.completedRides[i];
            return CompletedRideCard(
              vehicle: ride.vehicleName,
              dateTime: ride.dateTime,
              fare: '₱${ride.fare.toStringAsFixed(0)}',
              from: ride.pickup,
              to: ride.destination,
              driverName: ride.driverName,
              driverInitials: _rideInitials(ride.driverName),
              rating: ride.rating,
              onViewDetails: () => _toast('View details'),
            );
          },
        );
    }
  }

  Widget _list({
    required int count,
    required String emptyText,
    required Widget Function(int) builder,
  }) {
    if (count == 0) {
      return Center(
        child: Text(emptyText,
            style: const TextStyle(fontSize: 15, color: RideColors.grey)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => builder(i),
    );
  }
}

String _rideInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return (parts.first[0] + parts.last[0]).toUpperCase();
}
