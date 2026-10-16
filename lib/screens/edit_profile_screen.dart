import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/settings_widget.dart';

/// Panels 4 & 5 - Edit Profile (scrolls, Cancel/Save pinned at the bottom).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // TODO: initialise these from your logged-in user.
  final _name = TextEditingController(text: 'Alex Jimenez');
  final _course = TextEditingController(text: 'BS Information Technology');
  final _year = TextEditingController(text: '2nd Year');
  final _email = TextEditingController(text: 'a.jimenez@cdmi.edu.ph');
  final _phone = TextEditingController(text: '09171234567');
  final _home = TextEditingController(text: 'Bay, Laguna');
  final _pickup = TextEditingController(text: 'CMDI Main Campus Gate');
  final _maxFare = TextEditingController(text: '30');

  static const _vehicles = ['Any vehicle', 'Tricycle', 'Motorcycle', 'Car', 'Van'];
  static const _departures = ['Morning', 'Afternoon', 'Evening', 'Anytime'];
  String _vehicle = 'Any vehicle';
  String _departure = 'Morning';

  @override
  void dispose() {
    for (final c in [_name, _course, _year, _email, _phone, _home, _pickup, _maxFare]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _initials {
    final parts = _name.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: send the values to your backend / state management.
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile updated')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    final primary = Theme.of(context).colorScheme.primary;

    return SubScreenScaffold(
      title: 'Edit Profile',
      subtitle: 'Update your personal information',
      actionBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        color: c.background,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(backgroundColor: c.card),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: _save,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            SettingsCard(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: c.primaryTint,
                      child: Text(
                        _initials,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: primary,
                        ),
                      ),
                    ),
                    TextButton(
                      // TODO: image_picker
                      onPressed: () => comingSoon(context, 'Change Photo'),
                      child: Text('Change Photo',
                          style: TextStyle(
                              color: primary, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 8),
                    LabeledTextField(
                      label: 'Full Name',
                      controller: _name,
                      validator: _required,
                      onChanged: (_) => setState(() {}),
                    ),
                    LabeledTextField(
                      label: 'Course',
                      controller: _course,
                      validator: _required,
                    ),
                    LabeledTextField(
                      label: 'Year Level',
                      controller: _year,
                      validator: _required,
                    ),
                    LabeledTextField(
                      label: 'Email Address',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (_required(v) != null) return 'This field is required';
                        return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(v!.trim())
                            ? null
                            : 'Enter a valid email';
                      },
                    ),
                    LabeledTextField(
                      label: 'Contact Number',
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      validator: _required,
                    ),
                  ],
                ),
              ],
            ),
            SettingsCard(
              label: 'Location',
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              children: [
                Column(
                  children: [
                    LabeledTextField(label: 'Home Area', controller: _home),
                    LabeledTextField(
                        label: 'Default Pickup Point', controller: _pickup),
                  ],
                ),
              ],
            ),
            SettingsCard(
              label: 'Ride Preferences',
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              children: [
                Column(
                  children: [
                    LabeledDropdown(
                      label: 'Preferred Vehicle',
                      value: _vehicle,
                      items: _vehicles,
                      onChanged: (v) => setState(() => _vehicle = v),
                    ),
                    LabeledDropdown(
                      label: 'Preferred Departure',
                      value: _departure,
                      items: _departures,
                      onChanged: (v) => setState(() => _departure = v),
                    ),
                    LabeledTextField(
                      label: 'Maximum Fare',
                      controller: _maxFare,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || double.tryParse(v.trim()) == null)
                              ? 'Enter a number'
                              : null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}