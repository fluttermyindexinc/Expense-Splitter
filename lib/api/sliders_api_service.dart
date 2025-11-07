
import 'dart:convert';
import 'package:expense_splitter/model/slider_model.dart'; // Adjust path if needed
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SlidersApiService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

  Future<SliderResponse> fetchSliders() async {
    final Uri url = Uri.parse('$_baseUrl/sliders?token=$_token');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      return SliderResponse.fromJson(json.decode(response.body));
    } else {
      // Provide a detailed error message for easier debugging.
      throw Exception(
        'Failed to load sliders. Status Code: ${response.statusCode}, Body: ${response.body}'
      );
    }
  }
}
