import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/variables_model.dart';
import 'package:flutter_todo_app/shared_prefrence/shared_prefrence.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    notifyListeners();
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

  Future<void> deleteToDoItem(index, id) async {
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
      if (!context.mounted) return;

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
        setTimeAndDate(selectedDateTime);
        notifyListeners();
      }
    }
  }

  Future<void> getData() async {
    _name = await CustomSharedPrefrences.getString(StorageKeys.name);
    _email = await CustomSharedPrefrences.getString(StorageKeys.email);
    _number = await CustomSharedPrefrences.getString(StorageKeys.number);
    log('Get  data ran');
    notifyListeners();
  }

  Future<void> todosData() async {
    final ss = await fireStore
        .doc(_email)
        .collection('todos')
        .orderBy("timestamp", descending: false)
        .get();
    filteredList = docList = ss.docs;
    log("this is run");
    notifyListeners();
  }

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

  User? user;

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();

    if (googleSignInAccount == null) {
      return null;
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    user = authResult.user;

    if (user != null) {
      log('User signed in: ${user?.displayName ?? "null"}');
    } else {
      log('Sign-in failed');
    }

    return user;
  }

  Future<void> signout() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      } else {
        await auth.signOut();
      }
    } catch (e) {
      log('Error signing out: $e');
    }
  }

  Future<void> setUserProfileData(
      String id, String nam, String mail, String no, String pass) async {
    await fireStore.doc(id).set({
      'profile': {
        "Name": nam,
        "Mobile": mail,
        "Email": no,
        "Password": pass,
        "uid": id,
      },
    });
    notifyListeners();
  }

  Future<void> signOutGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }
  // Future<void> setDataWithGoogle() async{
  // final User? user = authResult.user;

  // }

  Map<String, dynamic>? profile;
  Future<void> getUserProfileData() async {
    final data = await fireStore.doc(_email).get();
    profile = data.data();
    log(list.toString());
    log(data.toString());
    notifyListeners();
  }
}
