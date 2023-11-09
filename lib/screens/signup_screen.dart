import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/common/common_button.dart';
import 'package:flutter_todo_app/common/common_textfield.dart';
import 'package:flutter_todo_app/constants/validator.dart';
import 'package:flutter_todo_app/provider/todo_provider.dart';
import 'package:flutter_todo_app/provider/signup_provider.dart';
import 'package:flutter_todo_app/screens/bottom_nav_screen.dart';
import 'package:flutter_todo_app/utils/utils.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController passwordController = TextEditingController();
  final List<TextInputFormatter> _inputFormatters = [
    LengthLimitingTextInputFormatter(10),
  ];

  final fireStore = FirebaseFirestore.instance.collection("User Record");

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final signUpProvider = context.watch<SignupProvider>();

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
            child: SizedBox(
                height: 50,
                child: CommonTextFormField(
                  controller: signUpProvider.nameController,
                  hintText: "Enter Name",
                  textInputAction: TextInputAction.next,
                  contentPadding: const EdgeInsets.only(
                    left: 10,
                  ),
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(12),
              child: CommonTextFormField(
                controller: signUpProvider.numberController,
                hintText: "Enter Number",
                inputFormatter: _inputFormatters,
                textInputAction: TextInputAction.next,
                contentPadding: const EdgeInsets.only(left: 10),
              )),
          Padding(
              padding: const EdgeInsets.all(12),
              child: CommonTextFormField(
                controller: signUpProvider.emailController,
                hintText: "Enter Email",
                textInputAction: TextInputAction.next,
                contentPadding: const EdgeInsets.only(
                  left: 10,
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(12),
              child: CommonTextFormField(
                controller: passwordController,
                hintText: "Enter Password",
                isPassword: true,
                obscureText: true,
                validator: (value) =>
                    Validator.validatePassword(passwordController.text),
                textInputAction: TextInputAction.next,
                contentPadding: const EdgeInsets.only(
                  left: 10,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: CommonButton(
              onPressed: () {
                signupAuth();
              },
              text: "SignUp",
              color: color.onBackground,
              fontSize: 20,
              textColor: color.background,
            ),
          ),
        ],
      ),
    );
  }

  void signupAuth() {
    final signUpProvider = Provider.of<SignupProvider>(context, listen: false);
    final todoProvider = Provider.of<ToDoProvider>(context, listen: false);

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
          "Please Enter atleast 6 characters in your password", context);
    } else {
      context
          .read<SignupProvider>()
          .saveData(signUpProvider.emailController.text);
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: signUpProvider.emailController.text,
            password: passwordController.text,
          )
          .then((value) => Utils.showSnackbar("Signup Successfully", context))
          .then((value) async {
        todoProvider.setUserProfileData(
            id: signUpProvider.emailController.text,
            nam: signUpProvider.nameController.text,
            mail: signUpProvider.emailController.text,
            no: signUpProvider.numberController.text,
            pass: passwordController.text);
      }).then((value) async {
        await context.read<ToDoProvider>().getUserProfileData();
      }).onError((error, stackTrace) {
        log("$stackTrace");
      }).then(
        (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const BottomNavScreen();
              },
            ),
          );
        },
      );
    }
  }
}
