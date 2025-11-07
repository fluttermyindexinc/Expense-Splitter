// lib/api/expense_delete_service.dart

import 'dart:convert';
import 'package:expense_splitter/model/expense_delete_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseDeleteService {
  
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

  Future<DeleteResponse> deleteExpense(int expenseId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
 
    if (userId == null) {
      throw Exception("User is not logged in.");
    }

    final uri = Uri.parse('$_baseUrl/expense-delete/$expenseId').replace(queryParameters: {
      'token': _token,
      'user_id': userId.toString(),
    });

    // Per the API documentation, this is a POST request
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return DeleteResponse.fromJson(responseBody);
    } else {
      throw Exception(
        'Failed to delete expense. Status: ${response.statusCode}, Body: ${response.body}'
      );
    }
  }
}
