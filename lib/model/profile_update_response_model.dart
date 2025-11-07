import 'dart:convert';

import 'package:expense_splitter/model/auth_models.dart';

ProfileUpdateResponse profileUpdateResponseFromJson(String str) =>
    ProfileUpdateResponse.fromJson(json.decode(str));

class ProfileUpdateResponse {
  final int status;
  final String message;
  // The API might return the updated user data, which is good practice
  final User? user;

  ProfileUpdateResponse({
    required this.status,
    required this.message,
    this.user,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) =>
      ProfileUpdateResponse(
        status: json["status"],
        message: json["message"],
        // Safely parse the user object if it exists
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
      );
}
