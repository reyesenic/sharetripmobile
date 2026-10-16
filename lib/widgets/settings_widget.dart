import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

/// TODO: return your existing bottom navigation here, e.g.
/// `return const ShareTripBottomNav(currentIndex: 4);` (Profile tab).
Widget buildShareTripBottomNav(BuildContext context) =>
    const SizedBox.shrink();

void comingSoon(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$what - coming soon')));
}

/// Page frame: white header with circular back button, title, optional
/// subtitle, scrollable body, optional pinned action bar, then bottom nav.
class SubScreenScaffold extends StatelessWidget {
  const SubScreenScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.actionBar,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? actionBar;

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: c.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  children: [
                    Material(
                      color: c.iconButtonBg,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.maybePop(context),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(Icons.arrow_back,
                              size: 20, color: c.text.withAlpha(190)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          if (subtitle != null)
                            Text(subtitle!,
                                style: TextStyle(
                                    fontSize: 13, color: c.mutedText)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (actionBar != null) actionBar!,
            buildShareTripBottomNav(context),
          ],
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: context.st.sectionLabel,
          ),
        ),
      );
}

/// Rounded white card. Children are separated by hairline dividers when
/// [dividers] is true.
class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    required this.children,
    this.label,
    this.dividers = true,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 6),
  });

  final String? label;
  final List<Widget> children;
  final bool dividers;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0 && dividers) {
        items.add(Divider(height: 1, thickness: 1, color: c.divider));
      }
      items.add(children[i]);
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: padding,
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(16),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) SectionLabel(label!),
          ...items,
        ],
      ),
    );
  }
}

class ToggleTile extends StatelessWidget {
  const ToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(fontSize: 14, color: c.mutedText)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class NavTile extends StatelessWidget {
  const NavTile({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: c.mutedText),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: TextStyle(fontSize: 14, color: c.mutedText)),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: c.sectionLabel),
          ],
        ),
      ),
    );
  }
}

InputDecoration shareTripInput(BuildContext context, {String? hint}) {
  final c = context.st;
  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: c.sectionLabel),
    filled: true,
    fillColor: c.card,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: border(c.border),
    focusedBorder: border(Theme.of(context).colorScheme.primary),
    errorBorder: border(c.danger),
    focusedErrorBorder: border(c.danger),
  );
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.st.mutedText)),
      );
}

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(label),
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              validator: validator,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 16),
              decoration: shareTripInput(context, hint: hint),
            ),
          ],
        ),
      );
}

class LabeledDropdown extends StatelessWidget {
  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String? label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    return Padding(
      padding: EdgeInsets.only(bottom: label == null ? 10 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) FieldLabel(label!),
          DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: c.text),
            dropdownColor: c.card,
            style: TextStyle(fontSize: 16, color: c.text),
            decoration: shareTripInput(context),
            items: [
              for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
            ],
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}