import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/signup_provider.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();

    final signUpProvider = context.watch<SignupProvider>();

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
                controller: signUpProvider.nameController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Name",
                    contentPadding: EdgeInsetsDirectional.all(8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                controller: signUpProvider.numberController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Mobile Number",
                    contentPadding: EdgeInsetsDirectional.all(8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                controller: signUpProvider.emailController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Email",
                    contentPadding: EdgeInsetsDirectional.all(8)),
              ),
            ),
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
              ),
            ),
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
                  context.read<SignupProvider>().saveData();
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: signUpProvider.emailController.text,
                    password: passwordController.text,
                  )
                      .then(
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
                },
                child: const Text(
                  "SignUp",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
