import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodoUpdateService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

  Future<void> updateTodoStatus({
    required int taskId,
    required bool isCompleted,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) throw Exception("User not logged in.");

    // Note the task ID in the URL path
    final uri = Uri.parse('$_baseUrl/todo-update/$taskId').replace(queryParameters: {
      'token': _token,
      'user_id': userId.toString(),
      'status': isCompleted ? '1' : '0', // '1' for completed, '0' for pending
    });

    final response = await http.post(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to update task status: ${response.body}');
    }
  }
}
