import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentNavIndex = 0;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  // Animation controller for the pulsing skeleton effect
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  // Mock data state for dynamic lists
  List<Map<String, dynamic>> _availableRides = [];
  List<Map<String, dynamic>> _recommendedRoutes = [];

  // -------------------- LIFECYCLE --------------------
  @override
  void initState() {
    super.initState();

    // Pulse animation for skeleton placeholders
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _shimmerAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _loadDashboardData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  // -------------------- DATA FETCHING (LAZY/ASYNC SIMULATION) --------------------
  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    // Simulate API network request delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _availableRides = [
        {
          'vehicle': 'Kawasaki Tricycle',
          'type': 'Tricycle',
          'isVerified': true,
          'status': '● Available',
          'driver': 'Ramon Dela Rosa',
          'initials': 'RD',
          'rating': '4.8',
          'pickup': 'CMDI Main Campus Gate',
          'destination': 'Bitin Junction',
          'seats': '2 left',
          'departs': '4:30 PM',
          'fare': '₱15',
        },
      ];

      _recommendedRoutes = [
        {
          'title': 'Bitin → CMDI Main Campus',
          'subtitle': 'Most popular · ~15 min',
          'bgColor': const Color(0xFFF3E8FF),
          'iconColor': const Color(0xFF6C2BD9),
        },
        {
          'title': 'Maitim → CMDI Main Campus',
          'subtitle': 'Morning commute · ~20 min',
          'bgColor': const Color(0xFFDCFCE7),
          'iconColor': const Color(0xFF166534),
        },
        {
          'title': 'CMDI Main Campus → Bitin',
          'subtitle': 'Afternoon return · ~15 min',
          'bgColor': const Color(0xFFFEF3C7),
          'iconColor': const Color(0xFFB45309),
        },
        {
          'title': 'Tranca → CMDI Bay 2',
          'subtitle': 'Direct route · ~18 min',
          'bgColor': const Color(0xFFF3E8FF),
          'iconColor': const Color(0xFF6C2BD9),
        },
      ];

      _isLoading = false;
    });
  }

  // -------------------- NAVIGATION --------------------
  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;
    setState(() => _currentNavIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/find-ride');
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }

  void _goToFindRide() {
    Navigator.pushReplacementNamed(context, '/find-ride');
  }

  void _onSearch() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _searchController.text.trim().isEmpty
              ? 'Type a destination first'
              : 'Searching "${_searchController.text.trim()}"…',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openSafetyCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Safety Center coming soon')),
    );
  }

  // -------------------- BUILD --------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        color: const Color(0xFF6C2BD9),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header Banner
            SliverToBoxAdapter(child: _buildHeaderBanner()),

            // Quick Actions Section
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'QUICK ACTIONS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: _buildQuickActionsGrid(),
            ),

            // Available Rides Section Header
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AVAILABLE RIDES NEAR YOU',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        fontSize: 11,
                        letterSpacing: 0.8,
                      ),
                    ),
                    if (!_isLoading)
                      GestureDetector(
                        onTap: _goToFindRide,
                        child: Text(
                          '${_availableRides.length} available',
                          style: const TextStyle(
                            color: Color(0xFF6C2BD9),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Available Rides Cards (Lazy List / Skeleton)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              sliver: _isLoading
                  ? SliverToBoxAdapter(child: _buildRideSkeleton())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildRideCard(_availableRides[index]),
                        childCount: _availableRides.length,
                      ),
                    ),
            ),

            // Recommended Routes Header
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'RECOMMENDED ROUTES',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),

            // Recommended Routes Container (Lazy List / Skeleton)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: _isLoading
                      ? _buildRoutesSkeleton()
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recommendedRoutes.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade100),
                          itemBuilder: (context, index) {
                            final route = _recommendedRoutes[index];
                            return _buildRouteItem(
                              route['title'],
                              route['subtitle'],
                              route['bgColor'],
                              route['iconColor'],
                            );
                          },
                        ),
                ),
              ),
            ),

            // Safety Center Section
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              sliver: SliverToBoxAdapter(child: _buildSafetyCenter()),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C2BD9),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find Ride',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            label: 'My Rides',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: const Text(
                '2',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              backgroundColor: Colors.red,
              child: const Icon(Icons.notifications_none),
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SKELETON LOADERS
  // ============================================================
  Widget _buildSkeletonBox({
    required double width,
    required double height,
    double borderRadius = 8,
  }) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300.withOpacity(_shimmerAnimation.value),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      },
    );
  }

  Widget _buildRideSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSkeletonBox(width: 60, height: 20, borderRadius: 6),
              const SizedBox(width: 8),
              _buildSkeletonBox(width: 90, height: 20, borderRadius: 6),
              const Spacer(),
              _buildSkeletonBox(width: 70, height: 20, borderRadius: 12),
            ],
          ),
          const SizedBox(height: 12),
          _buildSkeletonBox(width: 160, height: 18),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildSkeletonBox(width: 24, height: 24, borderRadius: 12),
              const SizedBox(width: 8),
              _buildSkeletonBox(width: 120, height: 14),
            ],
          ),
          const SizedBox(height: 16),
          _buildSkeletonBox(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          _buildSkeletonBox(width: double.infinity, height: 14),
          const SizedBox(height: 16),
          _buildSkeletonBox(width: double.infinity, height: 44, borderRadius: 10),
          const SizedBox(height: 14),
          _buildSkeletonBox(width: double.infinity, height: 46, borderRadius: 12),
        ],
      ),
    );
  }

  Widget _buildRoutesSkeleton() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _buildSkeletonBox(width: 36, height: 36, borderRadius: 10),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonBox(width: 160, height: 14),
                  const SizedBox(height: 6),
                  _buildSkeletonBox(width: 100, height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTENT COMPONENTS
  // ============================================================
  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF6C2BD9),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Good morning,',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: _buildSkeletonBox(width: 140, height: 28),
                )
              : const Text(
                  'Alex Jimenez',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 14),
          const Text(
            'Where are you going today?',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _onSearch(),
              decoration: InputDecoration(
                hintText: 'Search destination or route...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6C2BD9),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _goToFindRide,
              child: const Text(
                'Search Available Rides',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return SliverGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        _buildQuickActionTile(
          'Find a Ride',
          'Search available rides',
          Icons.search,
          const Color(0xFFEFF6FF),
          const Color(0xFF2563EB),
          onTap: _goToFindRide,
        ),
        _buildQuickActionTile(
          'My Rides',
          'Current & upcoming',
          Icons.directions_car_outlined,
          const Color(0xFFF0FDF4),
          const Color(0xFF16A34A),
          onTap: () {},
        ),
        _buildQuickActionTile(
          'Saved Places',
          'Frequent destinations',
          Icons.location_on_outlined,
          const Color(0xFFFEF2F2),
          const Color(0xFFDC2626),
          onTap: () {},
        ),
        _buildQuickActionTile(
          'Ride History',
          'Previous rides',
          Icons.history,
          const Color(0xFFFEFCE8),
          const Color(0xFFCA8A04),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildPillBadge(
                ride['type'],
                const Color(0xFFFEF3C7),
                const Color(0xFFD97706),
              ),
              const SizedBox(width: 6),
              if (ride['isVerified'])
                _buildPillBadge(
                  '✓ Verified Driver',
                  const Color(0xFFDCFCE7),
                  const Color(0xFF15803D),
                ),
              const Spacer(),
              _buildStatusBadge(
                ride['status'],
                const Color(0xFFCCFBF1),
                const Color(0xFF0F766E),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            ride['vehicle'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xFFD97706),
                child: Text(
                  ride['initials'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ride['driver'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 2),
              Text(
                ride['rating'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildLocationRow(
            Icons.radio_button_checked,
            const Color(0xFF6C2BD9),
            'Pickup',
            ride['pickup'],
          ),
          Container(
            margin: const EdgeInsets.only(left: 7),
            height: 14,
            width: 1,
            color: Colors.grey.shade300,
          ),
          _buildLocationRow(
            Icons.location_on,
            Colors.green,
            'Destination',
            ride['destination'],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem('Seats', ride['seats']),
                _buildMetricItem('Departs', ride['departs']),
                _buildMetricItem('Fare', ride['fare'], isPrice: true),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C2BD9),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/vehicle_details',
                );
              },
              child: const Text(
                'Request Ride',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyCenter() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: Color(0xFF6C2BD9),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Your Safety Matters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C2BD9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildSafetyCheckItem('Verified drivers')),
              Expanded(child: _buildSafetyCheckItem('Ride tracking')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildSafetyCheckItem('Emergency assistance')),
              Expanded(child: _buildSafetyCheckItem('Report a problem')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6C2BD9),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onPressed: _openSafetyCenter,
              child: const Text(
                'Safety Center',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget Builders
  Widget _buildQuickActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillBadge(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textCol,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textCol,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLocationRow(
    IconData icon,
    Color iconColor,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricItem(
    String label,
    String value, {
    bool isPrice = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isPrice ? const Color(0xFF059669) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRouteItem(
    String title,
    String subtitle,
    Color iconBg,
    Color iconColor,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.alt_route, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
        size: 18,
      ),
      onTap: _goToFindRide,
    );
  }

  Widget _buildSafetyCheckItem(String text) {
    return Row(
      children: [
        const Icon(Icons.check, size: 14, color: Color(0xFF6C2BD9)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
          ),
        ),
      ],
    );
  }
}