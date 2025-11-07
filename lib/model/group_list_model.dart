class GroupsResponse {
  final int status;
  final int total;
  final List<Group> groups;

  GroupsResponse({
    required this.status,
    required this.total,
    required this.groups,
  });

  factory GroupsResponse.fromJson(Map<String, dynamic> json) {
    return GroupsResponse(
      status: json['status'],
      total: json['total'],
      groups: (json['groups'] as List).map((i) => Group.fromJson(i)).toList(),
    );
  }
}

class Group {
  final int id;
  final String name;
  final String type;
  final int status;
  final String createdAt;

  Group({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
