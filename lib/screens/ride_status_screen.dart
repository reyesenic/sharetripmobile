import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/available_rides.dart';

/// ---------------------------------------------------------------
/// ride_status_screen.dart
///
/// Open it after the ride is confirmed:
///   Navigator.push(context, MaterialPageRoute(
///     builder: (_) => RideStatusScreen(
///       ride: ride,
///       plateNumber: 'LAG-4432',
///       etaMinutes: 3,
///       initialStage: RideStage.requested,
///     ),
///   ));
///
/// To test the whole flow, add `autoAdvance: true` — it moves to the
/// next stage every 4 seconds until "Completed".
/// ---------------------------------------------------------------

enum RideStage {
  requested,
  accepted,
  driverArriving,
  pickedUp,
  inProgress,
  completed,
}

extension RideStageX on RideStage {
  String get label {
    switch (this) {
      case RideStage.requested:
        return 'Requested';
      case RideStage.accepted:
        return 'Accepted';
      case RideStage.driverArriving:
        return 'Driver Arriving';
      case RideStage.pickedUp:
        return 'Picked Up';
      case RideStage.inProgress:
        return 'In Progress';
      case RideStage.completed:
        return 'Completed';
    }
  }

  String get message {
    switch (this) {
      case RideStage.requested:
        return 'Waiting for the driver to accept.';
      case RideStage.accepted:
        return 'Your driver accepted the ride.';
      case RideStage.driverArriving:
        return 'Your driver is on the way.';
      case RideStage.pickedUp:
        return 'You have been picked up.';
      case RideStage.inProgress:
        return 'Your ride is in progress.';
      case RideStage.completed:
        return 'Your ride is complete.';
    }
  }
}

class RideStatusScreen extends StatefulWidget {
  final Ride ride;
  final String plateNumber;
  final int etaMinutes;
  final RideStage initialStage;
  final bool autoAdvance;
  final VoidCallback? onSOS;
  final VoidCallback? onShare;
  final VoidCallback? onReport;
  final VoidCallback? onCenterMap;

  const RideStatusScreen({
    super.key,
    required this.ride,
    this.plateNumber = 'LAG-4432',
    this.etaMinutes = 3,
    this.initialStage = RideStage.requested,
    this.autoAdvance = false,
    this.onSOS,
    this.onShare,
    this.onReport,
    this.onCenterMap,
  });

  @override
  State<RideStatusScreen> createState() => _RideStatusScreenState();
}

class _RideStatusScreenState extends State<RideStatusScreen> {
  static const _bg = Color(0xFFF7F8FC);
  static const _blue = Color(0xFF0284C7);
  static const _red = Color(0xFFE11D48);
  static const _redBg = Color(0xFFFDECEF);
  static const _primaryBg = Color(0xFFECEEFF);
  static const _indigo = Color(0xFF4F36F5);

