import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  Future<String> getDailyQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://zenquotes.io/api/random'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final quote = data['quote']['body'];
        final author = data['quote']['author'];

        final result = '"$quote" - $author';
        return result;
      }
      return _getFallbackQuote();

    } catch (e) {
      return _getFallbackQuote();
    }
  }

  String _getFallbackQuote() {
    final quotes = [
      'Whoever is happy will make others happy too. - Anne Frank',
      'You are the average of the five people you spend most time with. - Jim Rohn',
      'Only in the agony of parting do we look into the depths of love. - George Eliot',
      'I always lived in the moment. - Yanni',
      'You are not one person, but three: The one you think you are; The one others think you are; The one you really are. - Sathya Sai Baba',
      'The road to success and the road to failure are almost exactly the same. - Colin R. Davis',

    ];
    return quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
  }
}