import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "SignUp",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Name",
                      contentPadding: EdgeInsetsDirectional.all(8)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Mobile Number",
                      contentPadding: EdgeInsetsDirectional.all(8)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Email",
                      contentPadding: EdgeInsetsDirectional.all(8)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Password",
                      contentPadding: EdgeInsetsDirectional.all(8)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black),
                height: 50,
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LogInScreen();
                        }));
                      });
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ))),
          ),
        ],
      ),
    );
  }
}
