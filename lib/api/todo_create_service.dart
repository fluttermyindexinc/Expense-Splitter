import 'dart:convert';
import 'package:expense_splitter/model/todo_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodoCreateService {
  final String? _baseUrl = dotenv.env['BASE_URL'];
  final String? _token = dotenv.env['TOKEN'];

  Future<TodoCreateResponse> createTodo({
    required int groupId,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) throw Exception("User not logged in.");

    final uri = Uri.parse('$_baseUrl/todo-create').replace(queryParameters: {
      'token': _token,
      'user_id': userId.toString(),
      'group_id': groupId.toString(),
      'name': name,
    });

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return TodoCreateResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }
}

