import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/todo.dart';
import 'package:flutter_todo_app/shared_prefrence/shared_prefrence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoProvider extends ChangeNotifier {
  ToDoProvider() {
    _filteredList = _todos;
  }
  final List<ToDo> _todos = [];
  Iterable<ToDo> _filteredList = [];

  Iterable<ToDo> get filteredTodoList => _filteredList;

  final TextEditingController _listConstroller = TextEditingController();
  TextEditingController get listController => _listConstroller;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  String _name = '';
  String get name => _name;

  String _email = '';
  String get email => _email;

  String _number = '';
  String get number => _number;

  void filter(String text) {
    _filteredList = _todos.where((e) => e.todoText?.contains(text) ?? false);
    notifyListeners();
  }

  void reset() {
    _filteredList = _todos;
    notifyListeners();
  }

  void toggleItemSelection(int index) {
    _todos[index].isDone = !_todos[index].isDone;
    notifyListeners();
  }

  void deleteToDoItem(index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  Future<void> addToDoItem() async {
    Future.delayed(const Duration(seconds: 3));
    _todos.add(ToDo(
      todoText: _listConstroller.text,
      date: _selectedDateTime,
    ));

    notifyListeners();
  }

  DateTime _selectedDateTime = DateTime.now();
  String get selectedDateTime => _selectedDateTime.toString();
  void setTimeAndDate(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

  // void login(VoidCallback callback) {
  //   FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: _emailController.text,
  //     password: _passwordController.text,
  //   );
  //   callback.call();
  // }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString(Keys.name.toString()) ?? '';
    _email = prefs.getString(Keys.email.toString()) ?? '';
    _number = prefs.getString(Keys.number.toString()) ?? '';
  }
}
