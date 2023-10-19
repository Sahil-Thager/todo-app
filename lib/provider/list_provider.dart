import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/variables_model.dart';
import 'package:flutter_todo_app/shared_prefrence/shared_prefrence.dart';

class ToDoProvider extends ChangeNotifier {
  ToDoProvider() {
    filteredList = docList;
  }
  final List<Variables> _list = [];

  List<Variables> get list => _list;

  final dd = Variables();

  Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> filteredList = [];

  List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> profileList = [];

  final fireStore = FirebaseFirestore.instance.collection("User Record");

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

  void filter(String text) async {
    filteredList = docList.where(
      (element) => element["title"].contains(text),
    );
    notifyListeners();
  }

  void reset() {
    filteredList = docList;
    notifyListeners();
  }

  bool isDone = false;
  Future<void> toggleItemSelection(
      QueryDocumentSnapshot<Map<String, dynamic>> data) async {
    await fireStore
        .doc(_email)
        .collection('todos')
        .doc(data.id)
        .update({"isDone": !data.data()["isDone"]});
    await todosData();
  }

  Future<void> toggleOffNotification(String id) async {
    try {
      await fireStore
          .doc(_email)
          .collection('todos')
          .doc(id)
          .update({"notificationTrigger10": true});
      await todosData();
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
  }

  void deleteToDoItem(index, id) {
    final aa = fireStore.doc(_email).collection('todos').doc(id);
    aa.delete();
    docList.removeAt(index);
    notifyListeners();
  }

  DateTime _selectedDateTime = DateTime.now();
  String get selectedDateTime => _selectedDateTime.toString();
  void setTimeAndDate(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        selectedDateTime;
        notifyListeners();
      }
    }
  }

  Future<void> getData() async {
    _name = await SharedPrefrencess.getString(StorageKeys.name);
    _email = await SharedPrefrencess.getString(StorageKeys.email);
    _number = await SharedPrefrencess.getString(StorageKeys.number);
    notifyListeners();
  }

  Future<void> todosData() async {
    final ss = await fireStore
        .doc(_email)
        .collection('todos')
        .orderBy("timestamp", descending: false)
        .get();
    filteredList = docList = ss.docs;
    // await deSerializeModel(filteredList.toList());
    notifyListeners();
  }

  // int compareTime(QueryDocumentSnapshot<Map<String, dynamic>> aa,
  //     QueryDocumentSnapshot<Map<String, dynamic>> bb) {
  //   final Timestamp timestampA = aa.data()["timestamp"];
  //   final Timestamp timestampB = bb.data()["timestamp"];

  //   final time = DateTime.now();
  //   final timeDiffernceA = time.difference(timestampA.toDate());
  //   final timeDiffernceB = time.difference(timestampB.toDate());
  //   final sortTime = timeDiffernceA.compareTo(timeDiffernceB);
  //   notifyListeners();

  //   return sortTime;
  // }

  bool notifi = false;
  Future<void> firebaseData() async {
    fireStore.doc(_email).collection('todos').add({
      "title": listController.text,
      "time": selectedDateTime,
      "isDone": isDone,
      "notificationTrigger10": false,
      "timestamp": DateTime.now(),
    });
    await todosData();
  }

  Future<void> profileData() async {
    final aa = await fireStore.doc(_email).collection("profiles").get();
    profileList = aa.docs;
    notifyListeners();
  }

  // Future<void> deSerializeModel(
  //     List<QueryDocumentSnapshot<Map<String, dynamic>>> myList) async {
  //   for (final i in docList) {
  //     _list.add(Variables.fromJson(i.data()));
  //   }
  //   notifyListeners();
  // }
}
