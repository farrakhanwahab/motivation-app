import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIQuoteService {
  static final String? _apiKey = dotenv.env['GEMINI_API_KEY'];
  static const String _endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  static Future<Map<String, String>> fetchQuote({List<String>? topics, String? mood}) async {
    if (_apiKey == null) {
      throw Exception('API key not found');
    }
    final prompt = _buildPrompt(topics: topics, mood: mood);
    final response = await http.post(
      Uri.parse('$_endpoint?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
      // Try to split quote and author if possible
      final match = RegExp(r'"(.+?)"\s*-\s*(.+)').firstMatch(text);
      if (match != null) {
        return {'quote': match.group(1)!, 'author': match.group(2)!};
      }
      return {'quote': text, 'author': 'Unknown'};
    } else {
      throw Exception('Failed to fetch quote: ${response.body}');
    }
  }

  static String _buildPrompt({List<String>? topics, String? mood}) {
    String prompt = 'Give me a short, original motivational quote';
    if (topics != null && topics.isNotEmpty) {
      prompt += ' about ${topics.join(", ")}';
    }
    if (mood != null && mood != 'Any') {
      prompt += ' for someone feeling $mood';
    }
    prompt += '. Format as: "Quote" - Author.';
    return prompt;
  }
} 