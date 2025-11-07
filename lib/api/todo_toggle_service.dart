// lib/api/todo_toggle_service.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodoToggleService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

  Future<void> toggleTodoStatus({
    required int taskId,
    required bool isCompleted,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("User is not logged in.");
    }

    // 1. Construct the correct URL with the task ID in the path.
    // Example: https://expense.nirmanam.com/api/v2/todo-update/32
    final String url = '$_baseUrl/todo-update/$taskId';

    // 2. Add the required parameters to the query.
    final uri = Uri.parse(url).replace(queryParameters: {
      'token': _token,
      'user_id': userId.toString(),
      'status': isCompleted ? '1' : '0', // '1' for completed, '0' for pending
    });

    // 3. Make the POST request.
    final response = await http.post(uri);

    // 4. Check the response status.
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update task status. Status: ${response.statusCode}, Body: ${response.body}'
      );
    }
    // No response body needs to be parsed, just confirm success.
  }
}
