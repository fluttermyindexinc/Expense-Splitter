import 'dart:convert';
import 'package:expense_splitter/model/ad_model.dart'; // Adjust path if needed
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AdApiService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

  Future<Ad> fetchAd() async {
    final Uri url = Uri.parse('$_baseUrl/ads?token=$_token');
    
    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        // Success: Parse and return the Ad object.
        return Ad.fromJson(json.decode(response.body));
      } else {
        // --- THE FIX ---
        // If the status code is not 200, throw a detailed error.
        // This will show you exactly what went wrong.
        throw Exception(
          'Failed to load ad. Status code: ${response.statusCode}, Body: ${response.body}'
        );
      }
    } catch (e) {
      // This catches network errors (like no internet connection) and the exception above.
      print('Error in fetchAd: $e');
      // Re-throw the exception to be handled by the UI.
      throw Exception('Failed to load ad');
    }
  }
}
