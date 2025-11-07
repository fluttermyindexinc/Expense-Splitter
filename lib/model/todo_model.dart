// This class represents a single Todo item from your API
class TodoModel {
  final int id;
  String name;
  int status; // 0 for pending, 1 for completed

  TodoModel({
    required this.id,
    required this.name,
    this.status = 0,
  });

  bool get isCompleted => status == 1;

  // A function to create a Todo object from the API's JSON data
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      name: json['name'],
      status: int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}
