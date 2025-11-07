import 'dart:convert';
import 'package:expense_splitter/model/group_create_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroupApiService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

  Future<GroupCreateResponse> createGroup({
    required int userId,
    required String name,
    required String type,
  }) async {
    // Construct the URL with query parameters as specified
    final uri = Uri.parse('$_baseUrl/group-create').replace(queryParameters: {
      'token': _token,
      'user_id': userId.toString(),
      'name': name,
      'type': type,
    });

    // Make the POST request
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return GroupCreateResponse.fromJson(json.decode(response.body));
    } else {
      // Provide a detailed error for easier debugging
      throw Exception(
        'Failed to create group. Status: ${response.statusCode}, Body: ${response.body}'
      );
    }
  }
}
