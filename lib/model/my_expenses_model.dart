import 'dart:convert';

MyExpensesResponse myExpensesResponseFromJson(String str) =>
    MyExpensesResponse.fromJson(json.decode(str));

class MyExpensesResponse {
  final int status;
  final int total;
  final List<Expense> expenses;

  MyExpensesResponse({
    required this.status,
    required this.total,
    required this.expenses,
  });

  factory MyExpensesResponse.fromJson(Map<String, dynamic> json) =>
      MyExpensesResponse(
        status: json["status"],
        total: json["total"],
        expenses: List<Expense>.from(
            json["expenses"].map((x) => Expense.fromJson(x))),
      );
}

class Expense {
  final int id;
  final int userId;
  final String amount;
  final int groupId;
  final String note;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.groupId,
    required this.note,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json["id"],
        userId: json["user_id"],
        amount: json["amount"],
        groupId: json["group_id"],
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}
