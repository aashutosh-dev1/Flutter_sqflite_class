import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sql_app/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final isCompleteController = TextEditingController();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  Future<List<Map<String, dynamic>>> fetchTodo() async {
    todos = await databaseHelper.getTodos();
    setState(() {});
    return todos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(DatabaseHelper.databaseName),
        backgroundColor: Colors.yellow,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: titleController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Enter your todo!",
                labelText: "Todo",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                await databaseHelper.insertTodo(
                  titleController.text,
                );
                titleController.clear();
                await fetchTodo();
              },
              icon: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save_as_outlined,
                    size: 32.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Save todo',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              )),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                elevation: 4,
                color: Colors.grey[200],
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(
                              todo['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              //TODO ADD DELETE LOGIC HERE
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Completed: ${todo['isCompleted'] == 1 ? 'Yes' : 'No'}',
                            style: TextStyle(
                              color: todo['isCompleted'] == 1
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              todo['isCompleted'] == 1
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: todo['isCompleted'] == 1
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              //TODO ADD UPDATE LOGIC HERE
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: todos.length,
          ))
        ],
      ),
    );
  }
}
