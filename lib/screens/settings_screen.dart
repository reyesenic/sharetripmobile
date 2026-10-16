import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../themes/theme_controller.dart';
import '../widgets/settings_widget.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'linked_accounts_screen.dart';
import 'privacy_safety_screen.dart';

/// Panels 1 & 2 - Settings (scrolls).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _rideRequests = true;
  bool _rideUpdates = true;
  bool _promotions = false;
  bool _systemAlerts = true;
  String _language = 'English';

  void _open(Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Log Out', style: TextStyle(color: ctx.st.danger))),
        ],
      ),
    );
    if (ok == true && mounted) {
      // TODO: clear session/token, then go to your welcome route.
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    return SubScreenScaffold(
      title: 'Settings',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          SettingsCard(
            label: 'Account Settings',
            children: [
              NavTile(
                title: 'Edit Profile',
                subtitle: 'Update your info',
                onTap: () => _open(const EditProfileScreen()),
              ),
              NavTile(
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () => _open(const ChangePasswordScreen()),
              ),
              NavTile(
                title: 'Linked Accounts',
                subtitle: 'Manage sign-in methods',
                onTap: () => _open(const LinkedAccountsScreen()),
              ),
            ],
          ),
          SettingsCard(
            label: 'Notification Settings',
            children: [
              ToggleTile(
                title: 'Ride Requests',
                subtitle: 'Notify when a ride matches your route',
                value: _rideRequests,
                onChanged: (v) => setState(() => _rideRequests = v),
              ),
              ToggleTile(
                title: 'Ride Updates',
                subtitle: 'Driver status, arrival, completion',
                value: _rideUpdates,
                onChanged: (v) => setState(() => _rideUpdates = v),
              ),
              ToggleTile(
                title: 'Promotions',
                subtitle: 'Deals and feature announcements',
                value: _promotions,
                onChanged: (v) => setState(() => _promotions = v),
              ),
              ToggleTile(
                title: 'System Alerts',
                subtitle: 'Security and system messages',
                value: _systemAlerts,
                onChanged: (v) => setState(() => _systemAlerts = v),
              ),
            ],
          ),
          SettingsCard(
            label: 'Appearance',
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            children: [
              ListenableBuilder(
                listenable: ThemeController.instance,
                builder: (context, _) => _ThemeModeSelector(
                  mode: ThemeController.instance.mode,
                  onChanged: ThemeController.instance.setMode,
                ),
              ),
            ],
          ),
          SettingsCard(
            label: 'Language',
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            children: [
              LabeledDropdown(
                label: null,
                value: _language,
                items: const ['English', 'Filipino'],
                onChanged: (v) => setState(() => _language = v),
                // TODO: apply the locale through your localization setup.
              ),
            ],
          ),
          SettingsCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            children: [
              NavTile(
                title: 'Privacy Settings',
                onTap: () => _open(const PrivacySafetyScreen()),
              ),
              NavTile(
                title: 'About ShareTrip',
                onTap: () => comingSoon(context, 'About ShareTrip'),
              ),
              NavTile(
                title: 'Terms & Conditions',
                onTap: () => comingSoon(context, 'Terms & Conditions'),
              ),
              NavTile(
                title: 'Privacy Policy',
                onTap: () => comingSoon(context, 'Privacy Policy'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          OutlinedButton(
            onPressed: _confirmLogout,
            style: OutlinedButton.styleFrom(
              foregroundColor: c.danger,
              side: BorderSide(color: c.dangerBorder),
              backgroundColor: c.card,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.mode, required this.onChanged});

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = {
      ThemeMode.light: 'Light',
      ThemeMode.dark: 'Dark',
      ThemeMode.system: 'System',
    };
    final c = context.st;
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        for (final entry in options.entries) ...[
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: mode == entry.key ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: mode == entry.key ? primary : c.border,
                  ),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: mode == entry.key ? Colors.white : c.text,
                  ),
                ),
              ),
            ),
          ),
          if (entry.key != ThemeMode.system) const SizedBox(width: 10),
        ],
      ],
    );
  }
}