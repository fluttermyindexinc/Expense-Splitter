import 'dart:convert';
import 'package:expense_splitter/model/group_list_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupsApiService {
  final String? _baseUrl = dotenv.env['BASE_URL'];
  final String? _token = dotenv.env['TOKEN'];

  Future<GroupsResponse> fetchGroups({required int status}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("User not logged in.");
    }

    final uri = Uri.parse('$_baseUrl/groups').replace(queryParameters: {
      'token': _token,
      'user_id': userId.toString(),
      'status': status.toString(),
    });

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return GroupsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load groups. Status: ${response.statusCode}, Body: ${response.body}'
      );
    }
  }
}
