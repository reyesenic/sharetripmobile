import 'package:flutter/material.dart';
import '../widgets/settings_widget.dart';

/// Panel 3 - Privacy & Safety.
class PrivacySafetyScreen extends StatefulWidget {
  const PrivacySafetyScreen({super.key});

  @override
  State<PrivacySafetyScreen> createState() => _PrivacySafetyScreenState();
}

class _PrivacySafetyScreenState extends State<PrivacySafetyScreen> {
  bool _locationSharing = true;
  bool _profileVisibility = true;
  bool _safetyAlerts = true;
  bool _emergencyContact = false;
  final int _blockedCount = 0; // TODO: load from your backend

  @override
  Widget build(BuildContext context) {
    return SubScreenScaffold(
      title: 'Privacy & Safety',
      subtitle: 'Manage your privacy and safety settings',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          SettingsCard(
            label: 'Account Privacy',
            children: [
              ToggleTile(
                title: 'Location Sharing',
                subtitle: 'Share your location with drivers',
                value: _locationSharing,
                onChanged: (v) => setState(() => _locationSharing = v),
              ),
              ToggleTile(
                title: 'Profile Visibility',
                subtitle: 'Make profile visible to drivers',
                value: _profileVisibility,
                onChanged: (v) => setState(() => _profileVisibility = v),
              ),
            ],
          ),
          SettingsCard(
            label: 'Ride Safety',
            children: [
              ToggleTile(
                title: 'Ride Safety Alerts',
                subtitle: 'Receive alerts during rides',
                value: _safetyAlerts,
                onChanged: (v) => setState(() => _safetyAlerts = v),
              ),
              ToggleTile(
                title: 'Emergency Contact',
                subtitle: 'Notify contact in emergencies',
                value: _emergencyContact,
                onChanged: (v) => setState(() => _emergencyContact = v),
              ),
            ],
          ),
          SettingsCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            children: [
              NavTile(
                icon: Icons.person_outline,
                title: 'Blocked Users',
                subtitle: '$_blockedCount blocked',
                onTap: () => comingSoon(context, 'Blocked Users'),
              ),
              NavTile(
                icon: Icons.warning_amber_rounded,
                title: 'Report a User',
                onTap: () => comingSoon(context, 'Report a User'),
              ),
              NavTile(
                icon: Icons.shield_outlined,
                title: 'Safety Guidelines',
                onTap: () => comingSoon(context, 'Safety Guidelines'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}