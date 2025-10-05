import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // List of map for added task are here
  List<Map<String, dynamic>> tasks = [];
  bool showActiveTask = true;

  // Add Task Function are here
  void _addTask(String task) {
    setState(() {
      tasks.add({'task': task, 'completed': false});
      Navigator.pop(context);
    });
  }

  // Edit Task Function are here
  void _editTask(int index, String updateTask) {
    setState(() {
      tasks[index]['task'] = updateTask;
      Navigator.pop(context);
    });
  }

  // Task Dialog code are start here
  void _showTaskDialog({int? index}) {
    TextEditingController _taskController = TextEditingController(
      text: index != null ? tasks[index]['task'] : '',
    );

    // Show Dialog Related work are start here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(index != null ? 'Edit Task' : 'Add Task'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Enter Task'),
          controller: _taskController,
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),

          // save task Button
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.trim().isNotEmpty) {
                if (index != null) {
                  _editTask(index, _taskController.text);
                } else {
                  _addTask(_taskController.text);
                }
              }
            },
            child: Text(index != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
    // Show Dialog Related work are end here
  }

  // Task Dialog Code are end here

  // Active to Complete / Complete to Active toggle are here
  void toggleTaskStatus(int index) {
    setState(() {
      tasks[index]['completed'] = !tasks[index]['completed'];
    });
  }

  // Delete Task related work are here
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Completed and Active task are find there
  int get activeTask => tasks.where((task) => !task['completed']).length;

  int get completedTask => tasks.where((task) => task['completed']).length;

  @override
  Widget build(BuildContext context) {
    // Task Filter Related Work are here

    List<Map<String, dynamic>> filtedTask = tasks
        .where((task) => task['completed'] != showActiveTask)
        .toList();

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'TODO Application',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Heading Section or hero Section work are start here
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    showActiveTask = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        activeTask.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    showActiveTask = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        completedTask.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Heading Section or hero Section work end start here

          // List view builder for showing Task
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView.builder(
                itemCount: filtedTask.length,
                itemBuilder: (context, index) {
                  // Swap Related Work are here
                  return Dismissible(
                    key: Key(UniqueKey().toString()),
                    background: Container(
                      color: Colors.blue,
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        toggleTaskStatus(index);
                      } else {
                        deleteTask(index);
                      }
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                          filtedTask[index]['task'],
                          style: TextStyle(
                            decoration: filtedTask[index]['completed']
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        // Check box related work are here
                        leading: Checkbox(
                          shape: CircleBorder(),
                          value: filtedTask[index]['completed'],
                          onChanged: (value) => toggleTaskStatus(index),
                        ),
                        // Edit related work are here
                        trailing: IconButton(
                          onPressed: () => _showTaskDialog(index: index),
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: Icon(Icons.add, color: Colors.white, size: 24),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
