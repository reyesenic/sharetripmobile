import 'dart:convert';
import 'package:flutter/material.dart';
import 'vehicle_details_screen.dart';
import 'package:http/http.dart' as http;

class FindRideScreen extends StatefulWidget {
    final dynamic ride;

  const FindRideScreen({super.key, required this.ride,});

  @override
  State<FindRideScreen> createState() => _FindRideScreenState();
}

class _FindRideScreenState extends State<FindRideScreen>
    with SingleTickerProviderStateMixin {
  // -------------------- STATE & CONTROLLERS --------------------
  String _selectedCategory = 'All';
  int _currentNavIndex = 1;

  bool _isLoading = true; // Initial full screen/list skeleton load
  bool _isLoadingMore = false; // Skeleton loading state for infinite scroll
  int _visibleLimit = 5; // Batch size per lazy load

  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _categories = const [
    'All',
    'Car',
    'Motorcycle',
    'Van',
    'Shuttle',
    'Tricycle',
  ];

  List<Map<String, dynamic>> _allRides = [];
  List<Map<String, dynamic>> _filteredRides = [];

  // Backend base URL (10.0.2.2 maps to localhost in Android Emulator)
  static const String _baseUrl = 'http://10.0.2.2:3000';

  @override
  void initState() {
    super.initState();

    // Pulse animation for skeleton loading shimmer effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Infinite Scroll / Lazy Loading Listener
    _scrollController.addListener(_onScroll);

    _fetchRides();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _pickupController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // -------------------- LAZY LOADING SCROLL LISTENER --------------------
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 150) {
      if (!_isLoading &&
          !_isLoadingMore &&
          _visibleLimit < _filteredRides.length) {
        _loadMoreRides();
      }
    }
  }

  Future<void> _loadMoreRides() async {
    setState(() => _isLoadingMore = true);

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _visibleLimit += 5;
        _isLoadingMore = false;
      });
    }
  }

  // -------------------- API INTEGRATION --------------------
  Future<void> _fetchRides() async {
    setState(() {
      _isLoading = true;
      _visibleLimit = 5;
    });

    final categoryParam = Uri.encodeComponent(_selectedCategory);
    final pickupParam = Uri.encodeComponent(_pickupController.text.trim());
    final destParam = Uri.encodeComponent(_destinationController.text.trim());

    final uri = Uri.parse(
      '$_baseUrl/api/rides?category=$categoryParam&pickup=$pickupParam&destination=$destParam',
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final fetched = List<Map<String, dynamic>>.from(data['rides']);
          setState(() {
            _allRides = fetched;
            _filteredRides = fetched;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (_) {
      // Fallback to local mock filtering if server is unreachable
    }

    await Future.delayed(const Duration(milliseconds: 1200));
    _applyLocalFilter();
  }

  void _applyLocalFilter() {
    const mockData = [
      {
        'vehicleType': 'Tricycle',
        'vehicleModel': 'Kawasaki Tricycle',
        'driverName': 'Ramon Dela Rosa',
        'driverInitials': 'RD',
        'rating': '4.8',
        'pickup': 'Bitin Junction',
        'destination': 'CMDI Main Campus Gate',
        'seatsLeft': '2 left',
        'departs': '6:30 AM',
        'fare': '₱15',
        'plate': 'LAG-7841',
        'eta': '4 min',
      },
      {
        'vehicleType': 'Van',
        'vehicleModel': 'Toyota HiAce',
        'driverName': 'Juan Cruz',
        'driverInitials': 'JC',
        'rating': '4.9',
        'pickup': 'Maitim Junction',
        'destination': 'CMDI Main Campus Gate',
        'seatsLeft': '5 left',
        'departs': '7:00 AM',
        'fare': '₱25',
        'plate': 'LAG-1092',
        'eta': '8 min',
      },
      {
        'vehicleType': 'Motorcycle',
        'vehicleModel': 'Honda Click 125',
        'driverName': 'Mark Santos',
        'driverInitials': 'MS',
        'rating': '4.7',
        'pickup': 'Tranca',
        'destination': 'CMDI Bay Campus 2',
        'seatsLeft': '1 left',
        'departs': '6:45 AM',
        'fare': '₱20',
        'plate': 'LAG-3321',
        'eta': '3 min',
      },
      {
        'vehicleType': 'Car',
        'vehicleModel': 'Toyota Vios',
        'driverName': 'Anna Reyes',
        'driverInitials': 'AR',
        'rating': '4.9',
        'pickup': 'Los Baños',
        'destination': 'CMDI Main Campus Gate',
        'seatsLeft': '3 left',
        'departs': '7:15 AM',
        'fare': '₱30',
        'plate': 'LAG-8842',
        'eta': '12 min',
      },
      {
        'vehicleType': 'Shuttle',
        'vehicleModel': 'CMDI Shuttle A',
        'driverName': 'Carlos Bautista',
        'driverInitials': 'CB',
        'rating': '4.8',
        'pickup': 'CMDI Bay Campus 1',
        'destination': 'CMDI Main Campus Gate',
        'seatsLeft': '8 left',
        'departs': '7:30 AM',
        'fare': '₱10',
        'plate': 'LAG-0021',
        'eta': '5 min',
      },
      {
        'vehicleType': 'Tricycle',
        'vehicleModel': 'Honda Tricycle',
        'driverName': 'Lito Manalo',
        'driverInitials': 'LM',
        'rating': '4.6',
        'pickup': 'Bitin Junction',
        'destination': 'CMDI Main Campus Gate',
        'seatsLeft': '3 left',
        'departs': '6:50 AM',
        'fare': '₱15',
        'plate': 'LAG-5523',
        'eta': '6 min',
      },
      {
        'vehicleType': 'Motorcycle',
        'vehicleModel': 'Yamaha NMAX 155',
        'driverName': 'Pedro Penduko',
        'driverInitials': 'PP',
        'rating': '4.9',
        'pickup': 'Calauan Plaza',
        'destination': 'CMDI Bay Campus 1',
        'seatsLeft': '1 left',
        'departs': '7:05 AM',
        'fare': '₱25',
        'plate': 'LAG-7711',
        'eta': '5 min',
      },
      {
        'vehicleType': 'Car',
        'vehicleModel': 'Honda City 1.5',
        'driverName': 'Grace Poe',
        'driverInitials': 'GP',
        'rating': '5.0',
        'pickup': 'San Pablo City Center',
        'destination': 'CMDI Main Campus Gate',
        'seatsLeft': '2 left',
        'departs': '7:20 AM',
        'fare': '₱45',
        'plate': 'LAG-9923',
        'eta': '15 min',
      },
    ];

    setState(() {
      _allRides = mockData;
      _filteredRides = mockData.where((r) {
        final matchesCat = _selectedCategory == 'All' ||
            (r['vehicleType'] as String).toLowerCase() ==
                _selectedCategory.toLowerCase();
        final matchesPickup = _pickupController.text.isEmpty ||
            (r['pickup'] as String)
                .toLowerCase()
                .contains(_pickupController.text.toLowerCase());
        final matchesDest = _destinationController.text.isEmpty ||
            (r['destination'] as String)
                .toLowerCase()
                .contains(_destinationController.text.toLowerCase());

        return matchesCat && matchesPickup && matchesDest;
      }).toList();

      _visibleLimit = 5;
      _isLoading = false;
    });
  }

  // -------------------- HELPERS --------------------
  void _onSearch() {
    FocusScope.of(context).unfocus();
    _fetchRides();
  }

  void _onUseCurrentLocation() {
    setState(() {
      _pickupController.text = 'Bitin Junction';
    });
    _fetchRides();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pickup set to your current location')),
    );
  }

  void _onMoreFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.all(24),
        child: Text('More filters coming soon'),
      ),
    );
  }

  // Navigates to Picture 1 (VehicleDetailsScreen) instead of showing alert dialog
 void _onRequestRide(Map<String, dynamic> ride) {
  if (!mounted) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => VehicleDetailsScreen(ride),
    ),
  );
}

  // -------------------- BUILD --------------------
  @override
  Widget build(BuildContext context) {
    final displayedRides = _filteredRides.take(_visibleLimit).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchRides,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find a Ride',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Where are you going?',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),

                // Destination Search
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _destinationController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _onSearch(),
                    decoration: InputDecoration(
                      hintText: 'Search destination or route...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Color(0xFF6C2BD9),
                        ),
                        onPressed: _onSearch,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Pickup Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _pickupController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onSearch(),
                    decoration: InputDecoration(
                      hintText: 'Enter pickup location',
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Use current location button
                GestureDetector(
                  onTap: _onUseCurrentLocation,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.my_location,
                        size: 16,
                        color: Color(0xFF6C2BD9),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Use My Current Location',
                        style: TextStyle(
                          color: Color(0xFF6C2BD9),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Category chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFF6C2BD9),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF6C2BD9)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = cat);
                              _fetchRides();
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // More filters button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                  ),
                  onPressed: _onMoreFilters,
                  icon: const Icon(Icons.tune, size: 16, color: Colors.black87),
                  label: const Text(
                    'More filters',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header ride count
                if (_isLoading)
                  _buildSkeletonBox(width: 140, height: 18)
                else
                  Text(
                    '${_filteredRides.length} available ride${_filteredRides.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                const SizedBox(height: 12),

                // Ride Cards List / Skeleton Loader
                if (_isLoading) ...[
                  _buildSkeletonCard(),
                  _buildSkeletonCard(),
                  _buildSkeletonCard(),
                ] else if (_filteredRides.isEmpty)
                  _buildEmptyState()
                else ...[
                  ...displayedRides.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildRideCard(
                        context,
                        ride: r,
                        onRequest: () => _onRequestRide(r),
                      ),
                    ),
                  ),

                  // Lazy Loading Skeleton Footer
                  if (_isLoadingMore) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 12),
                      child: _buildSkeletonCard(),
                    ),
                  ] else if (_visibleLimit < _filteredRides.length) ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_downward,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Scroll down for more (${_filteredRides.length - _visibleLimit} remaining)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          if (index == _currentNavIndex) return;
          setState(() => _currentNavIndex = index);
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        },
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

  // -------------------- SKELETON BUILDERS --------------------
  Widget _buildSkeletonBox({
    required double width,
    required double height,
    double borderRadius = 8.0,
  }) {
    return FadeTransition(
      opacity: _pulseAnimation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSkeletonBox(width: 44, height: 44, borderRadius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildSkeletonBox(width: 60, height: 16),
                        const SizedBox(width: 8),
                        _buildSkeletonBox(width: 80, height: 16),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildSkeletonBox(width: 140, height: 20),
                  ],
                ),
              ),
              _buildSkeletonBox(width: 65, height: 20, borderRadius: 12),
            ],
          ),
          const SizedBox(height: 14),
          _buildSkeletonBox(width: double.infinity, height: 46, borderRadius: 12),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No rides match your filters',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideCard(
    BuildContext context, {
    required Map<String, dynamic> ride,
    VoidCallback? onRequest,
  }) {
    final vehicleType = ride['vehicleType'] as String;
    final (IconData icon, Color tintBg, Color tintFg) = switch (vehicleType) {
      'Tricycle' => (
          Icons.electric_rickshaw,
          const Color(0xFFFEF3C7),
          const Color(0xFFD97706)
        ),
      'Car' => (
          Icons.directions_car,
          const Color(0xFFDBEAFE),
          const Color(0xFF2563EB)
        ),
      'Motorcycle' => (
          Icons.two_wheeler,
          const Color(0xFFFCE7F3),
          const Color(0xFFDB2777)
        ),
      'Van' => (
          Icons.airport_shuttle,
          const Color(0xFFF0FDF4),
          const Color(0xFF16A34A)
        ),
      'Shuttle' => (
          Icons.directions_bus,
          const Color(0xFFF3E8FF),
          const Color(0xFF6C2BD9)
        ),
      _ => (
          Icons.directions_car,
          const Color(0xFFFEF3C7),
          const Color(0xFFD97706)
        ),
    };

    return InkWell(
      onTap: onRequest,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tintBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: tintFg, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: tintBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              vehicleType,
                              style: TextStyle(
                                color: tintFg,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '✓ Verified Driver',
                              style: TextStyle(
                                color: Color(0xFF15803D),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ride['vehicleModel'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: const Color(0xFFF59E0B),
                  child: Text(
                    ride['driverInitials'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  ride['driverName'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.star, size: 14, color: Colors.amber),
                Text(
                  ride['rating'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ride['pickup']} ➔ ${ride['destination']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  ride['fare'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF6C2BD9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C2BD9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onRequest,
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
      ),
    );
  }
}

// ============================================================================
// PICTURE 1: VEHICLE DETAILS SCREEN
// ============================================================================
