// lib/model/todo_model.dart

// Model for the response when creating a task
class TodoCreateResponse {
  final int status;
  final int taskId;
  final String message;

  TodoCreateResponse({required this.status, required this.taskId, required this.message});

  factory TodoCreateResponse.fromJson(Map<String, dynamic> json) {
    return TodoCreateResponse(
      status: json['status'] ?? 500,
      taskId: json['task_id'] ?? 0,
      message: json['message'] ?? 'Unknown error',
    );
  }
}

// Model for a single Todo item from your group details API
class TodoModel {
  final int id;
  final String task;
  int status; // 0 for pending, 1 for completed
  final AssignedTo assignedTo;
  final String createdAt;

  TodoModel({
    required this.id,
    required this.task,
    required this.status,
    required this.assignedTo,
    required this.createdAt,
  });

  bool get isCompleted => status == 1;

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] ?? 0,
      task: json['task'] ?? 'No Task Name',
      status: json['status'] ?? 0,
      assignedTo: AssignedTo.fromJson(json['assigned_to'] ?? {}),
      createdAt: json['created_at'] ?? '',
    );
  }
}

// Model for the user assigned to a task
class AssignedTo {
  final int id;
  final String name;
  final String profileImage;

  AssignedTo({required this.id, required this.name, required this.profileImage});

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    return AssignedTo(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      profileImage: json['profile_image'] ?? '',
    );
  }
}

