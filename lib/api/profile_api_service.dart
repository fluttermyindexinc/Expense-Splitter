// lib/api/profile_api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:expense_splitter/model/auth_models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:expense_splitter/model/profile_update_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileApiService {
  // --- THE FIX: Use the variable name that is ACTUALLY in your .env file ---
  final String? _baseUrl = dotenv.env['BASE_URL']; 
  final String? _token = dotenv.env['TOKEN'];
  Future<User> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (_baseUrl == null || _token == null) {
      throw Exception('API URL or Token is not configured');
    }
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final uri = Uri.parse('$_baseUrl/get-profile/$userId').replace(queryParameters: {
      'token': _token,
    });
    
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      // Assuming the API returns a 'user' object on success
      return User.fromJson(responseBody['user']);
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }

  Future<ProfileUpdateResponse> updateProfile({
    required int userId,
    String? name,
    File? imageFile,
  }) async {
    if (_baseUrl == null || _token == null) {
      throw Exception('API URL or Token is not configured correctly in the .env file');
    }

    final uri = Uri.parse('$_baseUrl/update-profile/$userId');
    var request = http.MultipartRequest('POST', uri);

    request.fields['token'] = _token!;

    if (name != null) {
      request.fields['name'] = name;
    }

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return profileUpdateResponseFromJson(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to update profile: ${errorBody['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
