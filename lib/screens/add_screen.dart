import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/list_provider.dart';
import 'package:provider/provider.dart';

class NewList extends StatefulWidget {
  const NewList({super.key});

  @override
  State<NewList> createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  @override
  Widget build(BuildContext context) {
    final addTodoProvider = Provider.of<ToDoProvider>(context);

    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Add New ToDo"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 25,
                  right: 25,
                ),
                child: TextField(
                    controller: addTodoProvider.listController,
                    decoration: InputDecoration(
                      hintText: "Add New ToDo",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () =>
                            addTodoProvider.selectDateTime(context),
                      ),
                    ))),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  addTodoProvider
                      .firebaseData()
                      .then((value) => Navigator.pop(context));
                },
                child: Text(
                  "Add ToDo",
                  style: TextStyle(color: color.onBackground),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
