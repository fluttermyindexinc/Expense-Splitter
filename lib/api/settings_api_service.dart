import 'dart:convert';
import 'package:expense_splitter/model/settings_model.dart'; // Adjust path if needed
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SettingsApiService {
  final String? _baseUrl = dotenv.env['BASE_URL'];
  final String? _token = dotenv.env['TOKEN'];

  Future<AppSettings> fetchSettings() async {
    final Uri url = Uri.parse('$_baseUrl/settings?token=$_token');
    print(url);
    final response = await http.post(url);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AppSettings.fromJson(data['settings']);
    } else {
      throw Exception('Failed to load settings');
    }
  }
}
