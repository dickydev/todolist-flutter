import 'package:flutter/material.dart';
import 'package:todolist_flutter/models/todo.dart';
import 'package:todolist_flutter/services/todo_service.dart';
import 'package:todolist_flutter/widgets/todo_item.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Future<List<Todo>> _todoList;
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _todoList = TodoService.fetchTodos();
  }

  void _addTodo() async {
    if (_taskController.text.isNotEmpty) {
      await TodoService.addTodo(_taskController.text);
      setState(() {
        _todoList = TodoService.fetchTodos();
      });
      _taskController.clear();
    }
  }

  void _deleteTodo(int id) async {
    await TodoService.deleteTodo(id);
    setState(() {
      _todoList = TodoService.fetchTodos();
    });
  }

  void _toggleComplete(Todo todo) async {
    await TodoService.updateTodo(todo.id, (!todo.completed) as String);
    setState(() {
      _todoList = TodoService.fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'New Task',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text('Add Task'),
          ),
          Expanded(
            child: FutureBuilder<List<Todo>>(
              future: _todoList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final todos = snapshot.data!;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoItem(
                        todo: todo,
                        onDelete: () => _deleteTodo(todo.id),
                        onToggleComplete: () => _toggleComplete(todo),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No tasks found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
