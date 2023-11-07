import 'package:flutter/material.dart';
import 'package:flutter_todo_app/common/common_dropdown.dart';
import 'package:flutter_todo_app/provider/todo_provider.dart';
import 'package:flutter_todo_app/screens/bottom_nav_screen.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  DateTime selectedDateTime = DateTime.now();

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
                    onPressed: () => addTodoProvider.selectDateTime(context),
                  ),
                ),
              ),
            ),
            CustomDropDown(
                onSelectionChanged: addTodoProvider.onDropdownValueChanged),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  addTodoProvider.firebaseData().then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavScreen(),
                      )));
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
