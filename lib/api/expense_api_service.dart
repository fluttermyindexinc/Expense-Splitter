import 'dart:convert';
import 'package:expense_splitter/model/expense_create_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ExpenseApiService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

  Future<ExpenseCreateResponse> createExpense({
    required int groupId,
    required String note,
    required int userId,
    required double amount,
  }) async {
    // Construct the URL with query parameters
    final uri = Uri.parse('$_baseUrl/expense-create').replace(queryParameters: {
      'token': _token,
      'group_id': groupId.toString(),
      'note': note,
      'user_id': userId.toString(),
      'amount': amount.toString(),
    });

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return ExpenseCreateResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to create expense. Status: ${response.statusCode}, Body: ${response.body}'
      );
    }
  }
}
