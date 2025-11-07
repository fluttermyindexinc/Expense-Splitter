class CheckUserDetails {
  final int id;
  final String name;
  final int isBanned; // 0 = active, 1 = banned, 2 = unverified

  CheckUserDetails({
    required this.id,
    required this.name,
    required this.isBanned,
  });

  factory CheckUserDetails.fromJson(Map<String, dynamic> json) {
    return CheckUserDetails(
      id: json['id'],
      name: json['name'],
      isBanned: json['is_banned'],
    );
  }
}
