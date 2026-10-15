import 'package:flutter/material.dart';

import '../widgets/available_rides.dart';
import 'confirm_ride_screen.dart';
import 'request_sent_screen.dart';

/// ---------------------------------------------------------------
/// vehicle_details_screen.dart
///
/// Open it from a ride card:
///   Navigator.push(context, MaterialPageRoute(
///     builder: (_) => VehicleDetailsScreen(
///       ride: ride,
///       plateNumber: 'LAG-7841',
///       etaMinutes: 4,
///     ),
///   ));
/// ---------------------------------------------------------------

class VehicleDetailsScreen extends StatelessWidget {
  final Ride ride;
  final String plateNumber;
  final int etaMinutes;
  final VoidCallback? onShare;
  final VoidCallback? onReport;
  final VoidCallback? onRequest;

  const VehicleDetailsScreen({
    super.key,
    required this.ride,
    this.plateNumber = 'LAG-7841',
    this.etaMinutes = 4,
    this.onShare,
    this.onReport,
    this.onRequest,
  });

  factory VehicleDetailsScreen.fromArguments(
    Object? arguments, {
    Key? key,
    String plateNumber = 'LAG-7841',
    int etaMinutes = 4,
    VoidCallback? onShare,
    VoidCallback? onReport,
    VoidCallback? onRequest,
  }) {
    final map = arguments is Map
        ? Map<String, dynamic>.from(arguments)
        : const <String, dynamic>{};
    return VehicleDetailsScreen(
      key: key,
      ride: Ride.fromMap(map),
      plateNumber: plateNumber,
      etaMinutes: etaMinutes,
      onShare: onShare,
      onReport: onReport,
      onRequest: onRequest,
    );
  }

  static const _bg = Color(0xFFF7F8FC);
  static const _blue = Color(0xFF0284C7);
  static const _red = Color(0xFFE11D48);
  static const _redBg = Color(0xFFFDECEF);
  static const _primaryBg = Color(0xFFECEEFF);
  static const _btn = Color(0xFF4F36F5);

  @override
  Widget build(BuildContext context) {
    final fare = '₱${ride.fare.toStringAsFixed(0)}';

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _topBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  _vehicleCard(),
                  const SizedBox(height: 14),
                  _driverCard(context),
                  const SizedBox(height: 14),
                  _routeCard(),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _statTile('Fare', fare, RideColors.primary),
                      const SizedBox(width: 12),
                      _statTile('Seats', '${ride.seatsLeft} left', _blue),
                      const SizedBox(width: 12),
                      _statTile('ETA', '$etaMinutes min', RideColors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _bottomBar(context, fare),
        ],
      ),
    );
  }

  // ---------------- TOP BAR ----------------
  Widget _topBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 12, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            customBorder: const CircleBorder(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F2F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back,
                  size: 20, color: RideColors.dark),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vehicle Details',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: RideColors.dark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                plateNumber,
                style: const TextStyle(fontSize: 13, color: RideColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- CARD WRAPPER ----------------
  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: RideColors.grey,
      ),
    );
  }

  // ---------------- VEHICLE CARD ----------------
  Widget _vehicleCard() {
    return _card(
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7EA),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.electric_rickshaw,
                size: 34, color: RideColors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pill(ride.vehicleType, RideColors.orange, RideColors.orangeBg),
                const SizedBox(height: 8),
                Text(
                  ride.vehicleName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: RideColors.dark,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (ride.available)
                      _pill('Available', RideColors.green, RideColors.greenBg,
                          dot: true),
                    if (ride.verified)
                      _pill('Verified Driver', RideColors.green,
                          RideColors.greenBg,
                          icon: Icons.verified_user_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color fg, Color bg,
      {IconData? icon, bool dot = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Icon(Icons.circle, size: 8, color: fg),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: 15, color: fg),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- DRIVER CARD ----------------
  Widget _driverCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('DRIVER'),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 29,
                backgroundColor: RideColors.orange,
                child: Text(
                  ride.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.driverName,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: RideColors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_border_rounded,
                            size: 20, color: RideColors.orange),
                        const SizedBox(width: 4),
                        Text(
                          ride.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: RideColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _circleAction(
                icon: Icons.share_outlined,
                color: RideColors.primary,
                bg: _primaryBg,
                onTap: onShare ??
                    () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share ride details'))),
              ),
              const SizedBox(width: 10),
              _circleAction(
                icon: Icons.help_outline_rounded,
                color: _red,
                bg: _redBg,
                onTap: onReport ??
                    () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Report a problem'))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleAction({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  // ---------------- ROUTE CARD ----------------
  Widget _routeCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('ROUTE'),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 20, color: RideColors.primary),
                    Expanded(
                      child: Container(
                        width: 1.5,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                    const Icon(Icons.flag_outlined,
                        size: 20, color: RideColors.green),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _routeText('Pickup', ride.pickup),
                      const SizedBox(height: 14),
                      _routeText('Destination', ride.destination),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, color: RideColors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: RideColors.dark,
          ),
        ),
      ],
    );
  }

  // ---------------- STAT TILES ----------------
  Widget _statTile(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, color: RideColors.grey)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BOTTOM BAR ----------------
  Widget _bottomBar(BuildContext context, String fare) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: ride.seatsLeft > 0
                  ? () async {
                      final confirmed =
                          await showConfirmRideSheet(context, ride);
                      if (confirmed != true || !context.mounted) return;
                      if (onRequest != null) {
                        onRequest!();
                        return;
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RequestSentScreen(
                            ride: ride,
                            plateNumber: plateNumber,
                            etaMinutes: etaMinutes,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _btn,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Request Ride — $fare',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${ride.seatsLeft} seats available · ETA $etaMinutes min',
            style: const TextStyle(fontSize: 14, color: RideColors.grey),
          ),
        ],
      ),
    );
  }
}
