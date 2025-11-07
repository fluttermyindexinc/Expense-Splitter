import 'dart:convert';


GroupEditResponse groupEditResponseFromJson(String str) =>
    GroupEditResponse.fromJson(json.decode(str));

class GroupEditResponse {
  final int status;
  final int groupId; 
  final String message;

  GroupEditResponse({
    required this.status,
    required this.groupId,
    required this.message,
  });

  factory GroupEditResponse.fromJson(Map<String, dynamic> json) => GroupEditResponse(
        status: json["status"],
        groupId: json["group_id"],
        message: json["message"],
      );
}
