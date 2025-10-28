// lib/screens/todo_list_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Make sure this path points to your reusable dialog file
import 'package:expense_splitter/view/screens/all_groups/widgets/add_task_dialog.dart';

// A simple class to represent a task
class _Task {
  String description;
  bool isCompleted;

  _Task({required this.description, this.isCompleted = false});
}

// A reusable, transparent AppBar
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;

//   const CustomAppBar({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       toolbarHeight: 80,
//        flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: [const Color.fromARGB(234, 13, 78, 197),const Color.fromARGB(234, 0, 19, 53)])
//           ),
//         ),
//       elevation: 0,
//       iconTheme: const IconThemeData(
//         color: Colors.white,
//       ), // Makes the back arrow white
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

class TodoListPage extends StatefulWidget {
  final String? initialTask;

  const TodoListPage({super.key, this.initialTask});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<_Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null && widget.initialTask!.isNotEmpty) {
      _tasks.add(_Task(description: widget.initialTask!));
    }
  }

  List<_Task> get _activeTasks =>
      _tasks.where((task) => !task.isCompleted).toList();
  List<_Task> get _closedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  void _openAddTaskDialog() async {
    final newTaskDescription = await showAddTaskDialog(context);
    if (newTaskDescription != null) {
      setState(() {
        _tasks.insert(0, _Task(description: newTaskDescription));
      });
    }
  }

  void _toggleTaskCompletion(_Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  // FIX: New method to permanently delete a task
  void _deleteTask(_Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light grey background
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(234, 0, 41, 118),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(234, 13, 78, 197),
                const Color.fromARGB(234, 0, 19, 53),
              ],
            ),
          ),
        ),
        toolbarHeight: 80,
        title: const Text(
          'Todo Tasks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        foregroundColor: Colors.white,
      ),

      // extendBodyBehindAppBar: true,
      // appBar: const CustomAppBar(title: 'Todo List'),
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(
        //       'assets/images/change-modified.jpg',
        //     ), // Your background image
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Active Tasks Section ---
                const Text(
                  'Active Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _activeTasks.isEmpty
                        ? const Center(
                            child: Text(
                              'No active tasks. Great job!',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _activeTasks.length,
                            itemBuilder: (context, index) {
                              final task = _activeTasks[index];
                              // FIX: Use a custom ListTile for more control
                              return ListTile(
                                onTap: () => _toggleTaskCompletion(task),
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (bool? value) =>
                                      _toggleTaskCompletion(task),
                                  activeColor: Colors.green,
                                  checkColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                ),
                                title: Text(
                                  task.description,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => _deleteTask(task),
                                  tooltip: 'Delete Task',
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.white24,
                              indent: 16,
                              endIndent: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Closed Tasks Section ---
                const Text(
                  'Closed Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _closedTasks.isEmpty
                        ? const Center(
                            child: Text(
                              'No completed tasks yet.',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _closedTasks.length,
                            itemBuilder: (context, index) {
                              final task = _closedTasks[index];
                              // FIX: Use a custom ListTile here as well
                              return ListTile(
                                onTap: () => _toggleTaskCompletion(task),
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (bool? value) =>
                                      _toggleTaskCompletion(task),
                                  activeColor: Colors.grey,
                                  side: const BorderSide(color: Colors.grey),
                                ),
                                title: Text(
                                  task.description,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Color.fromARGB(255, 137, 0, 0),
                                  ),
                                  onPressed: () => _deleteTask(task),
                                  tooltip: 'Delete Task',
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.white24,
                              indent: 16,
                              endIndent: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 617.0),
        child: SizedBox(
          width: 40.0,
          height: 40.0,
          child: FloatingActionButton(
            backgroundColor: Colors.black54,
            onPressed: _openAddTaskDialog,
            tooltip: 'Add Task',
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
