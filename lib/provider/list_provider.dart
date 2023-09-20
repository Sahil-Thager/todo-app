import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    // TODO: Wrong implementation. Should follow immutable state pattern
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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("logo");

  void initializeNotifications() {
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotifications(String title, String body) {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.high, priority: Priority.high);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}
