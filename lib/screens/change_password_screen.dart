import 'package:flutter/material.dart';
import '../widgets/settings_widget.dart';

/// Panel 7 - Change Password. The button stays disabled until the form is valid.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool get _valid =>
      _current.text.isNotEmpty &&
      _new.text.length >= 8 &&
      _new.text == _confirm.text;

  String? get _confirmError =>
      _confirm.text.isNotEmpty && _confirm.text != _new.text
          ? 'Passwords do not match'
          : null;

  void _update() {
    // TODO: re-authenticate with the current password, then update it.
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Password updated')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SubScreenScaffold(
      title: 'Change Password',
      subtitle: 'Keep your student account secure',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          SettingsCard(
            padding: const EdgeInsets.all(20),
            children: [
              Form(
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                children: [
                  LabeledTextField(
                    label: 'Current Password',
                    controller: _current,
                    hint: 'Enter current password',
                    obscureText: true,
                    onChanged: (_) => setState(() {}),
                  ),
                  LabeledTextField(
                    label: 'New Password',
                    controller: _new,
                    hint: 'At least 8 characters',
                    obscureText: true,
                    onChanged: (_) => setState(() {}),
                  ),
                  LabeledTextField(
                    label: 'Confirm New Password',
                    controller: _confirm,
                    hint: 'Enter new password again',
                    obscureText: true,
                    validator: (_) => _confirmError,
                    onChanged: (_) => setState(() {}),
                  ),
                  FilledButton(
                    onPressed: _valid ? _update : null,
                    child: const Text('Update Password'),
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }
}