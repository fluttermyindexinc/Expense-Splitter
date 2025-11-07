class DeleteResponse {
  final int status;
  final String message;

  DeleteResponse({required this.status, required this.message});

  factory DeleteResponse.fromJson(Map<String, dynamic> json) {
    return DeleteResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}