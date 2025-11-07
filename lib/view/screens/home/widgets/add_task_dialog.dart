// lib/view/screens/home/widgets/add_task_dialog.dart

import 'package:flutter/material.dart';
import 'package:expense_splitter/api/todo_create_service.dart';

Future<bool?> showAddTaskDialog(BuildContext context, int groupId) {
  final TextEditingController taskController = TextEditingController();
  final TodoCreateService todoService = TodoCreateService();
  bool isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF0F2F5),
            title: const Text('Add a New Task'),
            content: TextField(
              controller: taskController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter task description'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(false),
                child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, foregroundColor: Colors.blueAccent),
                onPressed: isLoading ? null : () async {
                  final String taskName = taskController.text.trim();
                  if (taskName.isEmpty) return;

                  setState(() => isLoading = true);
                  try {
                    final response = await todoService.createTodo(
                      groupId: groupId,
                      name: taskName,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response.message), backgroundColor: Colors.green),
                      );
                      Navigator.of(context).pop(true); // Return true on success
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                      );
                      setState(() => isLoading = false);
                    }
                  }
                },
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Add Now'),
              ),
            ],
          );
        },
      );
    },
  );
}
