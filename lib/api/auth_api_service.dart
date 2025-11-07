import 'dart:convert';
import 'package:expense_splitter/model/auth_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  final String? _baseUrl = dotenv.env['BASE_URL'];
  final String? _token = dotenv.env['TOKEN'];

  Future<RegistrationResponse> registerUser({
    required String name,
    required String email,
    required String mobile,
    required String countryCode,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      body: {
        'token': _token,
        'name': name,
        'email': email,
        'mobile': mobile,
        'country_code': countryCode,
      },
    );

    if (response.statusCode == 200) {
      return RegistrationResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register user. Status code: ${response.statusCode}');
    }
  }

   Future<RegistrationResponse> login({
    required String mobile,
    required String countryCode,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/login');
    print(url);
    final response = await http.post(
      url,
      body: {
        'token': _token,
        'mobile': mobile,
        'country_code': countryCode,
      },
    );

    if (response.statusCode == 200) {
      // Assuming login response is the same structure as registration
      return RegistrationResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }

  Future<VerifyOtpResponse> verifyOtp({
    required int userId,
    required String otp,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/verify-otp');
    final response = await http.post(
      url,
      body: {
        'token': _token,
        'user_id': userId.toString(),
        'otp': otp,
      },
    );

    if (response.statusCode == 200) {
      return VerifyOtpResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to verify OTP. Status code: ${response.statusCode}');
    }
  }

  Future<void> resendOtp({required int userId}) async {
    final Uri url = Uri.parse('$_baseUrl/resend-otp');
    final response = await http.post(
      url,
      body: {
        'token': _token,
        'user_id': userId.toString(),
      },
    );

    if (response.statusCode != 200) {
      // If the server returns an error, we throw an exception.
      // You might want to parse the error message from the response body here.
      throw Exception('Failed to resend OTP. Status code: ${response.statusCode}');
    }
    // No return value needed if the API response is empty on success
  }
}
