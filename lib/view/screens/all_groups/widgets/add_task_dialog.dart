import 'package:flutter/material.dart';

Future<String?> showAddTaskDialog(BuildContext context) {
  final TextEditingController taskController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(

        backgroundColor: const Color(0xFFF0F2F5),
        title: const Text('Add a New Task'),
        content: TextField(
          controller: taskController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter task description',

            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(

            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
             style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, 
              foregroundColor: Colors.blueAccent, 
            ),
            onPressed: () {
              final String task = taskController.text.trim();
              if (task.isNotEmpty) {
                Navigator.of(context).pop(task); 
              }
            },
            child: const Text('Add Now'),
          ),
        ],
      );
    },
  );
}
