import 'package:flutter/material.dart';
import '../widgets/safety_card.dart';
import '../widgets/safety_header_widgets.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  static const _primary = Color(0xFF4F46E5);

  final _descriptionController = TextEditingController();
  String? _reportType;
  String? _relatedRide;

  final _reportTypes = const [
    'Unsafe driving',
    'Vehicle concern',
    'Incorrect ride details',
    'Driver behavior',
    'Other safety issue',
  ];

  // Replace with real ride history later.
  final _rides = const <String>[];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_reportType == null || _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select an issue and add a description.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted (prototype only).')),
    );
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: SafeArea(
        child: Column(
          children: [
            const SafetyHeader(
              title: 'Report a Problem',
              subtitle: 'Tell us about a driver, ride, or safety concern',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SafetyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Report Type'),
                        _dropdown(
                          hint: 'Select an issue',
                          value: _reportType,
                          items: _reportTypes,
                          onChanged: (v) => setState(() => _reportType = v),
                        ),
                        const SizedBox(height: 14),
                        const _Label('Related Ride'),
                        _dropdown(
                          hint: 'Select a ride from your history',
                          value: _relatedRide,
                          items: _rides,
                          onChanged: (v) => setState(() => _relatedRide = v),
                        ),
                        const SizedBox(height: 14),
                        const _Label('Description'),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 4,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText:
                                'Explain what happened and include any details that may help...',
                            hintStyle: const TextStyle(
                                fontSize: 12, color: Color(0xFF9CA3AF)),
                            contentPadding: const EdgeInsets.all(12),
                            enabledBorder: _border(),
                            focusedBorder: _border(color: _primary),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            _Label('Evidence'),
                            SizedBox(width: 4),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: Text('(optional)',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF9CA3AF))),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            // TODO: hook up image_picker / file_picker
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.upload_outlined,
                                    size: 16, color: Color(0xFF6B7280)),
                                SizedBox(width: 10),
                                Text('Add a photo or PDF file',
                                    style: TextStyle(
                                        fontSize: 11.5,
                                        color: Color(0xFF6B7280))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF5DC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Prototype notice: reports are saved only for this app session and are not yet delivered to support.',
                      style: TextStyle(
                          fontSize: 11, height: 1.4, color: Color(0xFFB45309)),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Submit Report',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _border({Color color = const Color(0xFFE5E7EB)}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      hint: Text(hint,
          style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
      style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: _border(),
        focusedBorder: _border(color: _primary),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: items.isEmpty ? null : onChanged,
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151))),
    );
  }
}