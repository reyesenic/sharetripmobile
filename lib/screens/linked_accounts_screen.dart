import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/settings_widget.dart';

/// Panel 6 - Linked Accounts.
class LinkedAccountsScreen extends StatelessWidget {
  const LinkedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    final primary = Theme.of(context).colorScheme.primary;

    return SubScreenScaffold(
      title: 'Linked Accounts',
      subtitle: 'Manage sign-in methods',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          SettingsCard(
            padding: const EdgeInsets.all(16),
            children: [
              _AccountRow(
                iconBox: Icon(Icons.mail_outline, color: primary),
                iconBg: c.primaryTint,
                title: 'School Email',
                subtitle: 'a.jimenez@cdmi.edu.ph', // TODO: from user
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: c.successBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Connected',
                      style: TextStyle(
                          color: c.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                ),
              ),
            ],
          ),
          SettingsCard(
            padding: const EdgeInsets.all(16),
            children: [
              _AccountRow(
                iconBox: Text('G',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: c.text.withAlpha(200))),
                iconBg: c.iconButtonBg,
                title: 'Google Account',
                subtitle: 'Use Google as another sign-in option',
                trailing: SizedBox(
                  height: 40,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    // TODO: google_sign_in + link credential to the account
                    onPressed: () => comingSoon(context, 'Google sign-in'),
                    child: const Text('Connect'),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Your verified school email remains the primary account for ShareTrip.',
              style: TextStyle(fontSize: 14, color: c.mutedText),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.iconBox,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final Widget iconBox;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: iconBox,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: TextStyle(fontSize: 13.5, color: c.mutedText)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }
}