  late RideStage _stage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _stage = widget.initialStage;
    if (widget.autoAdvance) {
      _timer = Timer.periodic(const Duration(seconds: 4), (t) {
        if (_stage == RideStage.completed) {
          t.cancel();
          return;
        }
        setState(() => _stage = RideStage.values[_stage.index + 1]);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _topBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                children: [
                  _vehicleCard(ride),
                  const SizedBox(height: 14),
                  _driverCard(ride),
                  const SizedBox(height: 14),
                  _routeCard(ride),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _statTile('Fare', '₱${ride.fare.toStringAsFixed(0)}',
                          RideColors.primary),
                      const SizedBox(width: 12),
                      _statTile('Seats', '${ride.seatsLeft} left', _blue),
                      const SizedBox(width: 12),
                      _statTile(
                          'ETA', '${widget.etaMinutes} min', RideColors.green),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _mapCard(),
                  const SizedBox(height: 14),
                  _statusCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOP BAR =================
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
                widget.plateNumber,
                style: const TextStyle(fontSize: 13, color: RideColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= SHARED CARD =================
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

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: RideColors.grey,
        ),
      );

  // ================= VEHICLE =================
  Widget _vehicleCard(Ride ride) {
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

  // ================= DRIVER =================
  Widget _driverCard(Ride ride) {
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
                onTap: widget.onShare ?? () => _toast('Share ride details'),
              ),
              const SizedBox(width: 10),
              _circleAction(
                icon: Icons.help_outline_rounded,
                color: _red,
                bg: _redBg,
                onTap: widget.onReport ?? () => _toast('Report a problem'),
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

  // ================= ROUTE =================
  Widget _routeCard(Ride ride) {
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

  // ================= STAT TILES =================
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

  // ================= MAP CARD =================
  Widget _mapCard() {
    final completed = _stage == RideStage.completed;
    final heading = _stage.index >= RideStage.pickedUp.index;

    String subtitle;
    if (completed) {
      subtitle = 'Thanks for riding with us!';
    } else if (heading) {
      subtitle = 'Heading to ${widget.ride.destination}';
    } else {
      subtitle = 'Estimated arrival: ${widget.etaMinutes} minutes';
    }

    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            // ---- placeholder map (replace with GoogleMap later) ----
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _GridPainter()),
                  ),
                  const Align(
                    alignment: Alignment(-0.75, -0.7),
                    child: _MapChip(
                      label: 'Your Location',
                      icon: Icons.location_on_outlined,
                      color: Color(0xFF3B2FC9),
                    ),
                  ),
                  const Align(
                    alignment: Alignment(0.9, -0.15),
                    child: _MapChip(
                      label: 'Driver',
                      icon: Icons.directions_car_outlined,
                      color: Color(0xFFB45309),
                    ),
                  ),
                  const Align(
                    alignment: Alignment(-0.35, 0.55),
                    child: _MapChip(
                      label: 'Destination',
                      icon: Icons.flag_outlined,
                      color: Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _stage.message,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: RideColors.dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                              fontSize: 14, color: RideColors.label),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed:
                        widget.onCenterMap ?? () => _toast('Map centered'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _indigo,
                      side: const BorderSide(color: Color(0xFFD6DAF5)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Center Map',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STATUS CARD =================
  Widget _statusCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('RIDE STATUS'),
          const SizedBox(height: 14),
          for (final s in RideStage.values) _stageRow(s),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  label: 'SOS',
                  icon: Icons.help_outline_rounded,
                  color: _red,
                  border: const Color(0xFFF8C9D4),
                  onTap: widget.onSOS ?? () => _toast('Calling emergency…'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionButton(
                  label: 'Share Ride',
                  icon: Icons.share_outlined,
                  color: RideColors.dark,
                  border: const Color(0xFFE5E7EB),
                  onTap: widget.onShare ?? () => _toast('Share ride details'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionButton(
                  label: 'Report',
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFEA580C),
                  border: const Color(0xFFFAD9B5),
                  onTap: widget.onReport ?? () => _toast('Report a problem'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stageRow(RideStage s) {
    final done = s.index < _stage.index;
    final current = s == _stage;

    if (current) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF0FF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E4FF),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${s.index + 1}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _indigo,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                s.label,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: _indigo,
                ),
              ),
            ),
            const Text(
              'Now',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _indigo,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: done ? const Color(0xFFD1FAE5) : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: done
                ? const Icon(Icons.check_rounded,
                    size: 18, color: RideColors.green)
                : Text(
                    '${s.index + 1}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: RideColors.grey,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Text(
            s.label,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: done ? RideColors.grey : RideColors.label,
              decoration: done ? TextDecoration.lineThrough : null,
              decorationColor: RideColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color border,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= MAP HELPERS =================
class _MapChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _MapChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFEDF0FF),
    );
    final line = Paint()
      ..color = const Color(0xFFE0E4FA)
      ..strokeWidth = 1.2;
    const step = 28.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
