import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'Todo.dart';
import 'form_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
String dataURL = 'https://jsonplaceholder.typicode.com';
Future<List<Todo>> getTodoList() async {
  List<Todo> todoList = [];
  //https://jsonplaceholder.typicode.com/todos
  var url = Uri.parse('$dataURL/todos');
  var response = await http.get(url);
  print('status code : ${response.statusCode}');
  var body = json.decode(response.body);
  for (var i = 0; i < body.length; i++) {
    todoList.add(Todo.fromJson(body[i]));
  }
  return todoList;
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getTodoList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: getTodoList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              var todo = snapshot.data![index];
              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Title: ${todo.title}'),
                      content: Text('Userid: ${todo.userId}, Id: ${todo.id}, Completed: ${todo.completed} '),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            color: Colors.grey,
                            padding: const EdgeInsets.all(14),
                            child: const Text("okay"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('${todo.title}'),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 0.5,
                height: 0.5,
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FormPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
