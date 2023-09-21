import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/todo.dart';

class ToDoProvider extends ChangeNotifier {
  ToDoProvider() {
    _filteredList = _todos;
  }
  final List<ToDo> _todos = [];
  Iterable<ToDo> _filteredList = [];

  Iterable<ToDo> get filteredTodoList => _filteredList;

  final TextEditingController _listConstroller = TextEditingController();
  TextEditingController get listController => _listConstroller;

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
}
