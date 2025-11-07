// lib/view/screens/home/todo_list_page.dart

import 'package:flutter/material.dart';
import 'package:expense_splitter/model/todo_model.dart';
import 'package:expense_splitter/api/todo_update_service.dart';
import 'package:expense_splitter/view/screens/home/widgets/add_task_dialog.dart';

class TodoListPage extends StatefulWidget {
  final int groupId;
  final List<TodoModel> initialTodos;

  const TodoListPage({
    super.key,
    required this.groupId,
    required this.initialTodos,
  });

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> with SingleTickerProviderStateMixin {
  late List<TodoModel> _tasks;
  late TabController _tabController;
  final TodoUpdateService _updateService = TodoUpdateService();

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.initialTodos);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TodoModel> get _pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<TodoModel> get _completedTasks => _tasks.where((task) => task.isCompleted).toList();

  Future<void> _openAddTaskDialog() async {
    final bool? taskWasAdded = await showAddTaskDialog(context, widget.groupId);
    // If a task was added, we pop this page and signal the parent to refresh.
    if (taskWasAdded == true && mounted) {
      Navigator.of(context).pop(true); // Return 'true' to CreatedGroupPage
    }
  }

  void _toggleTaskCompletion(TodoModel task) async {
    final originalStatus = task.status;
    // Update the UI optimistically
    setState(() {
      task.status = task.isCompleted ? 0 : 1;
    });

    try {
      await _updateService.updateTodoStatus(
        taskId: task.id,
        isCompleted: task.isCompleted,
      );
    } catch (e) {
      // If the API call fails, revert the state and show an error
      setState(() {
        task.status = originalStatus;
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update task: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Todo Tasks'),
        // backgroundColor: const Color.fromARGB(234, 0, 41, 118),
        flexibleSpace:Container(
decoration:BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/blueeee.jpg'), fit: BoxFit.cover),) ) ,
        
          
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: 'Pending'), Tab(text: 'Completed')],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            // Replace with your desired background image asset
            image: AssetImage('assets/images/change-modified.jpg'), 
            fit: BoxFit.cover, // This will cover the entire screen
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTaskList(_pendingTasks, 'All tasks have been completed!. Great job!'),
            _buildTaskList(_completedTasks, 'No completed tasks yet.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskDialog,
        backgroundColor: const Color(0xFFFF013A),
        tooltip: 'Add Task',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskList(List<TodoModel> tasks, String emptyListMessage) {
    if (tasks.isEmpty) {
      return Center(child: Text(emptyListMessage));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          color: Colors.white,
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            onTap: () => _toggleTaskCompletion(task),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) => _toggleTaskCompletion(task),
              activeColor: Colors.green,
            ),
            title: Text(
              task.task,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              'Assigned by: ${task.assignedTo.name}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 0),
    );
  }
}
