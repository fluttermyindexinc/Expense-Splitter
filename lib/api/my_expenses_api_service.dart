import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_splitter/model/my_expenses_model.dart';

class MyExpensesApiService {
  final String? _baseUrl = dotenv.env['BASE_URL'];
  final String? _token = dotenv.env['TOKEN'];

  Future<MyExpensesResponse> fetchExpenses({required int page}) async {
    if (_baseUrl == null || _token == null) {
      throw Exception('API URL or Token is not configured in .env file');
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final uri = Uri.parse('$_baseUrl/expenses').replace(queryParameters: {
      'token': _token!,
      'user_id': userId.toString(),
      'per_page': '10', // As requested, 10 items per page
      'page': page.toString(),
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return myExpensesResponseFromJson(response.body);
      } else {
        throw Exception('Failed to load expenses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching expenses: $e');
    }
  }
}
