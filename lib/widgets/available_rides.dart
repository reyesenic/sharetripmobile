import 'package:flutter/material.dart';

class RideColors {
  static const primary = Color(0xFF5B3DF5);
  static const orange = Color(0xFFF59E0B);
  static const orangeBg = Color(0xFFFFF4E5);
  static const green = Color(0xFF10B981);
  static const greenBg = Color(0xFFE6F8F1);
  static const dark = Color(0xFF1F2937);
  static const grey = Color(0xFF9CA3AF);
  static const label = Color(0xFF6B7280);
  static const tile = Color(0xFFF6F7FB);
}

class Ride {
  final String id;
  final String vehicleType;
  final String vehicleName;
  final String driverName;
  final double rating;
  final String pickup;
  final String destination;
  final int seatsLeft;
  final String departTime;
  final double fare;
  final bool verified;
  final bool available;

  const Ride({
    required this.id,
    required this.vehicleType,
    required this.vehicleName,
    required this.driverName,
    required this.rating,
    required this.pickup,
    required this.destination,
    required this.seatsLeft,
    required this.departTime,
    required this.fare,
    this.verified = true,
    this.available = true,
  });

  factory Ride.fromMap(Map<String, dynamic> map) {
    final rawVehicleName = map['vehicleName'] ?? map['vehicleModel'];
    final rawRating = map['rating'];
    final rawSeats = map['seatsLeft'];
    final rawFare = map['fare'];

    return Ride(
      id: map['id']?.toString() ?? '',
      vehicleType: map['vehicleType']?.toString() ?? 'Tricycle',
      vehicleName: rawVehicleName?.toString() ?? 'Vehicle',
      driverName: map['driverName']?.toString() ?? 'Driver',
      rating: rawRating is num
          ? rawRating.toDouble()
          : double.tryParse(rawRating?.toString() ?? '') ?? 4.8,
      pickup: map['pickup']?.toString() ?? 'Pickup',
      destination: map['destination']?.toString() ?? 'Destination',
      seatsLeft: rawSeats is int
          ? rawSeats
          : int.tryParse(rawSeats?.toString() ?? '') ?? 0,
      departTime: map['departTime']?.toString() ?? 'Now',
      fare: rawFare is num
          ? rawFare.toDouble()
          : double.tryParse(rawFare?.toString() ?? '') ?? 0,
      verified: map['verified'] is bool ? map['verified'] as bool : true,
      available: map['available'] is bool ? map['available'] as bool : true,
    );
  }

  String get initials {
    final parts = driverName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Map<String, dynamic> toRouteArguments() => {
        'id': id,
        'vehicleType': vehicleType,
        'vehicleModel': vehicleName,
        'driverName': driverName,
        'rating': '$rating${verified ? ' • Verified' : ''}',
        'pickup': pickup,
        'destination': destination,
        'seatsLeft': seatsLeft,
        'departTime': departTime,
        'fare': fare,
        'verified': verified,
        'available': available,
      };
}

const List<Ride> sampleRides = [
  Ride(
    id: '1',
    vehicleType: 'Tricycle',
    vehicleName: 'Kawasaki Tricycle',
    driverName: 'Ramon Dela Rosa',
    rating: 4.8,
    pickup: 'Bitin Junction',
    destination: 'CMDI Main Campus Gate',
    seatsLeft: 2,
    departTime: '6:30 AM',
    fare: 15,
  ),
  Ride(
    id: '2',
    vehicleType: 'Tricycle',
    vehicleName: 'Honda Tricycle',
    driverName: 'Jose Santos',
    rating: 4.6,
    pickup: 'Public Market',
    destination: 'CMDI Main Campus Gate',
    seatsLeft: 3,
    departTime: '6:45 AM',
    fare: 20,
  ),
];

class RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback? onRequest;

  const RideCard({super.key, required this.ride, this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 14),
          _driver(),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0F1F5)),
          const SizedBox(height: 14),
          _route(),
          const SizedBox(height: 16),
          _infoTiles(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed:
                  ride.seatsLeft > 0 && ride.available ? onRequest : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: RideColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Request Ride',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: RideColors.orangeBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.electric_rickshaw,
            color: RideColors.orange,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _chip(
                      ride.vehicleType, RideColors.orange, RideColors.orangeBg),
                  if (ride.verified)
                    _chip(
                      'Verified Driver',
                      RideColors.green,
                      RideColors.greenBg,
                      icon: Icons.verified_user_outlined,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ride.vehicleName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: RideColors.dark,
                ),
              ),
            ],
          ),
        ),
        if (ride.available)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: RideColors.greenBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: RideColors.green),
                SizedBox(width: 6),
                Text(
                  'Available',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: RideColors.green,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _chip(String text, Color foreground, Color background,
      {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _driver() {
    return Row(
      children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: RideColors.orange,
          child: Text(
            ride.initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            ride.driverName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: RideColors.dark,
            ),
          ),
        ),
        const Icon(Icons.star_border_rounded,
            size: 18, color: RideColors.orange),
        const SizedBox(width: 3),
        Text(
          ride.rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: RideColors.dark,
          ),
        ),
      ],
    );
  }

  Widget _route() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: RideColors.primary,
              ),
              Expanded(
                child: Container(
                  width: 1.5,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              const Icon(Icons.flag_outlined,
                  size: 18, color: RideColors.green),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _routeText('Pickup', ride.pickup),
                const SizedBox(height: 12),
                _routeText('Destination', ride.destination),
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
            style: const TextStyle(fontSize: 13, color: RideColors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: RideColors.dark,
          ),
        ),
      ],
    );
  }

  Widget _infoTiles() {
    return Row(
      children: [
        _tile('Seats', '${ride.seatsLeft} left', RideColors.dark),
        const SizedBox(width: 10),
        _tile('Departs', ride.departTime, RideColors.primary),
        const SizedBox(width: 10),
        _tile('Fare', '₱${ride.fare.toStringAsFixed(0)}', RideColors.green),
      ],
    );
  }

  Widget _tile(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
        decoration: BoxDecoration(
          color: RideColors.tile,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: RideColors.grey),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvailableRidesSection extends StatelessWidget {
  final List<Ride> rides;
  final int maxItems;
  final void Function(Ride ride)? onRequest;
  final VoidCallback? onViewAll;

  const AvailableRidesSection({
    super.key,
    required this.rides,
    this.maxItems = 2,
    this.onRequest,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final availableRides =
        rides.where((ride) => ride.available && ride.seatsLeft > 0).toList();
    final shown = availableRides.take(maxItems).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            TextButton(
              onPressed: onViewAll,
              child: Text(
                '${availableRides.length} available',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: RideColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (shown.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('No rides available right now')),
          )
        else
          ...shown.map(
            (ride) => RideCard(
              ride: ride,
              onRequest: () => onRequest?.call(ride),
            ),
          ),
      ],
    );
  }
}
