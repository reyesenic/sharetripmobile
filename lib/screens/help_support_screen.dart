import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes/app_theme.dart';
import '../widgets/settings_widget.dart';
import '../services/content_api.dart';

/// Help & Support: searchable FAQ accordion (one answer open at a time)
/// and a Contact Support button.
/// NOTE: only the "cancel an upcoming ride" answer comes from your design;
/// the other answers are sample text - edit them to match your app.
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _search = TextEditingController();
  late Future<SupportContent> _supportContent;
  String? _openQuestion; // only one answer open at a time

  @override
  void initState() {
    super.initState();
    _supportContent = ContentApi.fetchSupportContent();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<SupportFaq> _filtered(List<SupportFaq> faqs) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return faqs;
    return faqs
        .where((f) =>
            f.question.toLowerCase().contains(q) ||
            f.answer.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _contactSupport(String supportEmail) async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=ShareTrip Support',
    );
    if (!await launchUrl(uri) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open your email app.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    final primary = Theme.of(context).colorScheme.primary;

    return SubScreenScaffold(
      title: 'Help & Support',
      body: FutureBuilder<SupportContent>(
        future: _supportContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Unable to load help topics: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => setState(() {
                        _supportContent = ContentApi.fetchSupportContent();
                      }),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          final content = snapshot.requireData;
          final items = _filtered(content.faqs);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            children: [
              const SectionLabel('Frequently Asked Questions'),
              const SizedBox(height: 4),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 16),
                decoration:
                    shareTripInput(context, hint: 'Search help topics...')
                        .copyWith(
                  prefixIcon: Icon(Icons.search, color: c.mutedText),
                ),
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No matching topics.',
                      style: TextStyle(fontSize: 15, color: c.mutedText),
                    ),
                  ),
                )
              else
                Container(
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
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (i > 0)
                          Divider(height: 1, thickness: 1, color: c.divider),
                        _FaqTile(
                          faq: items[i],
                          expanded: _openQuestion == items[i].question,
                          onTap: () => setState(() {
                            _openQuestion =
                                _openQuestion == items[i].question
                                    ? null
                                    : items[i].question;
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => _contactSupport(content.supportEmail),
                style: OutlinedButton.styleFrom(
                  backgroundColor: c.primaryTint,
                  foregroundColor: primary,
                  side: BorderSide(color: primary.withAlpha(70)),
                ),
                child: const Text('Contact Support'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.faq,
    required this.expanded,
    required this.onTap,
  });

  final SupportFaq faq;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(faq.question,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Icon(
                  expanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                  size: 20,
                  color: c.sectionLabel,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.topCenter,
              child: expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 14, right: 8),
                      child: Text(
                        faq.answer,
                        style: TextStyle(
                            fontSize: 14.5, height: 1.55, color: c.mutedText),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}