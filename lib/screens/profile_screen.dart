import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // Sample data. Replace with your real user model.
  final String initials;
  final String name;
  final String courseShort;
  final String yearLevel;
  final String email;
  final String school;
  final String program;
  final int rides;
  final int spent;
  final double rating;
  final int unreadNotifications;

  final VoidCallback? onEditAvatar;
  final VoidCallback? onSavedPlaces;
  final VoidCallback? onRideHistory;
  final VoidCallback? onEditProfile;
  final VoidCallback? onNotifications;
  final VoidCallback? onPrivacySafety;
  final VoidCallback? onSettings;
  final VoidCallback? onHelpSupport;
  final VoidCallback? onSignOut;

  const ProfileScreen({
    super.key,
    this.initials = 'AJ',
    this.name = 'Alex Jimenez',
    this.courseShort = 'BSIT',
    this.yearLevel = '2nd Year',
    this.email = 'a.jimenez@cmdi.edu.ph',
    this.school = 'CMDI',
    this.program = 'BS Information Technology',
    this.rides = 4,
    this.spent = 68,
    this.rating = 4.9,
    this.unreadNotifications = 2,
    this.onEditAvatar,
    this.onSavedPlaces,
    this.onRideHistory,
    this.onEditProfile,
    this.onNotifications,
    this.onPrivacySafety,
    this.onSettings,
    this.onHelpSupport,
    this.onSignOut,
  });

  static const _primary = Color(0xFF4B3FE8);
  static const _bg = Color(0xFFF7F8FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              children: [
                _SectionCard(
                  title: 'STUDENT INFORMATION',
                  child: Column(
                    children: [
                      _InfoRow(label: 'School Email', value: email),
                      const _RowDivider(),
                      _InfoRow(label: 'School', value: school),
                      const _RowDivider(),
                      _InfoRow(label: 'Course / Program', value: program),
                      const _RowDivider(),
                      _InfoRow(label: 'Year Level', value: yearLevel),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  title: 'TRIPS',
                  child: Column(
                    children: [
                      _MenuTile(
                        icon: Icons.location_on_outlined,
                        label: 'Saved Places',
                        onTap: onSavedPlaces,
                      ),
                      _MenuTile(
                        icon: Icons.access_time,
                        label: 'Ride History',
                        onTap: onRideHistory,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  child: Column(
                    children: [
                      _MenuTile(
                        icon: Icons.person_outline,
                        label: 'Edit Profile',
                        onTap: onEditProfile,
                      ),
                      const _RowDivider(),
                      _MenuTile(
                        icon: Icons.notifications_none_rounded,
                        label: 'Notifications',
                        badgeCount: unreadNotifications,
                        onTap: onNotifications,
                      ),
                      const _RowDivider(),
                      _MenuTile(
                        icon: Icons.shield_outlined,
                        label: 'Privacy & Safety',
                        onTap: onPrivacySafety,
                      ),
                      const _RowDivider(),
                      _MenuTile(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        onTap: onSettings,
                      ),
                      const _RowDivider(),
                      _MenuTile(
                        icon: Icons.info_outline,
                        label: 'Help & Support',
                        onTap: onHelpSupport,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: onSignOut,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE11D48),
                      backgroundColor: const Color(0xFFFFF5F7),
                      side: const BorderSide(color: Color(0xFFFBC4CF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Sign Out',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _primary,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 28,
        20,
        22,
      ),
      child: Column(
        children: [
          // Avatar with edit badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.white,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: _primary,
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: 2,
                child: InkWell(
                  onTap: onEditAvatar,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _primary, width: 2),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        size: 13, color: _primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$courseShort · $yearLevel',
            style: const TextStyle(fontSize: 13, color: Color(0xFFD6D3FF)),
          ),
          const SizedBox(height: 2),
          Text(
            email,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFFC4C0FF)),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_outlined, size: 13, color: _primary),
                SizedBox(width: 5),
                Text(
                  'Verified Student',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _Stat(value: '$rides', label: 'Rides')),
                _statDivider(),
                Expanded(child: _Stat(value: '₱$spent', label: 'Spent')),
                _statDivider(),
                Expanded(
                    child: _Stat(
                        value: rating.toStringAsFixed(1), label: 'Rating')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statDivider() => Container(
        width: 1,
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: Colors.white.withValues(alpha: 0.25),
      );
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: Color(0xFFD6D3FF)),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _SectionCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int badgeCount;
  final VoidCallback? onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    this.badgeCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            if (badgeCount > 0) ...[
              Container(
                constraints: const BoxConstraints(minWidth: 20),
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE11D48),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            const Icon(Icons.chevron_right,
                size: 18, color: Color(0xFFD1D5DB)),
          ],
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6));
  }
}