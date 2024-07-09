import 'package:flutter/material.dart';
import 'package:todolist_flutter/models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  const TodoItem({
    required this.todo,
    required this.onDelete,
    required this.onToggleComplete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            todo.completed ? Icons.check_box : Icons.check_box_outline_blank,
            color: todo.completed ? Colors.green : Colors.grey,
          ),
          onPressed: onToggleComplete,
        ),
        title: Text(
          todo.task,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
