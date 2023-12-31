import 'package:flutter/material.dart';
import 'package:flutter_todo_app/common/enum.dart';
import 'package:flutter_todo_app/provider/todo_provider.dart';
import 'package:flutter_todo_app/screens/bottom_nav_screen.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController listController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

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
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 25,
                  right: 25,
                ),
                child: TextFormField(
                  controller: listController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      {
                        return "Please enter your todo";
                      }
                    }
                    return null;
                  },
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
              DropdownButtonHideUnderline(
                child: DropdownButton<SelectTime>(
                  value: addTodoProvider.selectedDropdownValue,
                  items: SelectTime.values.map((e) {
                    return DropdownMenuItem<SelectTime>(
                      value: e,
                      child: Text(e.value),
                    );
                  }).toList(),
                  onChanged: (value) => context
                      .read<ToDoProvider>()
                      .onDropdownValueChanged(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addTodoProvider.firebaseData(listController.text).then(
                            (value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomNavScreen(),
                              ),
                              (route) => false,
                            ),
                          );
                    }
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
      ),
    );
  }
}
