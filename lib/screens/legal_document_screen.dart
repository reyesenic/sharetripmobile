import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import '../widgets/settings_widget.dart';
import '../services/content_api.dart';

/// Shared layout for Privacy Policy and Terms & Conditions:
/// notice box, intro paragraph, then numbered sections inside one card.
class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({
    super.key,
    required this.documentId,
  });

  final String documentId;

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  late Future<LegalDocumentData> _document;

  @override
  void initState() {
    super.initState();
    _document = ContentApi.fetchLegalDocument(widget.documentId);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.st;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<LegalDocumentData>(
      future: _document,
      builder: (context, snapshot) {
        final document = snapshot.data;
        final error = snapshot.error;
        return SubScreenScaffold(
          title: document?.title ?? 'Legal Document',
          subtitle: document == null ? null : 'Last updated ${document.lastUpdated}',
          body: document != null
              ? ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: c.card,
                        borderRadius: BorderRadius.circular(24),
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
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF3A2E10)
                                  : const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              document.notice,
                              style: TextStyle(
                                fontSize: 14.5,
                                height: 1.5,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFFFBBF24)
                                    : const Color(0xFF92400E),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            document.intro,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: c.text.withAlpha(190),
                            ),
                          ),
                          for (final section in document.sections) ...[
                            const SizedBox(height: 22),
                            Text(
                              section.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              section.body,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.55,
                                color: c.mutedText,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Unable to load this document${error == null ? '.' : ': $error'}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: () => setState(() {
                                  _document = ContentApi.fetchLegalDocument(
                                    widget.documentId,
                                  );
                                }),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                  ),
                ),
        );
      },
    );
  }
}
