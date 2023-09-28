import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static toastMessage(String messade) {
    Fluttertoast.showToast(
      msg: messade,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 50,
    );
  }

  static showSnackbar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
