import 'package:flutter/material.dart';
import '../widgets/available_rides.dart';
import '../widgets/navigation_bar_card.dart';
import '../widgets/recommended_routes_section.dart';
import '../widgets/safety_section.dart';
import 'safety_center_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;

  const DashboardScreen({super.key, this.userName = 'Student'});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentNavIndex = 0;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onNavTap(int index) async {
    if (index == 0) {
      setState(() => _currentNavIndex = 0);
      return;
    }

    final String? route = switch (index) {
      1 => '/find_ride',
      2 => '/my_rides',
      3 => '/notifications',
      4 => '/profile',
      _ => null,
    };

    if (route == null) {
      return;
    }

    setState(() => _currentNavIndex = index);
    await Navigator.pushNamed(context, route);
    if (mounted) {
      setState(() => _currentNavIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(
                userName: widget.userName,
                onSearchTap: () => Navigator.pushNamed(context, '/find_ride'),
                onNotificationTap: () =>
                    Navigator.pushNamed(context, '/notifications'),
              ),
              const SizedBox(height: 24),
              QuickActionsSection(
                onFindRideTap: () => Navigator.pushNamed(context, '/find_ride'),
                onMyRidesTap: () => Navigator.pushNamed(context, '/my_rides'),
                onSavedPlacesTap: () =>
                    Navigator.pushNamed(context, '/saved_places'),
                onRideHistoryTap: () =>
                    Navigator.pushNamed(context, '/ride_history'),
              ),
              const SizedBox(height: 20),
              AvailableRidesSection(
                rides: sampleRides,
                maxItems: 2,
                onViewAll: () => Navigator.pushNamed(context, '/find_ride'),
                onRequest: (ride) => Navigator.pushNamed(
                  context,
                  '/vehicle_details',
                  arguments: ride.toRouteArguments(),
                ),
              ),
              const SizedBox(height: 20),
              RecommendedRoutesSection(
                routes: const [
                  RecommendedRoute(
                    from: 'Bitin',
                    to: 'CMDI Main Campus',
                    subtitle: 'Most popular · ~15 min',
                    icon: Icons.alt_route_rounded,
                    iconColor: Color(0xFF6D5BD0),
                    backgroundColor: Color(0xFFF1EFFC),
                  ),
                  RecommendedRoute(
                    from: 'Maitim',
                    to: 'CMDI Main Campus',
                    subtitle: 'Morning commute · ~20 min',
                    icon: Icons.alt_route_rounded,
                    iconColor: Color(0xFF10B981),
                    backgroundColor: Color(0xFFE6F8F1),
                  ),
                  RecommendedRoute(
                    from: 'CMDI Main Campus',
                    to: 'Bitin',
                    subtitle: 'Afternoon return · ~15 min',
                    icon: Icons.alt_route_rounded,
                    iconColor: Color(0xFFF59E0B),
                    backgroundColor: Color(0xFFFFF4E0),
                  ),
                  RecommendedRoute(
                    from: 'Tranca',
                    to: 'CMDI Bay 2',
                    subtitle: 'Direct route · ~18 min',
                    icon: Icons.alt_route_rounded,
                    iconColor: Color(0xFF8B5CF6),
                    backgroundColor: Color(0xFFF3EFFE),
                  ),
                ],
                onRouteTap: (route) => Navigator.pushNamed(
                  context,
                  '/find_ride',
                  arguments: {'from': route.from, 'to': route.to},
                ),
              ),
              const SizedBox(height: 20),
              SafetySection(
                onSafetyCenterTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const SafetyCenterScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String greeting;
  final TextEditingController? searchController;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final ValueChanged<String>? onSearchChanged;

  const DashboardHeader({
    super.key,
    this.userName = 'Student',
    this.greeting = 'Good morning,',
    this.searchController,
    this.onSearchTap,
    this.onNotificationTap,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF4C35E0),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Where are you going today?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search destination or route...',
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF9CA3AF),
                size: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onSearchTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4C35E0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Search Available Rides',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onFindRideTap;
  final VoidCallback? onMyRidesTap;
  final VoidCallback? onSavedPlacesTap;
  final VoidCallback? onRideHistoryTap;

  const QuickActionsSection({
    super.key,
    this.onFindRideTap,
    this.onMyRidesTap,
    this.onSavedPlacesTap,
    this.onRideHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK ACTIONS',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B7280),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _QuickActionCard(
              title: 'Find a Ride',
              subtitle: 'Search available rides',
              icon: Icons.search,
              iconColor: const Color(0xFF4F46E5),
              backgroundColor: const Color(0xFFEEF2FF),
              onTap: onFindRideTap,
            ),
            _QuickActionCard(
              title: 'My Rides',
              subtitle: 'Current & upcoming',
              icon: Icons.directions_car_outlined,
              iconColor: const Color(0xFF0D9488),
              backgroundColor: const Color(0xFFE8F8F8),
              onTap: onMyRidesTap,
            ),
            _QuickActionCard(
              title: 'Saved Places',
              subtitle: 'Frequent destinations',
              icon: Icons.location_on_outlined,
              iconColor: const Color(0xFFE11D48),
              backgroundColor: const Color(0xFFFDEEEE),
              onTap: onSavedPlacesTap,
            ),
            _QuickActionCard(
              title: 'Ride History',
              subtitle: 'Previous rides',
              icon: Icons.access_time_rounded,
              iconColor: const Color(0xFFD97706),
              backgroundColor: const Color(0xFFFFFBEA),
              onTap: onRideHistoryTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
