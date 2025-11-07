class RegistrationResponse {
  final int status;
  final int userId;
  final String message;

  RegistrationResponse({required this.status, required this.userId, required this.message});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'],
      userId: json['user_id'],
      message: json['message'],
    );
  }
}



class User {
  final int id;
  final String name;
  final String? email; 
  final String mobile;
  final String? countryCode;
  final int is_banned;
  final String username;
  final String? dp;

  User({
    required this.id,
    required this.name,
    this.email,
    required this.mobile,
    this.countryCode,
    required this.is_banned,
    required this.username,
    this.dp,
  });

  // This factory ensures data from JSON is correctly typed.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],     
      email: json['email'],
      mobile: json['mobile'].toString(), // Ensures mobile is always a string
      countryCode: json['country_code'],
      is_banned: json['is_banned'],
      username: json['username'],
      dp: json['dp'],
    );
  }
}
class VerifyOtpResponse {
  final int status;
  final User user;
  final String message;

  VerifyOtpResponse({required this.status, required this.user, required this.message});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['status'],
      user: User.fromJson(json['user']),
      message: json['message'],
    );
  }
}