import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/home.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter Login id",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "please enter Password";
                  }

                  return null;
                }),
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter Password",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Home();
                      }));
                    }
                  },
                  child: const Text("Login")),
            )
          ],
        ),
      ),
    );
  }
}
