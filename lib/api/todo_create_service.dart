// lib/api/todo_create_service.dart

import 'dart:convert';
import 'package:expense_splitter/model/todo_create_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodoCreateService {
  // Make sure 'BASE_URL' and 'TOKEN' are in your .env file
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

  Future<TodoCreateResponse> createTodo({
    required int groupId,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("User is not logged in. Please log in again.");
    }

    // Build the URL with the correct parameters
    final uri = Uri.parse('$_baseUrl/todo-create').replace(queryParameters: {
      'token': _token,
      'user_id': userId.toString(),
      'group_id': groupId.toString(),
      'name': name,
    });

    // Make the POST request
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      // If successful, parse the JSON and return the response object
      final responseBody = json.decode(response.body);
      return TodoCreateResponse.fromJson(responseBody);
    } else {
      // If the server returns an error, throw an exception
      throw Exception(
        'Failed to create task. Status Code: ${response.statusCode}, Body: ${response.body}'
      );
    }
  }
}
