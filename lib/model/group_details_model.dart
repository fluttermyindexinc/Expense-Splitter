import 'package:expense_splitter/model/todo_model.dart';

class GroupDetailsResponse {
  final int status;
  final Group group;

  GroupDetailsResponse({required this.status, required this.group});

  factory GroupDetailsResponse.fromJson(Map<String, dynamic> json) {
    return GroupDetailsResponse(
      status: json['status'],
      group: Group.fromJson(json['group']),
    );
  }
}

class Group {
  final int id;
  final String name;
  final double totalExpenses;
  final int status;
  final List<Member> members;
  final List<Expense> expenses;
  final String link;
  final List<TodoModel> todos;

  Group({
    required this.id,
    required this.name,
    required this.totalExpenses,
    required this.status,
    required this.members,
    required this.expenses,
    required this.link,
    required this.todos,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      totalExpenses: json["total_expenses"]?.toDouble() ?? 0.0,
      status: json["status"] ?? 1,
      members: (json['members'] as List)
          .map((i) => Member.fromJson(i))
          .toList(),
      expenses: (json['expenses'] as List)
          .map((i) => Expense.fromJson(i))
          .toList(),
     todos: (json['todos'] as List? ?? []).map((i) => TodoModel.fromJson(i)).toList(),
    );
  }
}

class Member {
  final int id;
  final String name;
  final String username;
  final bool isAdmin;
  final String profileImage;
  final int balance;
  final int paidPercentage;

  Member({
    required this.id,
    required this.name,
    required this.username,
    required this.isAdmin,
    required this.profileImage,
    required this.balance,
    required this.paidPercentage,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      isAdmin: json['is_admin'],
      profileImage: json['profile_image'],
      balance: (json['balance'] as num).toInt(),
      paidPercentage: (json['paid_percentage'] as num).toInt(),
    );
  }
}

class Expense {
  final int id;
  final String note;
  final String amount;
  final User user;
  final String createdAt;

  Expense({
    required this.id,
    required this.note,
    required this.amount,
    required this.user,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      note: json['note'],
      amount: json['amount'],
      user: User.fromJson(json['user']),
      createdAt: json['created_at'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String profileImage;

  User({required this.id, required this.name, required this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? 'Unnamed User',
      profileImage: json['profile_image'] ?? '',
    );
  }
}
