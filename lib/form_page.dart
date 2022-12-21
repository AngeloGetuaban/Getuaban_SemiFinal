import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pre_final_getuaban/Todo.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}
Todo todoFromJson(String str) {
  final jsonData = json.decode(str);
  return Todo.fromJson(jsonData);
}
String dataURL = 'https://jsonplaceholder.typicode.com';
Future<Todo?> postTodo(String title, bool status) async {
  var url = Uri.parse(dataURL);
  var bodyData = json.encode({'title': title, 'completed': status});
  var response = await http.post(url, body: bodyData);

  if (response.statusCode == 201) {
    print('Successfully added ToDo!');
    var display = response.body;
    print(display);
    String body = response.body;
    todoFromJson(body);
  } else {
    return null;
  }
}
class _FormPageState extends State<FormPage> {
  TextEditingController title = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Todo? todo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              TextFormField(
                controller: title,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    hintText: 'Ex. title', labelText: 'title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Successfully created ${title.text}, Status: false')));
                          Todo? data = await postTodo(title.text, false);
                          setState(() {
                            todo = data;
                          });
                        } else {
                          return null;
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('Submit')))
            ],
          )),
    );
  }
}
