import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:expense_splitter/model/group_edit_response_model.dart'; // Import the new model

class GroupsApiEditService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _token = dotenv.env['TOKEN']!;

 
  Future<GroupEditResponse> updateGroupStatus({
    required int groupId,
    required int status, // 0 for closed, 1 for active
    required int userId,
    // required String token,
  }) async {
    final uri = Uri.parse('$_baseUrl/group-update/$groupId');

    try {
      final response = await http.post(
        uri,
        body: {
          'token': _token,
          'user_id': userId.toString(),
          'status': status.toString(),
        },
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON and return the response model
        return groupEditResponseFromJson(response.body);
      } else {
        // Handle server errors
        throw Exception(
            'Failed to update group status. Server responded with ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
