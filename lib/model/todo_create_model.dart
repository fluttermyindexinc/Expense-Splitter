// lib/model/todo_create_model.dart

class TodoCreateResponse {
  final int status;
  final int taskId;
  final String message;

  TodoCreateResponse({
    required this.status,
    required this.taskId,
    required this.message,
  });

  // A factory constructor to create an instance from a JSON map
  factory TodoCreateResponse.fromJson(Map<String, dynamic> json) {
    return TodoCreateResponse(
      status: json['status'] ?? 500, // Default to an error status if null
      taskId: json['task_id'] ?? 0,
      message: json['message'] ?? 'An unknown error occurred.',
    );
  }
}
