class GroupCreateResponse {
  final int status;
  final String message;
  final int groupId; // <-- ADD THIS LINE

  GroupCreateResponse({
    required this.status, 
    required this.message, 
    required this.groupId, // <-- ADD THIS
  });

  factory GroupCreateResponse.fromJson(Map<String, dynamic> json) {
    return GroupCreateResponse(
      status: json['status'],
      message: json['message'],
      groupId: json['group_id'], // <-- ADD THIS to parse the new field
    );
  }
}
