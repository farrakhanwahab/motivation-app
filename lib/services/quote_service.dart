import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static Future<Map<String, String>> fetchQuote({List<String>? topics, String? mood}) async {
    // ZenQuotes does not support topic filtering in the free tier
    final url = Uri.parse('https://zenquotes.io/api/random');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return {
          'quote': data[0]['q'] ?? '',
          'author': data[0]['a'] ?? 'Unknown',
        };
      } else {
        throw Exception('No quote found in response');
      }
    } else {
      throw Exception('Failed to fetch quote: ${response.body}');
    }
  }
}
