import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/list_provider.dart';
import 'package:flutter_todo_app/screens/home.dart';
import 'package:flutter_todo_app/screens/signup_screen.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formkey = GlobalKey<FormState>();
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
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: context.watch<ToDoProvider>().emailController,
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
                    contentPadding: EdgeInsets.only(left: 5),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: "Enter Login id",
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: context.watch<ToDoProvider>().passwordController,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "please enter Password";
                  }
                  return null;
                }),
                obscureText: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    hintText: "Enter Password",
                    hintStyle: TextStyle(color: Colors.black)),
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
                      if (_formkey.currentState!.validate()) {
                        context.read<ToDoProvider>().login(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ));
                        });
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
