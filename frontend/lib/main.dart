import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Todo App', home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<dynamic> todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final response = await http.get(Uri.parse('http://localhost:8000/todos/'));
    if (response.statusCode == 200) {
      setState(() => todos = json.decode(response.body));
    }
  }

  Future<void> addTodo() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/todos/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': _controller.text, 'completed': false}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      _controller.clear();
      fetchTodos();
    }
  }

  Future<void> deleteTodo(int id) async {
    await http.delete(Uri.parse('http://localhost:8000/todos/$id'));
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(onPressed: addTodo, icon: Icon(Icons.add)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo['title']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTodo(todo['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
