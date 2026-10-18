import 'package:flutter/material.dart';

import 'legal_document_screen.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentScreen(documentId: 'terms');
  }
}
