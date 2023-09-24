import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/home.dart';
import 'package:flutter_todo_app/screens/signup_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
//crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  controller: emailController,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "please enter login id";
                    }
                    if (!EmailValidator.validate(value)) {
                      return "Please Enter a Valid E-mail Address";
                    }
                    return null;
                  }),
                  decoration: const InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      contentPadding: EdgeInsets.only(left: 5),
                      border: InputBorder.none,
                      hintText: "Enter Login id",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  controller: passwordController,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "please enter Password";
                    }

                    return null;
                  }),
                  obscureText: true,
                  decoration: const InputDecoration(
                      icon: Icon(CupertinoIcons.padlock),
                      contentPadding: EdgeInsets.only(left: 5),
                      border: InputBorder.none,
                      hintText: "Enter Password",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.black),
                child: ElevatedButton(
                    onPressed: () {
                      try {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value) {
                          if (_formkey.currentState!.validate()) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const Home();
                            }));
                          }
                        });
                      } catch (e) {
                        log('An Exception Occured:$e');
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "or",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "Do not have any account please Signup",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 18),
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(25)),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignupScreen();
                      }));
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
