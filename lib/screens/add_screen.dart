import 'package:flutter/cupertino.dart';
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add New ToDo"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                onDateTimeChanged: context.read<ToDoProvider>().setTimeAndDate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 25,
                right: 25,
              ),
              child:
                  Consumer<ToDoProvider>(builder: (context, provider, child) {
                return TextField(
                  controller: provider.listController,
                  decoration: InputDecoration(
                    hintText: "Add New ToDo",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  addTodoProvider
                      .addToDoItem()
                      .then((value) => Navigator.pop(context));
                },
                child: const Text("Add ToDo"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
