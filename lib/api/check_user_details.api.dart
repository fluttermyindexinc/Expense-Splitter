import 'dart:convert';
import 'package:expense_splitter/model/check_user_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CheckUserApiService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _apiToken = dotenv.env['TOKEN']!;

  Future<CheckUserDetails> fetchUserDetails({
    required String token,
    required int userId,
  }) async { 
    final Uri url = Uri.parse('$_baseUrl/user-details?token=$_apiToken&user_id=$userId');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CheckUserDetails.fromJson(data['user']);
    } else {
      throw Exception(
        'Failed to load user details. Status Code: ${response.statusCode}, Body: ${response.body}'
      );
    }
  }
}
