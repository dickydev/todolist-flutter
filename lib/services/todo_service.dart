import 'dart:convert';

import 'package:todolist_flutter/models/todo.dart';
import 'package:http/http.dart' as http;

class TodoService {
  static const baseUrl = 'http://192.168.1.100:5000/todo/';

  static Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to fetch todos');
    }
  }

  static Future<void> addTodo(String task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'task': task, 'completed': false}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }

  static Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo');
    }
  }

  static Future<void> updateTodo(int id, String task) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'task': task}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }
}
