import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/list_provider.dart';
import 'package:flutter_todo_app/provider/signup_provider.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';
import 'package:flutter_todo_app/utils/utils.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // final Map<String, dynamic> profileData = {
  //   'name': 'John Doe',
  //   'email': 'john@example.com',
  // };
  TextEditingController passwordController = TextEditingController();

  final fireStore = FirebaseFirestore.instance.collection("User Record");

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final signUpProvider = context.watch<SignupProvider>();
    final todoProvider = context.watch<ToDoProvider>();

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        backgroundColor: color.background,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "SignUp",
          style: TextStyle(fontSize: 20, color: color.onBackground),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                  color: color.onInverseSurface,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                focusNode: nameFocusNode,
                controller: signUpProvider.nameController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Name",
                    contentPadding: EdgeInsetsDirectional.all(8)),
                onFieldSubmitted: (value) {
                  return FocusScope.of(context).requestFocus(numberFocusNode);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                  color: color.onInverseSurface,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                focusNode: numberFocusNode,
                controller: signUpProvider.numberController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Mobile Number",
                    contentPadding: EdgeInsetsDirectional.all(8)),
                onFieldSubmitted: (value) {
                  return FocusScope.of(context).requestFocus(emailFocusNode);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                  color: color.onInverseSurface,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                focusNode: emailFocusNode,
                controller: signUpProvider.emailController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Email",
                    contentPadding: EdgeInsetsDirectional.all(8)),
                onFieldSubmitted: (value) {
                  return FocusScope.of(context).requestFocus(passwordFocusNode);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                  color: color.onInverseSurface,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                focusNode: passwordFocusNode,
                controller: passwordController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Password",
                    contentPadding: EdgeInsetsDirectional.all(8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(30),
                  color: color.onSurfaceVariant),
              height: 50,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  if (signUpProvider.nameController.text.isEmpty) {
                    Utils.showSnackbar("Please Enter Name", context);
                  } else if (signUpProvider.numberController.text.isEmpty) {
                    Utils.showSnackbar("Please Enter Number", context);
                  } else if (signUpProvider.emailController.text.isEmpty) {
                    Utils.showSnackbar("Please Enter Email", context);
                  } else if (passwordController.text.isEmpty) {
                    Utils.showSnackbar("Please Enter Password", context);
                  } else if (passwordController.text.length < 6) {
                    Utils.showSnackbar(
                        "Please Enter atleast 6 characters in your password",
                        context);
                  } else {
                    context.read<SignupProvider>().saveData();
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: signUpProvider.emailController.text,
                          password: passwordController.text,
                        )
                        .then((value) =>
                            Utils.showSnackbar("Signup Successfully", context))
                        .then((value) async {
                      todoProvider.setUserProfileData(
                          signUpProvider.emailController.text,
                          signUpProvider.nameController.text,
                          signUpProvider.emailController.text,
                          signUpProvider.numberController.text,
                          passwordController.text);
                    }).onError((error, stackTrace) {
                      log("$stackTrace");
                    }).then(
                      (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LogInScreen();
                            },
                          ),
                        );
                      },
                    );
                  }
                },
                child: Text(
                  "SignUp",
                  style: TextStyle(fontSize: 20, color: color.onInverseSurface),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
