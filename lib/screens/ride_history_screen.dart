import 'package:flutter/material.dart';
import '../widgets/ride_history_card.dart';
import '../widgets/ride_history_fchips_card.dart';
import '../widgets/ride_history_search_card.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _filterIndex = 0; // 0 = All, 1 = Completed, 2 = Cancelled

  final List<RideHistoryItem> _rides = const [
    RideHistoryItem(
      date: 'SEP 20, 2026',
      origin: 'Bitin Junction',
      destination: 'CMDI Main Campus Gate',
      driverName: 'Ramon Dela Rosa',
      vehicle: 'Kawasaki Tricycle',
      time: '6:20 AM',
      fare: 15,
      status: RideStatus.completed,
      avatarColor: Color(0xFFF59E0B),
    ),
    RideHistoryItem(
      date: 'SEP 19, 2026',
      origin: 'Maitim Rotunda',
      destination: 'CMDI Main Campus Gate',
      driverName: 'Ligaya Reyes',
      vehicle: 'Toyota Hiace Commuter',
      time: '6:05 AM',
      fare: 18,
      status: RideStatus.completed,
      avatarColor: Color(0xFF10B981),
    ),
    RideHistoryItem(
      date: 'SEP 18, 2026',
      origin: 'Tranca Waiting Shed',
      destination: 'CMDI Main Campus Gate',
      driverName: 'Sherwin Manalo',
      vehicle: 'Toyota Hi-Ace',
      time: '5:55 AM',
      fare: 20,
      status: RideStatus.completed,
      avatarColor: Color(0xFF4F46E5),
    ),
  ];

  List<RideHistoryItem> get _filteredRides {
    final q = _query.toLowerCase();
    return _rides.where((r) {
      final matchesFilter = _filterIndex == 0 ||
          (_filterIndex == 1 && r.status == RideStatus.completed) ||
          (_filterIndex == 2 && r.status == RideStatus.cancelled);
      final matchesQuery = q.isEmpty ||
          r.origin.toLowerCase().contains(q) ||
          r.destination.toLowerCase().contains(q) ||
          r.driverName.toLowerCase().contains(q) ||
          r.vehicle.toLowerCase().contains(q) ||
          r.date.toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rides = _filteredRides;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                color: const Color(0xFFF7F8FC),
                child: Column(
                  children: [
                    RideHistorySearchBar(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    RideHistoryFilterChips(
                      selectedIndex: _filterIndex,
                      onSelected: (i) => setState(() => _filterIndex = i),
                    ),
                    Expanded(
                      child: rides.isEmpty
                          ? const Center(child: Text('No rides found'))
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 4, 16, 24),
                              itemCount: rides.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, i) => RideHistoryCard(
                                ride: rides[i],
                                onViewDetails: () {
                                  // TODO: Navigator.pushNamed(context, '/ride_details', arguments: rides[i]);
                                },
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back,
                  size: 20, color: Color(0xFF374151)),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ride History',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'View your previous trips',
                style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}