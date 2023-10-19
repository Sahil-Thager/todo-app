import 'package:flutter/material.dart';
import 'package:flutter_todo_app/shared_prefrence/shared_prefrence.dart';
import 'package:flutter_todo_app/state/states.dart';

class SignupProvider extends BaseChangeNotifier {
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _numberController = TextEditingController();
  TextEditingController get numberController => _numberController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  Future<void> saveData() async {
    try {
      loadingState();

      await SharedPrefrencess.setString(
        StorageKeys.email,
        _emailController.text,
      );
      await SharedPrefrencess.setString(
        StorageKeys.name,
        _nameController.text,
      );
      await SharedPrefrencess.setString(
        StorageKeys.number,
        _numberController.text,
      );

      loadedState();
    } catch (e) {
      failureState(e.toString());
    }
  }
}
