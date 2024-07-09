import 'package:flutter/material.dart';
import 'package:todolist_flutter/models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onDelete;
  final Function(String) onUpdate;

  const TodoTile({
    required this.todo,
    required this.onDelete,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todo.task,
        style: TextStyle(
          decoration: todo.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              String? newTask = await showDialog(
                context: context,
                builder: (context) {
                  String updatedTask = todo.task;
                  return AlertDialog(
                    title: Text('Edit Todo'),
                    content: TextField(
                      onChanged: (value) => updatedTask = value,
                      controller: TextEditingController(text: todo.task),
                      decoration:
                          InputDecoration(hintText: 'Enter updated task'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(updatedTask.trim());
                        },
                        child: Text('Update'),
                      ),
                    ],
                  );
                },
              );
              if (newTask != null && newTask.isNotEmpty) {
                onUpdate(newTask);
              }
            },
          ),
        ],
      ),
    );
  }
}
