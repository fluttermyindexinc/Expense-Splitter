import 'dart:convert';
import 'package:expense_splitter/model/group_details_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupDetailsService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

  Future<GroupDetailsResponse> fetchGroupDetails(int groupId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("User is not logged in.");
    }

    final uri = Uri.parse('$_baseUrl/group-details/$groupId').replace(queryParameters: {
      'token': _token,
      'user_id': userId.toString(),
    });
    print('group response $uri');

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return GroupDetailsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load group details. Status: ${response.statusCode}, Body: ${response.body}'
      );
    }
  }



}