class ExpenseCreateResponse {
  final int status;
  final String message;

  ExpenseCreateResponse({required this.status, required this.message});

  factory ExpenseCreateResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseCreateResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
