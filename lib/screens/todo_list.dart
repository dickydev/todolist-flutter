import 'package:flutter/material.dart';
import 'package:todolist_flutter/models/todo.dart';
import 'package:todolist_flutter/services/todo_service.dart';
import 'package:todolist_flutter/widgets/todo_tile.dart';

// import 'package:todolist_flutter/models/todo.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Todo> todos = await TodoService.fetchTodos();
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching todos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addTodo(String task) async {
    try {
      await TodoService.addTodo(task);
      _fetchTodos();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> _deleteTodo(int id) async {
    try {
      await TodoService.deleteTodo(id);
      _fetchTodos();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  Future<void> _updateTodo(int id, String task) async {
    try {
      await TodoService.updateTodo(id, task);
      _fetchTodos();
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _todos.isEmpty
              ? Center(child: Text('No todos found'))
              : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
                    return TodoTile(
                      todo: _todos[index],
                      onDelete: () => _deleteTodo(_todos[index].id),
                      onUpdate: (newTask) =>
                          _updateTodo(_todos[index].id, newTask),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? newTodo = await showDialog(
            context: context,
            builder: (context) {
              String todoText = '';
              return AlertDialog(
                title: Text('Add Todo'),
                content: TextField(
                  onChanged: (value) => todoText = value,
                  decoration: InputDecoration(hintText: 'Enter todo task'),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(todoText.trim());
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
          if (newTodo != null && newTodo.isNotEmpty) {
            _addTodo(newTodo);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
