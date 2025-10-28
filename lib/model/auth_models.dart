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

class User {
  final int id;
  final String name;
  final String email;
  final String? mobile;
  final String? countryCode;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.countryCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      countryCode: json['country_code'],
    );
  }
}
