
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
import 'package:flutter/material.dart';
import '../widgets/available_rides.dart';

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

String _initials(String name) {
  final p = name.trim().split(' ');
  if (p.length == 1) return p.first[0].toUpperCase();
  return (p.first[0] + p.last[0]).toUpperCase();
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

  void _toast(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

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
          const Text(
            'My Rides',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: RideColors.dark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage your current and upcoming trips',
            style: TextStyle(fontSize: 14, color: RideColors.grey),
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
          count: widget.activeRides.length,
          emptyText: 'No active rides right now',
          builder: (i) => _activeCard(widget.activeRides[i]),
        );
      case 1:
        return _list(
          count: _upcoming.length,
          emptyText: 'No upcoming rides',
          builder: (i) => _upcomingCard(_upcoming[i]),
        );
      default:
        return _list(
          count: widget.completedRides.length,
          emptyText: 'No completed rides yet',
          builder: (i) => _completedCard(widget.completedRides[i]),
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

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      );

  // ================= ACTIVE CARD =================
  Widget _activeCard(ActiveRide r) {
    const purple = Color(0xFF4F36F5);
    final soft = Colors.white.withValues(alpha: 0.14);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: purple,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'CURRENT RIDE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFF2DD4BF)),
                  const SizedBox(width: 6),
                  Text(
                    r.driverStatus,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                child: Text(
                  _initials(r.driverName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.driverName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.verified_user_outlined,
                          size: 13, color: Colors.white.withValues(alpha: 0.75)),
                      const SizedBox(width: 5),
                      Text(
                        'Verified Student Driver',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _infoTile('Vehicle', r.vehicle, soft)),
              const SizedBox(width: 10),
              Expanded(child: _infoTile('Route', r.route, soft)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _infoTile('Pickup', r.pickup, soft)),
              const SizedBox(width: 10),
              Expanded(child: _infoTile('Departure', r.departure, soft)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _activeButton(
                  'Track Ride',
                  bg: Colors.white,
                  fg: purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const _TrackPlaceholder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _activeButton(
                  'View Details',
                  bg: Colors.white.withValues(alpha: 0.2),
                  fg: Colors.white,
                  onTap: () => _toast('View details'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _activeButton(
                  'Contact Driver',
                  bg: Colors.white.withValues(alpha: 0.2),
                  fg: Colors.white,
                  onTap: () => _toast('Contacting ${r.driverName}…'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
Widget _infoTile(String label, String value, Color bg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeButton(String label,
      {required Color bg, required Color fg, required VoidCallback onTap}) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: FittedBox(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }


  // ================= UPCOMING CARD =================
  Widget _upcomingCard(UpcomingRide r) {
    const blue = Color(0xFF0284C7);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  r.route,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: RideColors.dark,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Upcoming',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              _meta(r.date),
              _meta(r.time),
              _meta('Driver: ${r.driverName}'),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              _meta('Vehicle: ${r.vehicle}'),
              _meta('Fare: ₱${r.fare.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _outlineButton(
                  'View Details',
                  fg: RideColors.dark,
                  border: const Color(0xFFE5E7EB),
                  onTap: () => _toast('View details'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _outlineButton(
                  'Cancel Ride',
                  fg: const Color(0xFFE11D48),
                  border: const Color(0xFFF8C9D4),
                  onTap: () => _cancelRide(r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _meta(String text) => Text(
        text,
        style: const TextStyle(fontSize: 13, color: RideColors.label),
      );

  Widget _outlineButton(String label,
      {required Color fg,
      required Color border,
      required VoidCallback onTap}) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: fg,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }

  // ================= COMPLETED CARD =================
  Widget _completedCard(CompletedRide r) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: r.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(r.icon, size: 22, color: r.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.vehicleName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: RideColors.dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      r.dateTime,
                      style: const TextStyle(
                          fontSize: 13, color: RideColors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₱${r.fare.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4F36F5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: RideColors.greenBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: RideColors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: RideColors.primary),
              Text(r.pickup,
                  style: const TextStyle(
                      fontSize: 13, color: RideColors.label)),
              const Icon(Icons.chevron_right_rounded,
                  size: 16, color: RideColors.grey),
              const Icon(Icons.flag_outlined,
                  size: 16, color: RideColors.green),
              Text(r.destination,
                  style: const TextStyle(
                      fontSize: 13, color: RideColors.label)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: r.color,
                child: Text(
                  _initials(r.driverName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                r.driverName,
                style: const TextStyle(
                    fontSize: 14, color: RideColors.label),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star_border_rounded,
                  size: 17, color: RideColors.orange),
              const SizedBox(width: 3),
              Text(
                r.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: RideColors.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: _outlineButton(
              'View Details',
              fg: RideColors.dark,
              border: const Color(0xFFE5E7EB),
              onTap: () => _toast('View details'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Temporary screen for "Track Ride".
/// Replace the Navigator.push in _activeCard with:
///   RideStatusScreen(ride: ..., initialStage: RideStage.driverArriving)
class _TrackPlaceholder extends StatelessWidget {
  const _TrackPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Ride')),
      body: const Center(child: Text('Connect RideStatusScreen here')),
    );
  }
}


                                                                   