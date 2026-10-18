import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const _configuredApiBaseUrl = String.fromEnvironment('API_BASE_URL');

String get _apiBaseUrl {
  if (_configuredApiBaseUrl.isNotEmpty) return _configuredApiBaseUrl;
  return defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';
}

class LegalDocumentData {
  const LegalDocumentData({
    required this.title,
    required this.lastUpdated,
    required this.intro,
    required this.notice,
    required this.sections,
  });

  final String title;
  final String lastUpdated;
  final String intro;
  final String notice;
  final List<LegalDocumentSection> sections;

  factory LegalDocumentData.fromJson(Map<String, dynamic> json) {
    final sections = json['sections'];
    if (sections is! List) {
      throw const FormatException('Legal document sections are missing.');
    }

    return LegalDocumentData(
      title: _requiredString(json, 'title'),
      lastUpdated: _requiredString(json, 'lastUpdated'),
      intro: _requiredString(json, 'intro'),
      notice: _requiredString(json, 'notice'),
      sections: sections.map((section) {
        if (section is! Map<String, dynamic>) {
          throw const FormatException('Invalid legal document section.');
        }
        return LegalDocumentSection(
          title: _requiredString(section, 'title'),
          body: _requiredString(section, 'body'),
        );
      }).toList(growable: false),
    );
  }
}

class LegalDocumentSection {
  const LegalDocumentSection({required this.title, required this.body});

  final String title;
  final String body;
}

class SupportContent {
  const SupportContent({required this.supportEmail, required this.faqs});

  final String supportEmail;
  final List<SupportFaq> faqs;

  factory SupportContent.fromJson(Map<String, dynamic> json) {
    final faqs = json['faqs'];
    if (faqs is! List) {
      throw const FormatException('Support FAQ list is missing.');
    }

    return SupportContent(
      supportEmail: _requiredString(json, 'supportEmail'),
      faqs: faqs.map((faq) {
        if (faq is! Map<String, dynamic>) {
          throw const FormatException('Invalid support FAQ.');
        }
        return SupportFaq(
          question: _requiredString(faq, 'question'),
          answer: _requiredString(faq, 'answer'),
        );
      }).toList(growable: false),
    );
  }
}

class SupportFaq {
  const SupportFaq({required this.question, required this.answer});

  final String question;
  final String answer;
}

class ContentApiException implements Exception {
  const ContentApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ContentApi {
  ContentApi._();

  static Future<LegalDocumentData> fetchLegalDocument(String documentId) async {
    final response = await http
        .get(Uri.parse('$_apiBaseUrl/api/legal/$documentId'))
        .timeout(const Duration(seconds: 10));
    final payload = _decodeResponse(response);
    final document = payload['document'];
    if (document is! Map<String, dynamic>) {
      throw const FormatException('Legal document response is invalid.');
    }
    return LegalDocumentData.fromJson(document);
  }

  static Future<SupportContent> fetchSupportContent() async {
    final response = await http
        .get(Uri.parse('$_apiBaseUrl/api/support/faqs'))
        .timeout(const Duration(seconds: 10));
    return SupportContent.fromJson(_decodeResponse(response));
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Content API response is invalid.');
    }
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        decoded['success'] != true) {
      final error = decoded['error'];
      throw ContentApiException(
        error is String ? error : 'Unable to load content.',
      );
    }
    return decoded;
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Content field "$key" is missing or invalid.');
  }
  return value;
}
